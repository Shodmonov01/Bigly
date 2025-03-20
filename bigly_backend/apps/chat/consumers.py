import json
from urllib.parse import urlunparse

from channels.generic.websocket import AsyncWebsocketConsumer
from django.http import HttpRequest

from apps.chat.models import Chat, Message, MessageRead
from apps.chat.serializers import MessageSerializer


class CustomHttpRequest(HttpRequest):
    def __init__(self, scope):
        super().__init__()
        self.method_scheme = "https" if scope.get('secure') else "http"
        self._host = dict(scope['headers']).get(b'host').decode()

    def build_absolute_uri(self, location=None):
        base_url = urlunparse((self.method_scheme, self._host, '', '', '', ''))
        if location:
            return base_url + location
        return base_url


class ChatConsumer(AsyncWebsocketConsumer):

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.chat = None
        self.user = None
        self.chat_id = None
        self.room_group_name = None

    async def connect(self):
        self.chat_id = self.scope['url_route']['kwargs']['chat_id']
        self.chat = await self.get_chat(self.chat_id)
        self.user = self.scope['user']

        if not self.chat or not self.scope['user'].is_authenticated:
            await self.close()

        self.room_group_name = 'chat_%s' % self.chat_id
        await self.channel_layer.group_add(self.room_group_name, self.channel_name)
        await self.accept()

    async def disconnect(self, close_code):
        await self.channel_layer.group_discard(self.room_group_name, self.channel_name)

    async def receive(self, text_data=None, bytes_data=None):
        text_data_json = json.loads(text_data)
        message_text = text_data_json.get('message', None)
        media = text_data_json.get('media', None)
        media_type = text_data_json.get('media_type', None)
        media_aspect_ratio = text_data_json.get('media_aspect_ratio', None)
        if message_text or media:
            message = await Message.objects.acreate(
                chat=self.chat,
                sender=self.user,
                content=message_text,
                media=media,
                media_type=media_type,
                media_aspect_ratio=media_aspect_ratio,
                thumbnail=f'{media}_thumbnail.jpg' if media and media_type == 'video' else None
            )
            await MessageRead.objects.acreate(message=message, user=self.user)

            await self.channel_layer.group_send(
                self.room_group_name,
                {
                    'type': 'chat_message',
                    'message': message
                }
            )

    async def chat_message(self, event):
        message_serializer = MessageSerializer(event['message'], context={'request': CustomHttpRequest(self.scope)})
        await self.send(text_data=json.dumps({
            'message': message_serializer.data,
            'user': event['message'].sender.username
        }))

    @staticmethod
    async def get_chat(chat_id):
        try:
            return await Chat.objects.aget(id=chat_id)
        except Chat.DoesNotExist:
            return None

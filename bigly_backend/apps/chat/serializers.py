import ffmpeg
from django.core.files.storage import default_storage
from django.core.files.base import File
from django.core.files.uploadedfile import TemporaryUploadedFile
from rest_framework import serializers
from rest_framework.generics import get_object_or_404
from drf_spectacular.utils import extend_schema_field

from config.utils import TimestampField
from .models import Chat, Message, ChatSetting
from apps.accounts.models import User, Follow
from apps.accounts.serializers import UserListSerializer
from apps.content_plan.models import Subscription, ContentPlan


class MessageSerializer(serializers.ModelSerializer):
    sender_username = serializers.CharField(read_only=True, source='sender.username')
    created_at = TimestampField(read_only=True)
    
    class Meta:
        model = Message
        fields = [
            'id', 'sender_username', 'content', 'media', 'media_type', 'thumbnail', 'media_aspect_ratio', 'created_at'
        ]


class PaginatedMessageSerializer(serializers.Serializer):
    count = serializers.IntegerField(help_text="Total number of items")
    next = serializers.CharField(allow_null=True, help_text="URL of the next page", required=False)
    previous = serializers.CharField(allow_null=True, help_text="URL of the previous page", required=False)
    results = MessageSerializer(many=True, read_only=True)



class ChatSerializer(serializers.ModelSerializer):
    is_request = serializers.BooleanField(required=False, default=False)
    participants = UserListSerializer(many=True, read_only=True)
    owner = UserListSerializer(read_only=True)
    name = serializers.SerializerMethodField(read_only=True)
    image = serializers.SerializerMethodField(read_only=True)
    created_at = TimestampField(read_only=True)

    class Meta:
        model = Chat
        fields = [
            'id', 'name', 'image', 'owner', 'participants', 'is_group', 'is_request', 'created_at'
        ]

    def get_name(self, obj) -> str:
        if obj.is_group:
            return obj.name
        user = self.context['request'].user
        participant = obj.participants.exclude(id=user.id).first()
        if participant and participant.last_name:
            return f'{participant.first_name} {participant.last_name}'
        return participant.first_name if participant else 'Noname'

    @extend_schema_field(serializers.URLField())
    def get_image(self, obj):
        request = self.context.get('request')
        if obj.is_group:
            return request.build_absolute_uri(obj.image.url) if obj.image else None
        user = self.context['request'].user
        participant = obj.participants.exclude(id=user.id).first()
        if participant and participant.profile_picture:
            return request.build_absolute_uri(participant.profile_picture.url)
        return None


class ChatListSerializer(ChatSerializer):
    TYPE = [
        ('superhero', 'Superhero'),
        ('subscriber', 'Subscriber'),
        ('follower', 'Follower'),
        ('group', 'Group'),
    ]
    username = serializers.CharField(write_only=True, help_text='Username of the participant')
    type = serializers.SerializerMethodField(read_only=True)
    new_message_count = serializers.SerializerMethodField(read_only=True)
    last_message = serializers.SerializerMethodField(read_only=True)

    class Meta:
        model = Chat
        fields = [
            'id', 'is_group', 'username', 'type', 'name', 'image', 'new_message_count', 'is_request', 'last_message', 'created_at'
        ]

    def validate_username(self, value):
        user = self.context['request'].user
        if user.username == value:
            raise serializers.ValidationError('You can not send message to yourself')
        if Chat.objects.filter(participants__username=value, is_group=False).filter(
                participants__username=user.username
        ).exists():
            raise serializers.ValidationError('Chat already exists')
        return value

    def create(self, validated_data):
        username = validated_data.pop('username')
        participant_user = get_object_or_404(User, username=username)
        chat = Chat.objects.create(
            is_request=validated_data.get('is_request'),
            request_user=self.context['request'].user if validated_data.get('is_request') else None,
        )
        chat.participants.add(participant_user, self.context['request'].user)
        return chat

    @extend_schema_field(serializers.ChoiceField(choices=TYPE))
    def get_type(self, obj) -> str | None:
        if obj.is_group:
            return 'group'
        user = self.context['request'].user
        participant = obj.participants.exclude(id=user.id).first()
        if Subscription.objects.filter(user=user, content_plan__user=participant).exists():
            return 'superhero'
        elif Subscription.objects.filter(user=participant, content_plan__user=user).exists():
            return 'subscriber'
        elif Follow.objects.filter(follower=participant, following=user).exists():
            return 'follower'
        return None

    @extend_schema_field(MessageSerializer())
    def get_last_message(self, obj) -> str:
        _last_message = obj.messages.first()
        serializer = MessageSerializer(_last_message, context=self.context)
        return serializer.data if _last_message else None

    @extend_schema_field(serializers.IntegerField())
    def get_new_message_count(self, obj):
        user = self.context['request'].user
        unread_messages = Message.objects.filter(chat=obj).exclude(read_by__user=user)
        return unread_messages.count()


class CreateGroupSerializer(ChatSerializer):
    group_name = serializers.CharField(write_only=True, required=False)
    group_image = serializers.ImageField(write_only=True, required=False)
    content_plan_id = serializers.IntegerField(write_only=True, required=False)
    user_id_list = serializers.ListField(child=serializers.IntegerField(), write_only=True, required=False)

    class Meta:
        model = Chat
        fields = [
            'id', 'group_name', 'group_image', 'content_plan_id', 'user_id_list', 'name', 'image', 'owner',
            'participants', 'is_group', 'created_at',
        ]

    def create(self, validated_data):
        group_name = validated_data.pop('group_name', None)
        group_image = validated_data.pop('group_image', None)
        content_plan_id = validated_data.pop('content_plan_id', None)
        user_id_list = validated_data.pop('user_id_list', [])
        chat = Chat.objects.create(name=group_name, image=group_image, is_group=True, owner=self.context['request'].user)
        chat.participants.add(self.context['request'].user)
        for user_id in user_id_list:
            user = get_object_or_404(User, id=user_id)
            chat.participants.add(user)
        if content_plan_id:
            content_plan = get_object_or_404(ContentPlan, id=content_plan_id)
            plan_users = User.objects.filter(subscription__content_plan=content_plan)
            for user in plan_users:
                if not chat.participants.filter(id=user.id).exists():
                    chat.participants.add(user)
        return chat


class MediaSerializer(serializers.Serializer):
    media = serializers.FileField()

    def create(self, validated_data):
        return validated_data

    def validate(self, attrs):
        temporary_file: TemporaryUploadedFile = attrs.get('media')
        file_path = default_storage.save(f'messages/{temporary_file.name}', temporary_file)
        file: File = default_storage.open(file_path)
        thumbnail_path = file.name + '_thumbnail.jpg'
        ffmpeg.input(file.name, ss=1).output(thumbnail_path, vframes=1).run(capture_stdout=True, capture_stderr=True)
        return {'media': file_path}


class ChatSettingSerializer(serializers.ModelSerializer):
    response_permissions = serializers.JSONField()

    class Meta:
        model = ChatSetting
        fields = ('message_first_permission', 'response_permissions')

    @staticmethod
    def validate_response_permissions(value):
        if not ('follower' in value or 'subscriber' in value or 'superhero' in value):
            raise serializers.ValidationError('Invalid response permissions')
        return value

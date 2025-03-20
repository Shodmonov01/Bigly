from django.db import models

from apps.accounts.models import User
from config.utils import CustomAutoField


class Chat(models.Model):
    id = CustomAutoField(primary_key=True, editable=False, start_value=10 ** 6 + 1)
    name = models.CharField(max_length=255, null=True)
    image = models.ImageField(upload_to='chats/images/', null=True)
    owner = models.ForeignKey(User, related_name='owned_chats', on_delete=models.SET_NULL, null=True, db_index=True)
    participants = models.ManyToManyField(User, related_name='chats')
    is_group = models.BooleanField(default=False)
    is_request = models.BooleanField(default=False)
    request_user = models.ForeignKey(User, related_name='request_chats', on_delete=models.SET_NULL, null=True,
                                     db_index=True)
    created_at = models.DateTimeField(auto_now_add=True, db_index=True)

    class Meta:
        db_table = 'chats'
        verbose_name = 'chat'
        verbose_name_plural = 'chats'
        ordering = ('-created_at',)


class Message(models.Model):

    class MessageMediaTypeEnum(models.TextChoices):
        IMAGE = 'image', 'Image'
        VIDEO = 'video', 'Video'
        FILE = 'file', 'File'
        VOICE = 'voice', 'Voice'

    id = CustomAutoField(primary_key=True, editable=False)
    chat = models.ForeignKey(Chat, related_name='messages', on_delete=models.CASCADE, db_index=True)
    sender = models.ForeignKey(User, related_name='messages', on_delete=models.SET_NULL, null=True, db_index=True)
    content = models.TextField(null=True)
    media = models.FileField(upload_to='messages/media/', null=True)
    media_type = models.CharField(max_length=10, choices=MessageMediaTypeEnum, null=True)
    thumbnail = models.FileField(upload_to='messages/media/', null=True)
    media_aspect_ratio = models.FloatField(null=True)
    created_at = models.DateTimeField(auto_now_add=True, db_index=True)

    class Meta:
        db_table = 'messages'
        verbose_name = 'message'
        verbose_name_plural = 'messages'
        ordering = ('-created_at',)


class MessageRead(models.Model):
    id = CustomAutoField(primary_key=True, editable=False)
    message = models.ForeignKey(Message, related_name='read_by', on_delete=models.CASCADE, db_index=True)
    user = models.ForeignKey(User, related_name='read_messages', on_delete=models.CASCADE, db_index=True)
    created_at = models.DateTimeField(auto_now_add=True, db_index=True)

    class Meta:
        db_table = 'message_reads'
        verbose_name = 'message read'
        verbose_name_plural = 'message reads'
        ordering = ('created_at',)


class ChatSetting(models.Model):

    class MessageFirstChoicesEnum(models.TextChoices):
        SUPERHERO = 'superhero', 'Superhero'
        NOBODY = 'nobody', 'Nobody'

    id = CustomAutoField(primary_key=True, editable=False)
    user = models.OneToOneField(User, related_name='chat_settings', on_delete=models.CASCADE, db_index=True)
    message_first_permission = models.CharField(max_length=10, choices=MessageFirstChoicesEnum,
                                                default=MessageFirstChoicesEnum.SUPERHERO)
    default_permissions = lambda : dict({'superhero': True, 'subscriber': True, 'follower': True})
    response_permissions = models.JSONField(default=default_permissions)

    class Meta:
        db_table = 'chat_settings'
        verbose_name = 'chat setting'
        verbose_name_plural = 'chat settings'

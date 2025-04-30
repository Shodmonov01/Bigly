from django.db import models
from django.db.models.signals import post_save
from django.dispatch import receiver
from fcm_django.models import FCMDevice, FCMDeviceQuerySet

from apps.accounts.models import User
from config.utils import CustomAutoField

import firebase_admin
from firebase_admin import credentials

cred = credentials.Certificate('config/firebase/credentials.json')

# Initialize only once
default_app = firebase_admin.initialize_app(cred)



class Notification(models.Model):

    class NotificationTypeEnum(models.TextChoices):
        FOLLOW = 'follow', 'Follow'
        CONTENT = 'content', 'Content'
        MENTION = 'mention', 'Mention'

    id = CustomAutoField(primary_key=True, editable=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='notifications')
    title = models.CharField(max_length=255)
    body = models.TextField()
    type = models.CharField(max_length=10, choices=NotificationTypeEnum)
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        db_table = 'notifications'
        verbose_name = 'notification'
        verbose_name_plural = 'notifications'
        ordering = ('-created_at',)

    def __str__(self):
        return f'@{self.user.username}: {self.title}'

from firebase_admin.messaging import Message
from firebase_admin.messaging import Notification as FirebaseNotification

@receiver(post_save, sender=Notification)
def notify_user(sender, instance, created, **kwargs):
    if created:
        try:

            devices: FCMDeviceQuerySet = FCMDevice.objects.filter(user=instance.user)
            print(devices, 'devices')
            for device in devices:
                print(device, 'device')
                message = Message(
                    notification=FirebaseNotification(
                        title=instance.title,
                        body=instance.body
                    ),
                    token=device.registration_id  # Ensure this is a valid FCM token
                )
                
                device.send_message(message)


            # devices.send_message(title=instance.title, message=instance.body, data={'type': instance.type})
            
        except Exception as e:
            print({'error': e})

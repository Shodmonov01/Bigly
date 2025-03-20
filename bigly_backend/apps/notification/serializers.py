from fcm_django.models import FCMDevice
from rest_framework import serializers

from apps.notification.models import Notification
from config.utils import TimestampField


class NotificationSerializer(serializers.ModelSerializer):
    created_at = TimestampField(read_only=True)

    class Meta:
        model = Notification
        fields = ('id', 'title', 'body', 'type', 'created_at')


class FCMDeviceSerializer(serializers.ModelSerializer):

    class Meta:
        model = FCMDevice
        fields = ('name', 'device_id', 'registration_id', 'type')

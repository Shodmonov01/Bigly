from rest_framework import serializers

from apps.accounts.models import Follow
from apps.notification.models import Notification
from config.utils import TimestampField


class FollowSerializer(serializers.ModelSerializer):
    created_at = TimestampField(read_only=True)

    class Meta:
        model = Follow
        fields = ['id', 'follower', 'following', 'created_at']

    def create(self, validated_data):
        follow, _ = Follow.objects.get_or_create(**validated_data)
        Notification.objects.create(
            user=validated_data.get('following'),
            title=f'@{validated_data.get("follower").username} started following you',
            type='follow'
        )
        return follow

    def validate(self, attrs):
        if attrs['follower'] == attrs['following']:
            raise serializers.ValidationError('You cannot follow yourself')
        return attrs

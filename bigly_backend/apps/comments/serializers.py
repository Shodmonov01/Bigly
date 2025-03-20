from rest_framework import serializers

from apps.accounts.serializers import UserListSerializer
from apps.comments.models import Comment
from config.utils import TimestampField


class CommentSerializer(serializers.ModelSerializer):
    user = UserListSerializer(read_only=True)
    created_at = TimestampField(read_only=True)
    updated_at = TimestampField(read_only=True)

    class Meta:
        model = Comment
        fields = ('id', 'user', 'content', 'created_at', 'updated_at')

    def create(self, validated_data):
        return Comment.objects.create(**validated_data)

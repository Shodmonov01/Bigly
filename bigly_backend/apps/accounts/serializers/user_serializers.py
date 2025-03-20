from rest_framework import serializers

from apps.content.models import Tag
from apps.accounts.models import User, Follow, UserBlock
from config.utils import TimestampField


class InterestSerializer(serializers.ModelSerializer):

    class Meta:
        model = Tag
        fields = ('id', 'name')


class UserSerializer(serializers.ModelSerializer):
    interest_list = serializers.ListField(child=serializers.CharField(), write_only=True, required=False)
    interests = InterestSerializer(many=True, read_only=True)
    is_following = serializers.SerializerMethodField()
    can_message = serializers.SerializerMethodField(read_only=True)
    is_blocked = serializers.SerializerMethodField(read_only=True)

    class Meta:
        model = User
        fields = [
            'id', 'username', 'first_name', 'last_name', 'email', 'bio', 'birth_date', 'age', 'profile_picture',
            'cover_image', 'post_count', 'is_following', 'follower_count', 'following_count', 'subscriber_count',
            'interest_list', 'interests', 'can_message', 'is_blocked'
        ]

    def get_is_following(self, obj) -> bool:
        request = self.context.get('request', None)
        if request and request.user.is_authenticated:
            return Follow.objects.filter(follower=request.user, following=obj).exists()
        return False

    def get_can_message(self, obj) -> bool:
        request = self.context.get('request', None)
        chat_settings = obj.chat_settings
        message_first_permission = chat_settings.message_first_permission
        if request and request.user.is_authenticated:
            return message_first_permission != 'nobody'
        return False

    def get_is_blocked(self, obj) -> bool:
        request = self.context.get('request', None)
        if request and request.user.is_authenticated:
            return UserBlock.objects.filter(blocker=request.user, blocked=obj).exists()
        return False

    def update(self, instance, validated_data):
        interests = validated_data.pop('interest_list', None)
        instance = super().update(instance, validated_data)
        if interests:
            instance.interests.clear()
            for interest in interests:
                tag, _ = Tag.objects.get_or_create(name=interest)
                instance.interests.add(tag)
        return instance


class UserListSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = ('id', 'username', 'first_name', 'last_name', 'email', 'profile_picture', 'cover_image')


class FollowSerializer(serializers.ModelSerializer):
    created_at = TimestampField(read_only=True)

    class Meta:
        model = Follow
        fields = ['id', 'follower', 'following', 'created_at']

    def create(self, validated_data):
        follow, _ = Follow.objects.get_or_create(**validated_data)
        return follow

    def validate(self, attrs):
        if attrs['follower'] == attrs['following']:
            raise serializers.ValidationError('You cannot follow yourself')
        return attrs

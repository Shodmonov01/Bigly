from django.core.exceptions import ValidationError
from django.shortcuts import get_object_or_404
from rest_framework import serializers

from apps.accounts.models import User, Follow
from apps.accounts.serializers import UserListSerializer
from apps.content.models import Content, Like, SavedContent, Tag, ContentReport
from apps.content_plan.models import ContentPlan, Subscription
from apps.notification.models import Notification
from config.utils import TimestampField


class TagSerializer(serializers.ModelSerializer):
    
    class Meta:
        model = Tag
        fields = ('id', 'name')


class ContentPlanInfoSerializer(serializers.ModelSerializer):
    is_active = serializers.BooleanField(default=True)
    created_at = TimestampField(read_only=True)

    class Meta:
        model = ContentPlan
        fields = (
            'id', 'name', 'banner', 'is_active', 'description', 'created_at'
        )


class ContentSerializer(serializers.ModelSerializer):
    main_tag_name = serializers.CharField(write_only=True, required=False)
    tag_list = serializers.ListField(child=serializers.CharField(), write_only=True, required=False)
    tagged_user_list = serializers.ListField(child=serializers.CharField(), write_only=True, required=False)
    content_plan_id = serializers.IntegerField(source='content_plan.id', write_only=True, required=False)
    main_tag = TagSerializer(read_only=True)
    tags = TagSerializer(many=True, read_only=True)
    user = UserListSerializer(read_only=True)
    has_liked = serializers.SerializerMethodField()
    has_saved = serializers.SerializerMethodField()
    created_at = TimestampField(read_only=True)
    updated_at = TimestampField(read_only=True)
    content_plan = ContentPlanInfoSerializer(read_only=True)
    has_subscribed = serializers.SerializerMethodField(read_only=True)
    is_following = serializers.SerializerMethodField(read_only=True)
    tagged_users = UserListSerializer(many=True, read_only=True)

    class Meta:
        model = Content
        fields = (
            'id', 'user', 'text', 'comment_count', 'type', 'like_count', 'has_liked', 'main_tag_name', 'main_tag',
            'tagged_user_list', 'has_saved', 'created_at', 'updated_at', 'media', 'media_preview', 'media_type',
            'thumbnail', 'tag_list', 'tags', 'tagged_users', 'content_plan_id', 'media_aspect_ratio', 'banner',
            'has_subscribed', 'is_following', 'content_plan'
        )

    def get_has_liked(self, obj) -> bool:
        user = self.context.get('request').user
        return Like.objects.filter(content=obj, user=user).exists()

    def get_has_subscribed(self, obj) -> bool:
        return Subscription.objects.filter(
            content_plan=obj.content_plan,
            user=self.context.get('request').user
        ).exists()

    def get_is_following(self, obj) -> bool:
        user = self.context.get('request').user
        return Follow.objects.filter(follower=user, following=obj.user).exists()

    def get_has_saved(self, obj) -> bool:
        user = self.context.get('request').user
        return SavedContent.objects.filter(content=obj, user=user).exists()

    def create(self, validated_data):
        main_tag_name = validated_data.pop('main_tag_name', None)
        tags = validated_data.pop('tag_list', [])
        tagged_users = validated_data.pop('tagged_user_list', [])
        content_plan = validated_data.pop('content_plan', None)
        if content_plan:
            content_plan = get_object_or_404(ContentPlan, id=content_plan['id'])
            validated_data['content_plan'] = content_plan
        content = Content.objects.create(**validated_data)
        if main_tag_name:
            main_tag, _ = Tag.objects.get_or_create(name=main_tag_name)
            content.main_tag = main_tag
        content.save()
        for tag_name in tags:
            tag, _ = Tag.objects.get_or_create(name=tag_name)
            content.tags.add(tag)
        for username in tagged_users:
            user = get_object_or_404(User, username=username)
            content.tagged_users.add(user)
            Notification.objects.create(
                user=user,
                title=f'@{content.user.username} mentioned you in a post',
                type='mention'
            )
        
        if content_plan:
            for user in User.objects.filter(subscriptions__content_plan=content_plan):
                Notification.objects.create(
                    user=user,
                    title=f'@{content.user.username} created new content',
                    type='content'
                )
        return content

    def update(self, instance, validated_data):
        main_tag_name = validated_data.pop('main_tag_name', None)
        tags = validated_data.pop('tag_list', None)
        tagged_users = validated_data.pop('tagged_user_list', None)
        content_plan = validated_data.pop('content_plan', None)
        if content_plan:
            content_plan = get_object_or_404(ContentPlan, id=content_plan['id'])
            instance.content_plan = content_plan
        if main_tag_name:
            main_tag, = Tag.objects.get_or_create(name=main_tag_name)
            instance.main_tag = main_tag
        if tags:
            instance.tags.clear()
            for tag_name in tags:
                tag, _ = Tag.objects.get_or_create(name=tag_name)
                instance.tags.add(tag)
        if tagged_users:
            instance.tagged_users.clear()
            for username in tagged_users:
                user = get_object_or_404(User, username=username)
                instance.tagged_users.add(user)
        return super().update(instance, validated_data)

    @staticmethod
    def validate_media(value):
        max_size = 200 * 1024 * 1024  # 200 MB
        if value and value.size > max_size:
            raise ValidationError(f"File size must be less than {max_size // (1024 * 1024)} MB.")
        return value


class ContentListSerializer(ContentSerializer):

    class Meta:

        model = Content
        fields = (
            'id', 'user', 'text', 'comment_count', 'type', 'like_count', 'has_liked', 'main_tag_name', 'main_tag',
            'tagged_user_list', 'has_saved', 'created_at', 'updated_at', 'media', 'media_preview', 'media_type',
            'thumbnail', 'tag_list', 'tags', 'tagged_users', 'media_aspect_ratio', 'banner', 'has_subscribed',
            'is_following',
        )


class PaginatedContentSerializer(serializers.Serializer):
    count = serializers.IntegerField(help_text="Total number of items")
    next = serializers.CharField(allow_null=True, help_text="URL of the next page", required=False)
    previous = serializers.CharField(allow_null=True, help_text="URL of the previous page", required=False)
    results = ContentListSerializer(many=True, read_only=True)


class ContentWithoutUserSerializer(ContentSerializer):
    created_at = TimestampField(read_only=True)
    updated_at = TimestampField(read_only=True)

    class Meta:
        model = Content
        fields = (
            'id', 'text', 'media', 'tags', 'like_count',
            'comment_count', 'created_at', 'updated_at'
        )
            

class SavedContentSerializer(serializers.ModelSerializer):

    class Meta:
        model = SavedContent
        fields = ('content', 'user')


class ContentReportSerializer(serializers.ModelSerializer):
    content_id = serializers.IntegerField(write_only=True)
    content = ContentSerializer(read_only=True)

    class Meta:
        model = ContentReport
        fields = '__all__'

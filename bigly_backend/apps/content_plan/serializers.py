from django.shortcuts import get_object_or_404
from rest_framework import serializers

from apps.content.serializers import ContentListSerializer
from apps.content_plan.models import ContentPlan, Subscription
from config.utils import TimestampField


class ContentPlanSerializer(serializers.ModelSerializer):
    is_active = serializers.BooleanField(default=True)
    created_at = TimestampField(read_only=True)
    subscriber_count = serializers.SerializerMethodField(read_only=True)
    length = serializers.SerializerMethodField(read_only=True)
    contents = ContentListSerializer(read_only=True, many=True)

    class Meta:
        model = ContentPlan
        fields = (
            'id', 'name', 'price', 'price_type', 'banner', 'is_active', 'description', 'subscriber_count', 'length',
            'trial_days', 'trial_discount_percent', 'trial_description', 'created_at', 'contents'
        )

    def get_subscriber_count(self, obj) -> int:
        return obj.users.count()

    def get_length(self, obj) -> int:
        return 'Not available'

    def create(self, validated_data):
        return super().create(validated_data)

    def update(self, instance, validated_data):
        return super().update(instance, validated_data)


class ContentPlanListSerializer(serializers.ModelSerializer):
    created_at = TimestampField(read_only=True)

    class Meta:
        model = ContentPlan
        fields = (
            'id', 'name', 'price', 'price_type', 'banner', 'is_active', 'description', 'created_at',
        )


class SubscriptionSerializer(serializers.ModelSerializer):
    content_plan_id = serializers.IntegerField(write_only=True, required=False)
    created_at = TimestampField(read_only=True)

    class Meta:
        model = Subscription
        fields = ('id', 'content_plan_id', 'created_at')

    def create(self, validated_data):
        content_plan = get_object_or_404(ContentPlan, id=validated_data['content_plan_id'])
        return Subscription.objects.create(user=self.context['request'].user, content_plan=content_plan)

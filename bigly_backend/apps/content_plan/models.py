
from django.db import models

from apps.accounts.models import User
from config.utils import CustomAutoField


class ContentPlan(models.Model):

    class PlanPriceTypeEnum(models.TextChoices):
        WEEK = 'week', 'Week'
        MONTH = 'month', 'Month'
        FREE = 'free', 'Free'

    id = CustomAutoField(primary_key=True, editable=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE, db_index=True)
    name = models.CharField(max_length=256)
    price = models.PositiveIntegerField(null=True)
    price_type = models.CharField(max_length=10, choices=PlanPriceTypeEnum, default=PlanPriceTypeEnum.FREE)
    trial_days = models.PositiveIntegerField(null=True)
    trial_discount_percent = models.PositiveIntegerField(null=True)
    trial_description = models.TextField(null=True)
    banner = models.ImageField(upload_to='banners/')
    is_active = models.BooleanField(default=True)
    description = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True, db_index=True)

    class Meta:
        db_table = 'content_plan'
        verbose_name = 'content plan'
        verbose_name_plural = 'content plans'
        ordering = ('created_at',)

    def __str__(self):
        return self.name


class Subscription(models.Model):
    id = CustomAutoField(primary_key=True, editable=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE, db_index=True, related_name='subscriptions')
    content_plan = models.ForeignKey(ContentPlan, on_delete=models.CASCADE, related_name='users', db_index=True)
    created_at = models.DateTimeField(auto_now_add=True, db_index=True)

    class Meta:
        db_table = 'subscriptions'
        verbose_name = 'subscription'
        verbose_name_plural = 'subscriptions'
        ordering = ('created_at',)

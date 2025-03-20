from django.contrib import admin

from apps.notification.models import Notification


@admin.register(Notification)
class NotificationAdmin(admin.ModelAdmin):
    list_display = ('user', 'title', 'type', 'created_at')

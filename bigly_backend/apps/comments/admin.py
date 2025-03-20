from django.contrib import admin

from apps.comments.models import Comment


@admin.register(Comment)
class CommentAdmin(admin.ModelAdmin):
    list_display = ('content', 'user', 'text')

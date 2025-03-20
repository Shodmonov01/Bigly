from django.contrib import admin

from apps.content.models import *


@admin.register(Content)
class ContentAdmin(admin.ModelAdmin):
    list_display = ('text', 'user', 'tag_names', 'created_at')
    filter_horizontal = ('tags',)
    readonly_fields = ('tag_names', 'thumbnail')

    @staticmethod
    def tag_names(obj):
        return ', '.join([tag.name for tag in obj.tags.all()])


@admin.register(Tag)
class TagAdmin(admin.ModelAdmin):
    list_display = ('name', 'content_count')
    readonly_fields = ('content_count',)

    @staticmethod
    def content_count(obj):
        return obj.contents.count()
    
    
@admin.register(SavedContent)
class SavedContentAdmin(admin.ModelAdmin):
    ist_display = ('content', 'user')


@admin.register(Like)
class LikeAdmin(admin.ModelAdmin):
    list_display = ('content', 'user')


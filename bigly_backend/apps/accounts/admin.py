from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.utils.safestring import mark_safe

from apps.accounts.models import User, Follow


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    list_display = ('username', 'first_name', 'last_name', 'created_at')
    readonly_fields = ('last_login', 'date_joined', 'profile_picture_preview', 'interests')
    ordering = ('-created_at',)
    filter_horizontal = ('interests',)
    fieldsets = (
        (None, {'fields': (
            'username', 'first_name', 'last_name', ('profile_picture', 'profile_picture_preview'),
            'birth_date', 'interests'
        )}),
        ('Extra information', {'fields': ('password', 'last_login', 'date_joined')}),
        ('Permissions', {'fields': ('is_active', 'is_staff', 'is_superuser')}),
    )
    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('username', 'password1', 'password2', 'first_name', 'last_name', 'profile_picture', 'birth_date')
        }),
    )

    def profile_picture_preview(self, obj):
        return mark_safe(f'<img src="{obj.profile_picture.url}" width="75" height="75" />')

    profile_picture_preview.short_description = 'Preview'


@admin.register(Follow)
class FollowAdmin(admin.ModelAdmin):
    list_display = ('follower', 'following')

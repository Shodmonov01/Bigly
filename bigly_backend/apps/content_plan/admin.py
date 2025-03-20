from django.contrib import admin

from apps.content_plan.models import ContentPlan


@admin.register(ContentPlan)
class ContentPlanAdmin(admin.ModelAdmin):
    list_display = ('name', 'price', 'price_type', 'is_active', 'created_at')
    list_filter = ('price_type', 'is_active')
    search_fields = ('name', 'description')

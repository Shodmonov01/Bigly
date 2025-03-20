import django_filters.rest_framework as filters

from apps.content.models import Content


class ContentFilter(filters.FilterSet):
    search = filters.CharFilter(field_name='text', lookup_expr='icontains')
    type = filters.CharFilter(field_name='type', lookup_expr='exact')

    class Meta:
        model = Content
        fields = ['search', 'type']

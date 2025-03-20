from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import path, include
from drf_spectacular.views import SpectacularAPIView, SpectacularRedocView, SpectacularSwaggerView

from config.handlers import *

urlpatterns = [
    path('api/schema/', SpectacularAPIView.as_view(), name='schema'),
    path('api/swagger/', SpectacularSwaggerView.as_view(url_name='schema'), name='swagger'),
    path('api/redoc/', SpectacularRedocView.as_view(url_name='schema'), name='redoc'),

    path('admin/', admin.site.urls),

    path('api/', include('apps.accounts.urls')),
    path('api/', include('apps.content.urls')),
    path('api/', include('apps.content_plan.urls')),
    path('api/', include('apps.comments.urls')),
    path('api/', include('apps.chat.urls')),
    path('api/', include('apps.notification.urls')),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)


handler400 = handler400_view
handler404 = handler404_view
handler500 = handler500_view

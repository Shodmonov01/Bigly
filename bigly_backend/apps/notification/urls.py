from django.urls import path

from apps.notification.views import NotificationView, SaveFCMDeviceView, MediaCreateView

urlpatterns = [
    path('media/', MediaCreateView.as_view()),
    path('notifications/', NotificationView.as_view()),
    path('fcm-devices/', SaveFCMDeviceView.as_view()),
]

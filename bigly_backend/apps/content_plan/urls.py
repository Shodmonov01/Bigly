from django.urls import path

from apps.content_plan.views import *

urlpatterns = [
    path('content-plans', ContentPlanListAPIView.as_view()),
    path('content-plans/<int:plan_id>', ContentPlanDetailAPIView.as_view()),
    path('content-plans/<int:plan_id>/subscribe/', SubscribeView.as_view()),

    path('user/<str:username>/content-plans/', UserContentPlanListAPIView.as_view()),
]

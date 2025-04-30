from django.urls import path

from apps.comments.views import CommentAPIView, CommentDetailAPIView, CommentCreateAPIView

urlpatterns = [
    path('content/<int:content_id>/comments/', CommentAPIView.as_view(), name='comment'),
    path('comments/<int:comment_id>/', CommentDetailAPIView.as_view(), name='comment-detail'),
    path('comments/<int:content_id>', CommentCreateAPIView.as_view(), name='create-comment'),
]


from django.urls import path

from apps.comments.views import CommentAPIView, CommentDetailAPIView

urlpatterns = [
    path('posts/<int:post_id>/comments/', CommentAPIView.as_view(), name='comment'),
    path('comments/<int:comment_id>/', CommentDetailAPIView.as_view(), name='comment-detail'),
]

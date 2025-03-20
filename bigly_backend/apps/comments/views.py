from rest_framework import status
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework.generics import get_object_or_404
from rest_framework.response import Response
from drf_spectacular.utils import extend_schema

from .serializers import CommentSerializer
from apps.comments.models import Comment
from apps.content.models import Content


class CommentAPIView(APIView):
    permission_classes = (IsAuthenticated,)

    @extend_schema(
        responses={200: CommentSerializer},
        tags=['Comment'],
        description='Get all comments for content'
    )
    def get(self, request, content_id):
        content = get_object_or_404(Content, id=content_id)
        comments = Comment.objects.filter(content=content)
        serializer = CommentSerializer(comments, many=True, context={'request': request})
        return Response(serializer.data)
    
    @extend_schema(
        request=CommentSerializer,
        responses={201: CommentSerializer},
        tags=['Comment'],
        description='Create new comment'
    )
    def content(self, request, content_id):
        content = get_object_or_404(Content, id=content_id)
        serializer = CommentSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save(user=request.user, content=content)
            return Response(serializer.data, status=201)
        return Response(serializer.errors, status=400)


class CommentDetailAPIView(APIView):
    permission_classes = (IsAuthenticated,)

    @extend_schema(
        responses={200: CommentSerializer},
        tags=['Comment'],
        description='Get comment by id'
    )
    def get(self, request, comment_id):
        comment = get_object_or_404(Comment, id=comment_id)
        serializer = CommentSerializer(comment, context={'request': request})
        return Response(serializer.data)

    @extend_schema(
        request=CommentSerializer,
        responses={200: CommentSerializer},
        tags=['Comment'],
        description='Update comment by id'
    )
    def put(self, request, comment_id):
        comment = get_object_or_404(Comment, id=comment_id)
        serializer = CommentSerializer(comment, data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @extend_schema(
        responses={204: None},
        tags=['Comment'],
        description='Delete comment by id'
    )
    def delete(self, request, comment_id):
        comment = get_object_or_404(Comment, id=comment_id)
        comment.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

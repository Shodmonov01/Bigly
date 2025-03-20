from rest_framework.generics import get_object_or_404
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from drf_spectacular.utils import extend_schema

from apps.accounts.serializers import FollowSerializer, UserListSerializer
from apps.accounts.models import User
from apps.notification.models import Notification


class FollowAPIView(APIView):
    serializer_class = FollowSerializer
    permission_classes = (IsAuthenticated,)

    @extend_schema(
        request=None,
        responses={201: None},
        tags=['Follow'],
        description='Follow user'
    )
    def post(self, request, username):
        user = get_object_or_404(User, username=username)
        data = {
            'follower': request.user.id,
            'following': user.id
        }
        serializer = self.serializer_class(data=data, context={'request': request})
        if serializer.is_valid(raise_exception=True):
            serializer.save()
            return Response({'detail': 'Successfully followed'}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class UserFollowersAPIView(APIView):
    serializer_class = UserListSerializer
    permission_classes = (AllowAny,)

    @extend_schema(
        responses={200: UserListSerializer(many=True)},
        tags=['User'],
        description='Get followers'
    )
    def get(self, request, username):
        user = get_object_or_404(User, username=username)
        followers = User.objects.filter(following__following=user)
        serializer = self.serializer_class(followers, many=True, context={'request': request})
        return Response(serializer.data)


class UserFollowingAPIView(APIView):
    serializer_class = UserListSerializer
    permission_classes = (AllowAny,)

    @extend_schema(
        responses={200: UserListSerializer(many=True)},
        tags=['User'],
        description='Get following'
    )
    def get(self, request, username):
        user = get_object_or_404(User, username=username)
        following = User.objects.filter(followers__follower=user)
        serializer = self.serializer_class(following, many=True, context={'request': request})
        return Response(serializer.data)

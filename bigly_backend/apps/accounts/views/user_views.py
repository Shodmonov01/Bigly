from drf_spectacular.types import OpenApiTypes
from rest_framework.generics import get_object_or_404
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from drf_spectacular.utils import extend_schema, OpenApiParameter

from apps.accounts.filters import UserFilter
from apps.accounts.serializers import UserSerializer, UserListSerializer
from apps.accounts.models import User

USER_MANUAL_PARAMETERS = [
    OpenApiParameter('search', type=OpenApiTypes.STR, location=OpenApiParameter.QUERY, description="Searching"),
    OpenApiParameter('content_plan_id', type=OpenApiTypes.INT, location=OpenApiParameter.QUERY,
                     description="Content plan ID"),
]


class ProfileAPIView(APIView):
    serializer_class = UserSerializer
    permission_classes = (IsAuthenticated,)

    @extend_schema(
        responses={200: UserSerializer},
        tags=['Profile'],
        description='Get profile info'
    )
    def get(self, request):
        serializer = self.serializer_class(request.user, context={'request': request})
        return Response(serializer.data)

    @extend_schema(
        request=UserSerializer,
        responses={200: UserSerializer},
        tags=['Profile'],
        description='Update profile info'
    )
    def put(self, request):
        serializer = self.serializer_class(request.user, data=request.data, partial=True, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @extend_schema(
        responses={204: None},
        tags=['Profile'],
        description='Delete profile'
    )
    def delete(self, request):
        request.user.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class UserListView(APIView):
    serializer_class = UserListSerializer
    permission_classes = (AllowAny,)

    @extend_schema(
        responses={200: UserListSerializer(many=True)},
        tags=['User'],
        description='Get all users',
        parameters=USER_MANUAL_PARAMETERS
    )
    def get(self, request):
        users = User.objects.all()
        if request.user.is_authenticated:
            users = users.exclude(id=request.user.id)
        user_filter = UserFilter(data=request.GET, request=request, queryset=users)
        filtered_users = user_filter.qs if user_filter.is_valid() else users.none()
        serializer = self.serializer_class(filtered_users, many=True, context={'request': request})
        return Response(serializer.data)


class UserProfileAPIView(APIView):
    serializer_class = UserSerializer
    permission_classes = (AllowAny,)

    @extend_schema(
        responses={200: UserSerializer},
        tags=['User'],
        description='Get profile info'
    )
    def get(self, request, username):
        user = get_object_or_404(User, username=username)
        serializer = self.serializer_class(user, context={'request': request})
        return Response(serializer.data)

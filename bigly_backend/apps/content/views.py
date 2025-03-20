from drf_spectacular.types import OpenApiTypes
from drf_spectacular.utils import extend_schema, OpenApiParameter
from rest_framework.generics import get_object_or_404
from rest_framework.pagination import PageNumberPagination
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import status

from apps.accounts.models import User
from apps.content.filters import ContentFilter
from apps.content.models import Content, Like, SavedContent, Tag, ContentReport
from apps.content.serializers import TagSerializer, ContentSerializer, ContentWithoutUserSerializer, \
    ContentReportSerializer, PaginatedContentSerializer, ContentListSerializer
from apps.notification.models import Notification
from config.utils import PAGINATION_PARAMETERS

CONTENT_MANUAL_PARAMETERS = [
    OpenApiParameter('search', type=OpenApiTypes.STR, location=OpenApiParameter.QUERY, description="Searching"),
    OpenApiParameter(
        'type', type=OpenApiTypes.STR, location=OpenApiParameter.QUERY, description="Content Type",
        enum=Content.ContentType
    ),
]


class ContentAPIView(APIView):
    serializer_class = ContentSerializer
    permission_classes = (IsAuthenticated,)

    @extend_schema(
        responses={200: ContentSerializer(many=True)},
        tags=['Content'],
        description='Get user contents',
        parameters=CONTENT_MANUAL_PARAMETERS
    )
    def get(self, request):
        contents = Content.objects.filter(user=request.user)
        contents = contents.select_related('user').prefetch_related('tags', 'tagged_users')
        content_filter = ContentFilter(data=request.GET, request=request, queryset=contents)
        filtered_contents= content_filter.qs if content_filter.is_valid() else contents.none()
        serializer = ContentSerializer(filtered_contents, many=True, context={'request': request})
        return Response(serializer.data)

    @extend_schema(
        request=ContentSerializer,
        responses={201: ContentSerializer},
        tags=['Content'],
        description='Create new content'
    )
    def post(self, request):
        serializer = ContentSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save(user=request.user)
            return Response(serializer.data, status=201)
        return Response(serializer.errors, status=400)


class ContentDetailAPIView(APIView):
    serializer_class = ContentSerializer
    permission_classes = (IsAuthenticated,)

    @extend_schema(
        responses={200: ContentSerializer},
        tags=['Content'],
        description='Get content info'
    )
    def get(self, request, content_id):
        content = get_object_or_404(
            Content.objects.select_related('user').prefetch_related('tags', 'tagged_users'),
            id=content_id
        )
        content.media.thumbnail = content.media.get_thumbnail()
        serializer = ContentSerializer(content, context={'request': request})
        return Response(serializer.data)

    @extend_schema(
        request=ContentSerializer,
        responses={200: ContentSerializer},
        tags=['Content'],
        description='Update content info'
    )
    def put(self, request, content_id):
        content = get_object_or_404(
            Content.objects.select_related('user').prefetch_related('tags', 'tagged_users'),
            id=content_id
        )
        serializer = ContentSerializer(content, data=request.data, partial=True, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=400)

    @extend_schema(
        responses={204: None},
        tags=['Content'],
        description='Delete content'
    )
    def delete(self, request, content_id):
        content = get_object_or_404(Content, id=content_id)
        content.delete()
        return Response(status=204)


class UserContentAPIView(APIView):
    serializer_class = ContentSerializer
    permission_classes = (AllowAny,)

    @extend_schema(
        responses={200: ContentSerializer(many=True)},
        tags=['User'],
        description='Get all contents for user'
    )
    def get(self, request, username=None):
        user = get_object_or_404(User, username=username)
        contents = Content.objects.filter(user=user)
        contents = contents.select_related('user').prefetch_related('tags', 'tagged_users')
        serializer = ContentWithoutUserSerializer(contents, many=True, context={'request': request})
        return Response(serializer.data)


class LikeAPIView(APIView):
    permission_classes = (IsAuthenticated,)

    @extend_schema(
        request=None,
        responses={201: None},
        tags=['Content Like'],
        description='Like content'
    )
    def post(self, request, content_id):
        content = get_object_or_404(Content, id=content_id)
        like, created = Like.objects.get_or_create(user=request.user, content=content)
        if created:
            Notification.objects.create(user=content.user, title=f'@{request.user.username} liked your content')
        return Response(status=status.HTTP_201_CREATED)

    @extend_schema(
        responses={200: None},
        tags=['Content Like'],
        description='Unlike content'
    )
    def delete(self, request, content_id):
        content = get_object_or_404(Content, id=content_id)
        Like.objects.filter(user=request.user, content=content).delete()
        return Response(status=204)


class SaveContentAPIView(APIView):
    permission_classes = (IsAuthenticated,)

    @extend_schema(
        request=None,
        responses={200: None},
        tags=['Content Save'],
        description='Save content'
    )
    def post(self, request, content_id):
        content = get_object_or_404(Content, id=content_id)
        SavedContent.objects.get_or_create(user=request.user, content=content)
        return Response(status=200)

    @extend_schema(
        responses={200: None},
        tags=['Content Save'],
        description='Unsave content'
    )
    def delete(self, request, content_id):
        content = get_object_or_404(Content, id=content_id)
        SavedContent.objects.filter(user=request.user, content=content).delete()
        return Response(status=204)


class SavedContentAPIView(APIView):
    permission_classes = (IsAuthenticated,)

    @extend_schema(
        responses={200: ContentSerializer(many=True)},
        tags=['Content'],
        description='Get saved contents'
    )
    def get(self, request):
        contents = Content.objects.filter(saved__user=request.user)
        contents = contents.select_related('user').prefetch_related('tags', 'tagged_users')
        serializer = ContentSerializer(contents, many=True, context={'request': request})
        return Response(serializer.data)


class GrowContentAPIView(APIView):
    permission_classes = (IsAuthenticated,)

    @extend_schema(
        responses={200: PaginatedContentSerializer()},
        tags=['Content'],
        description='Get grow contents',
        parameters=PAGINATION_PARAMETERS
    )
    def get(self, request):
        user = request.user
        followed_users = User.objects.filter(followers__follower=user)
        recommended_contents = Content.objects.filter(user__in=followed_users, type='content')
        queryset = recommended_contents.select_related('user').prefetch_related('tags', 'tagged_users')
        paginator = PageNumberPagination()
        paginator.page_size_query_param = 'page_size'
        paginated_queryset = paginator.paginate_queryset(queryset, request)
        serializer = ContentSerializer(paginated_queryset, many=True, context={'request': request})
        return paginator.get_paginated_response(serializer.data)


class DiscoverContentAPIView(APIView):
    permission_classes = (IsAuthenticated,)

    @extend_schema(
        responses={200: PaginatedContentSerializer()},
        tags=['Content'],
        description='Get discover contents',
        parameters=PAGINATION_PARAMETERS
    )
    def get(self, request):
        user = request.user
        # discover_contents = Content.objects.filter(tags__in=user.interests.all())
        # discover_contents = discover_contents.select_related('user').prefetch_related('tags', 'tagged_users')
        discover_contents = Content.objects.filter(type='content').exclude(user=user)
        queryset = discover_contents.select_related('user').prefetch_related('tags', 'tagged_users')
        paginator = PageNumberPagination()
        paginator.page_size_query_param = 'page_size'
        paginated_queryset = paginator.paginate_queryset(queryset, request)
        serializer = ContentSerializer(paginated_queryset, many=True, context={'request': request})
        return paginator.get_paginated_response(serializer.data)


class TagListAPIView(APIView):
    serializer_class = TagSerializer
    permission_classes = (AllowAny,)

    @extend_schema(
        responses={200: serializer_class(many=True)},
        tags=['Tag'],
        description='Get all tags'
    )
    def get(self, request):
        tags = Tag.objects.all()
        serializer = self.serializer_class(tags, many=True, context={'request': request})
        return Response(serializer.data)


class ContentReportListView(APIView):
    serializer_class = ContentReportSerializer
    permission_classes = (IsAuthenticated, )


    @extend_schema(
        responses={200: serializer_class(many=True)},
        tags=['Report'],
        description='Get all reports'
    )
    def get(self, request):
        tags = ContentReport.objects.all()
        serializer = self.serializer_class(tags, many=True, context={'request': request})
        return Response(serializer.data)


    @extend_schema(
        request=serializer_class(),
        responses={201: serializer_class()},
        tags=['Report'],
        description='Create a report'
    )
    def post(self, request):
        serializer = self.serializer_class(data=request.data, context={'request': request})
        if serializer.is_valid(raise_exception=True):
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

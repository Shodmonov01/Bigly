from django.db.models import Q
from rest_framework.pagination import PageNumberPagination
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework.permissions import IsAuthenticated
from rest_framework import status
from rest_framework.generics import get_object_or_404
from drf_spectacular.utils import extend_schema, OpenApiResponse

from apps.accounts.models import UserBlock
from apps.chat.models import Chat, Message, MessageRead
from apps.chat.serializers import ChatSerializer, ChatListSerializer, CreateGroupSerializer, ChatSettingSerializer, \
    MessageSerializer, PaginatedMessageSerializer
from config.utils import PAGINATION_PARAMETERS


class ChatView(APIView):
    serializer_class = ChatListSerializer
    permission_classes = (IsAuthenticated,)

    @extend_schema(
        responses={200: ChatListSerializer(many=True)},
        tags=['Chat'],
        description='Get all chats'
    )
    def get(self, request):
        chats = Chat.objects.filter(participants=request.user).filter(
            Q(is_request=False) | Q(request_user=request.user)
        ).prefetch_related('participants')
        serializer = self.serializer_class(chats, many=True, context={'request': request})
        return Response(serializer.data, status=status.HTTP_200_OK)

    @extend_schema(
        responses={201: ChatSerializer},
        tags=['Chat'],
        description='Create new chat'
    )
    def post(self, request):
        serializer = self.serializer_class(data=request.data, context={'request': request})
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)


class ChatDetailView(APIView):
    serializer_class = ChatSerializer
    permission_classes = (IsAuthenticated,)

    @extend_schema(
        responses={200: ChatSerializer},
        tags=['Chat'],
        description='Get chat by id'
    )
    def get(self, request, chat_id):
        chat = get_object_or_404(
            Chat.objects.prefetch_related('messages', 'participants'),
            id=chat_id, participants=request.user
        )
        serializer = self.serializer_class(chat, context={'request': request})
        unread_messages = Message.objects.filter(chat=chat).exclude(read_by__user=request.user)
        for message in unread_messages:
            MessageRead.objects.create(message=message, user=request.user)
        return Response(serializer.data, status=status.HTTP_200_OK)

    @extend_schema(
        responses={
            204: OpenApiResponse(description='Chat deleted'),
            403: OpenApiResponse(description='You don\'t have permission to accept this chat'),
        },
        tags=['Chat'],
        description='Delete chat by id'
    )
    def delete(self, request, chat_id):
        chat = get_object_or_404(Chat, id=chat_id, participants=request.user)
        if chat.participants.filter(id=request.user.id).exists() and (not chat.is_group or chat.owner == request.user):
            chat.delete()
            return Response({"detail": "Chat deleted"}, status=status.HTTP_204_NO_CONTENT)
        return Response({"detail": "You don't have permission to delete this chat"}, status=status.HTTP_403_FORBIDDEN)


class CreateGroupView(APIView):
    serializer_class = CreateGroupSerializer
    permission_classes = (IsAuthenticated,)

    @extend_schema(
        responses={201: ChatSerializer},
        tags=['Chat'],
        description='Create new chat'
    )
    def post(self, request):
        serializer = self.serializer_class(data=request.data, context={'request': request})
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)


class ChatSettingView(APIView):
    serializer_class = ChatSettingSerializer
    permission_classes = (IsAuthenticated,)

    @extend_schema(
        responses={200: ChatSettingSerializer},
        tags=['Chat Setting'],
        description='Get chat setting'
    )
    def get(self, request):
        chat_settings = request.user.chat_settings
        serializer = self.serializer_class(chat_settings, context={'request': request})
        return Response(serializer.data, status=status.HTTP_200_OK)

    @extend_schema(
        request=ChatSettingSerializer,
        responses={200: ChatSettingSerializer},
        tags=['Chat Setting'],
        description='Update chat setting'
    )
    def put(self, request):
        chat_settings = request.user.chat_settings
        serializer = self.serializer_class(chat_settings, data=request.data, partial=True, context={'request': request})
        serializer.is_valid(raise_exception=True)
        serializer.save()
        return Response(serializer.data, status=status.HTTP_200_OK)


class ChatRequestListView(APIView):
    serializer_class = ChatListSerializer
    permission_classes = (IsAuthenticated,)

    @extend_schema(
        responses={200: ChatListSerializer(many=True)},
        tags=['Chat Request'],
        description='Get all request chats'
    )
    def get(self, request):
        chats = Chat.objects.filter(
            participants=request.user, is_request=True
        ).exclude(request_user=request.user).prefetch_related('participants')
        serializer = self.serializer_class(chats, many=True, context={'request': request})
        return Response(serializer.data, status=status.HTTP_200_OK)


class ChatRequestAcceptView(APIView):
    serializer_class = ChatSerializer
    permission_classes = (IsAuthenticated,)

    @extend_schema(
        responses={
            200: OpenApiResponse(description='Chat accepted'),
            403: OpenApiResponse(description='You don\'t have permission to accept this chat'),
        },
        tags=['Chat Request'],
        description='Accept request chat'
    )
    def post(self, request, chat_id):
        chat = get_object_or_404(Chat, id=chat_id)
        if (chat.is_request and chat.participants.filter(id=request.user.id).exists() and
                chat.request_user != request.user):
            chat.is_request = False
            chat.save()
            return Response({'detail': 'Chat accepted'}, status=status.HTTP_200_OK)
        return Response({'detail': 'You don\'t have permission to accept this chat'}, status=status.HTTP_403_FORBIDDEN)


class ChatRequestBlockView(APIView):
    serializer_class = ChatSerializer
    permission_classes = (IsAuthenticated,)

    @extend_schema(
        responses={
            204: OpenApiResponse(description='Chat blocked'),
            403: OpenApiResponse(description='You don\'t have permission to block this chat'),
        },
        tags=['Chat Request'],
        description='Block request chat'
    )
    def post(self, request, chat_id):
        chat = get_object_or_404(Chat, id=chat_id)
        if (chat.is_request and chat.participants.filter(id=request.user.id).exists() and
                chat.request_user != request.user):
            UserBlock.objects.get_or_create(blocker=request.user, blocked=chat.request_user)
            chat.delete()
            return Response({'detail': 'Chat blocked'}, status=status.HTTP_204_NO_CONTENT)
        return Response({'detail': 'You don\'t have permission to block this chat'}, status=status.HTTP_403_FORBIDDEN)



class MessageListAPIView(APIView):
    permission_classes = (IsAuthenticated,)

    @extend_schema(
        responses={200: PaginatedMessageSerializer()},
        tags=['Chat'],
        description='Get chat messages',
        parameters=PAGINATION_PARAMETERS
    )
    def get(self, request, chat_id):
        queryset = Message.objects.filter(chat__id=chat_id)
        paginator = PageNumberPagination()
        paginator.page_size_query_param = 'page_size'
        paginated_queryset = paginator.paginate_queryset(queryset, request)
        serializer = MessageSerializer(paginated_queryset, many=True, context={'request': request})
        return paginator.get_paginated_response(serializer.data)

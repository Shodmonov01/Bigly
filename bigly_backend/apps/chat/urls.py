from django.urls import path

from apps.chat.views import *

urlpatterns = [
    path('chats/', ChatView.as_view(), name='chat-list'),
    path('chats/<int:chat_id>/', ChatDetailView.as_view(), name='chat-detail'),
    path('chats/<int:chat_id>/messages/', MessageListAPIView.as_view(), name='chat-message-list'),
    path('chats/<int:chat_id>/accept/', ChatRequestAcceptView.as_view(), name='chat-accept'),
    path('chats/<int:chat_id>/block/', ChatRequestBlockView.as_view(), name='chat-block'),
    path('chats/create-group/', CreateGroupView.as_view(), name='create-group'),
    path('chat-settings/', ChatSettingView.as_view(), name='chat-settings'),
    path('chat-requests/', ChatRequestListView.as_view(), name='chat-requests'),
]

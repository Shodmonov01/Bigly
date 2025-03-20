from django.test import TestCase
from django.contrib.auth import get_user_model
from django.urls import reverse
from rest_framework.test import APIClient
from rest_framework import status

from apps.chat.models import Chat

User = get_user_model()


class ChatTests(TestCase):

    def setUp(self):
        self.user1_data = {
            'username': 'testuser',
            'password': 'password!123'
        }

        self.user2_data = {
            'username': 'testuser2',
            'password': 'password!123'
        }

        self.login_url = reverse('login')
        self.user1 = User.objects.create_user(
            username=self.user1_data['username'],
            password=self.user1_data['password']
        )
        self.user2 = User.objects.create_user(
            username=self.user2_data['username'],
            password=self.user2_data['password']
        )
        self.chat = Chat.objects.create(name='Test Chat')
        self.chat.participants.add(self.user1, self.user2)
        self.client = APIClient()
        self.client.login(username='user1', password='password1')
        self.url = reverse('chat-list')

    def login_user(self, username, password):
        response = self.client.post(self.login_url, {'username': username, 'password': password}, format='json')
        return response

    def test_create_chat(self):
        login_response = self.login_user(self.user1_data['username'], self.user1_data['password'])
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + login_response.data['access'])
        payload = {'username': self.user2_data['username']}
        response = self.client.post(self.url, payload)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Chat.objects.count(), 2)

    def test_get_chats(self):
        login_response = self.login_user(self.user1_data['username'], self.user1_data['password'])
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + login_response.data['access'])
        response = self.client.get(self.url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)

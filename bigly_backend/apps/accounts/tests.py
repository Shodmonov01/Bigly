from django.urls import reverse
from django.contrib.auth import get_user_model
from rest_framework.test import APITestCase
from rest_framework import status

from apps.accounts.models import Follow

User = get_user_model()


class AccountsTests(APITestCase):

    def setUp(self):
        self.register_url = reverse('register')
        self.login_url = reverse('login')
        self.profile_url = reverse('profile')
        self.follow_url = lambda username: reverse('follow', kwargs={'username': username})
        self.followers_url = lambda username: reverse('followers', kwargs={'username': username})
        self.following_url = lambda username: reverse('following', kwargs={'username': username})

        self.user_data = {
            'username': 'testuser',
            'password': 'password!123',
            'password2': 'password!123',
            'first_name': 'Test',
            'last_name': 'User',
            'bio': 'This is a test user',
            'birth_date': '2000-01-01',
            'interest_list': ['music', 'travel']
        }
        
        self.user2_data = {
            'username': 'testuser2',
            'password': 'password!123',
            'password2': 'password!123',
            'first_name': 'Test2',
            'last_name': 'User2',
            'bio': 'This is another test user',
            'birth_date': '2000-02-02',
            'interest_list': ['sports', 'reading']
        }
    
    def register_user(self, user_data):
        response = self.client.post(self.register_url, user_data, format='json')
        return response

    def login_user(self, username, password):
        response = self.client.post(self.login_url, {'username': username, 'password': password}, format='json')
        return response

    def test_register_user(self):
        response = self.register_user(self.user_data)
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(User.objects.count(), 1)
        self.assertEqual(User.objects.get().username, self.user_data['username'])
        self.assertIn('access', response.data)
        self.assertIn('refresh', response.data)

    def test_login_user(self):
        self.register_user(self.user_data)
        response = self.login_user(self.user_data['username'], self.user_data['password'])
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('access', response.data)
        self.assertIn('refresh', response.data)

    def test_update_profile(self):
        self.register_user(self.user_data)
        login_response = self.login_user(self.user_data['username'], self.user_data['password'])
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + login_response.data['access'])
        update_data = {'bio': 'Updated bio'}
        response = self.client.put(self.profile_url, update_data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['bio'], update_data['bio'])

    def test_follow_user(self):
        self.register_user(self.user_data)
        self.register_user(self.user2_data)
        login_response = self.login_user(self.user_data['username'], self.user_data['password'])
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + login_response.data['access'])
        response = self.client.post(self.follow_url(self.user2_data['username']), format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        self.assertEqual(Follow.objects.count(), 1)
        self.assertEqual(Follow.objects.get().following.username, self.user2_data['username'])

    def test_get_followers(self):
        self.register_user(self.user_data)
        self.register_user(self.user2_data)
        login_response = self.login_user(self.user_data['username'], self.user_data['password'])
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + login_response.data['access'])
        self.client.post(self.follow_url(self.user2_data['username']), format='json')
        response = self.client.get(self.followers_url(self.user2_data['username']), format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['username'], self.user_data['username'])

    def test_get_following(self):
        self.register_user(self.user_data)
        self.register_user(self.user2_data)
        login_response = self.login_user(self.user_data['username'], self.user_data['password'])
        self.client.credentials(HTTP_AUTHORIZATION='Bearer ' + login_response.data['access'])
        self.client.post(self.follow_url(self.user2_data['username']), format='json')
        response = self.client.get(self.following_url(self.user_data['username']), format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(len(response.data), 1)
        self.assertEqual(response.data[0]['username'], self.user2_data['username'])

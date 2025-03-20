from django.urls import path

from .views import *

urlpatterns = [
    path('login/', LoginAPIView.as_view(), name='login'),
    path('register/', RegisterAPIView.as_view(), name='register'),
    path('change-password/', ChangePasswordAPIView.as_view(), name='change-password'),
    path('check-username/', UsernameCheckAPIView.as_view(), name='check-username'),
    path('check-password/', PasswordCheckAPIView.as_view(), name='check-password'),
    path('login/social/', SocialAuthView.as_view(), name='social-login'),

    path('profile/', ProfileAPIView.as_view(), name='profile'),

    path('users/', UserListView.as_view(), name='user-list'),
    path('user/<str:username>/', UserProfileAPIView.as_view(), name='user-detail'),
    path('user/<str:username>/follow/', FollowAPIView.as_view(), name='follow'),
    path('user/<str:username>/followers/', UserFollowersAPIView.as_view(), name='followers'),
    path('user/<str:username>/following/', UserFollowingAPIView.as_view(), name='following'),
]

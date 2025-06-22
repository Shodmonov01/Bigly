from random import sample
from django.contrib.auth import authenticate
from django.contrib.auth.models import update_last_login
from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError

from rest_framework import serializers
from rest_framework.exceptions import AuthenticationFailed
from rest_framework.validators import UniqueValidator
from rest_framework_simplejwt.serializers import PasswordField
from rest_framework_simplejwt.tokens import RefreshToken
from social_django.utils import load_strategy, load_backend

from apps.chat.models import ChatSetting
from apps.content.models import Tag
from apps.accounts.models import User


class LoginSerializer(serializers.Serializer):
    username = serializers.CharField(write_only=True)
    password = PasswordField(write_only=True)
    refresh = serializers.CharField(read_only=True)
    access = serializers.CharField(read_only=True)

    def validate(self, attrs):
        user = authenticate(**attrs)
        if not user:
            raise AuthenticationFailed(detail='Invalid username or password')

        if not user.is_active:
            raise AuthenticationFailed(detail='User account is disabled')

        refresh = self.get_token(user)
        data = {
            'refresh': str(refresh),
            'access': str(refresh.access_token)
        }
        update_last_login(None, user)
        return data

    @staticmethod
    def get_token(user) -> RefreshToken:
        return RefreshToken.for_user(user)


class RegisterSerializer(serializers.ModelSerializer):
    username = serializers.CharField(
        write_only=True, required=True,
        validators=[UniqueValidator(queryset=User.objects.all(), message="This username is already taken.")]
    )
    password = serializers.CharField(write_only=True, required=True, validators=[validate_password])
    password2 = serializers.CharField(write_only=True, required=True)

    first_name = serializers.CharField(write_only=True, required=True)
    last_name = serializers.CharField(write_only=True, required=False)
    email = serializers.CharField(write_only=True, required=False, default=None)
    birth_date = serializers.DateField(write_only=True, required=True)
    profile_picture = serializers.FileField(write_only=True, required=False)

    interest_list = serializers.ListField(child=serializers.CharField(), write_only=True, required=False)

    refresh = serializers.CharField(read_only=True)
    access = serializers.CharField(read_only=True)

    class Meta:
        model = User
        fields = (
            'username', 'password', 'password2', 'email',  'first_name', 'last_name', 'birth_date',
            'profile_picture', 'interest_list', 'refresh', 'access'
        )

    def create(self, validated_data):
        interests = validated_data.pop('interest_list', [])
        user = User(
            username=validated_data['username'],
            first_name=validated_data.get('first_name'),
            last_name=validated_data.get('last_name', ''),
            birth_date=validated_data.get('birth_date'),
            profile_picture=validated_data.get('profile_picture'),
        )
        user.set_password(validated_data['password'])
        user.save()
        ChatSetting.objects.get_or_create(user=user)
        for interest in interests:
            tag, _ = Tag.objects.get_or_create(name=interest)
            user.interests.add(tag)

        refresh: RefreshToken = RefreshToken.for_user(user)
        user.refresh = str(refresh)
        user.access = str(refresh.access_token)
        return user

    def to_representation(self, instance):
        ret = super().to_representation(instance)
        ret['refresh'] = instance.refresh
        ret['access'] = instance.access
        return ret

    def validate(self, attrs):
        if attrs['password'] != attrs['password2']:
            raise serializers.ValidationError(
                {'password': 'Password fields did not match'}
            )
        return attrs


class UsernameCheckSerializer(serializers.Serializer):
    username = serializers.CharField(write_only=True, required=True)
    available = serializers.BooleanField(read_only=True)
    suggestions = serializers.ListSerializer(child=serializers.CharField(), read_only=True)

    def to_representation(self, instance):
        username = instance.get('username', None)
        if username:
            suffixes = [
                '123', 'xyz', '_best', '_official', '2024', '_pro', '_master',
                '_guru', '_star', '_world', 'the_real', 'real_', '_official_',
                '_vibes', 'live', '_online', '_daily', '_hq', '_life', '_blog',
                'tv', '_channel', '_media', '_news', '_hub', '_spot', '_zone'
            ]
            available = not User.objects.filter(username=username).exists()
            instance['available'] = available
            if not available:
                random_suffixes = sample(suffixes, k=5)
                suggestions = [f"{username}{suffix}" for suffix in random_suffixes]
                instance['suggestions'] = suggestions
            else:
                instance['suggestions'] = None
        return super().to_representation(instance)


class PasswordCheckSerializer(serializers.Serializer):
    password = serializers.CharField(write_only=True, required=True)
    is_valid = serializers.BooleanField(read_only=True)
    errors = serializers.ListSerializer(child=serializers.CharField(), read_only=True)

    def to_representation(self, instance):
        password = instance.get('password', None)
        try:
            validate_password(password)
            instance['is_valid'] = True
            instance['errors'] = None
        except ValidationError as e:
            instance['is_valid'] = False
            instance['errors'] = list(e.messages)
        return super().to_representation(instance)


class ChangePasswordSerializer(serializers.Serializer):
    old_password = serializers.CharField(required=True)
    new_password = serializers.CharField(required=True)
    new_password2 = serializers.CharField(required=True)

    def validate_new_password(self, value):
        user = self.context['request'].user
        validate_password(value, user=user)
        return value

    def validate_old_password(self, value):
        user = self.context['request'].user
        if not user.check_password(value):
            raise serializers.ValidationError("Your old password was entered incorrectly. Please enter it again.")
        return value

    def validate(self, attrs):
        if attrs['new_password'] != attrs['new_password2']:
            raise serializers.ValidationError({'new_password': 'Password fields did not match'})
        return attrs

    def create(self, validated_data):
        user = self.context['request'].user
        user.set_password(validated_data['new_password'])
        user.save()
        return user


from google.oauth2 import id_token
from google.auth.transport import requests
from django.conf import settings
from django.contrib.auth import get_user_model
from rest_framework import serializers

# class SocialAuthSerializer(serializers.Serializer):

#     PROVIDERS = [
#         ['google-oauth2', 'Google'],
#         ['facebook', 'Facebook'],
#         ['apple-id', 'Apple'],
#     ]
#     provider = serializers.ChoiceField(choices=PROVIDERS, write_only=True)
#     token = serializers.CharField(write_only=True)
#     refresh = serializers.CharField(read_only=True, min_length=200, max_length=300)
#     access = serializers.CharField(read_only=True, min_length=200, max_length=300)

#     def create(self, validated_data):
#         strategy = load_strategy(self.context['request'])
#         backend = load_backend(strategy=strategy, name=validated_data.pop('provider'), redirect_uri=None)
#         token = validated_data.pop('token')
        
#         # Try a different approach for ID token verification
#         try:
#             # First, try explicitly with id_token parameter
#             user = backend.do_auth(id_token=token)
#         except Exception as e:
#             print(f"First auth attempt failed: {e}")
#             try:
#                 # If that fails, try the newer approach (for updated libraries)
#                 user = backend.do_auth(token)
#             except Exception as e:
#                 print(f"Second auth attempt failed: {e}")
#                 raise serializers.ValidationError("Authentication failed")
        
#         if user and user.is_active:
#             ChatSetting.objects.get_or_create(user=user)
#             refresh = self.get_token(user)
#             data = {
#                 'refresh': str(refresh),
#                 'access': str(refresh.access_token)
#             }
#             update_last_login(None, user)
#             return data
#         return None

#     @staticmethod
#     def get_token(user) -> RefreshToken:
#         return RefreshToken.for_user(user)



import requests
import jwt
from cryptography.hazmat.primitives import serialization
from django.conf import settings
from django.contrib.auth import get_user_model
from rest_framework import serializers
from google.oauth2 import id_token
from google.auth.transport import requests as google_requests
from apps.chat.models import Chat, ChatSetting



class SocialAuthSerializer(serializers.Serializer):
    PROVIDERS = [
        ['google-oauth2', 'Google'],
        ['facebook', 'Facebook'],
        ['apple-id', 'Apple'],
    ]
    provider = serializers.ChoiceField(choices=PROVIDERS, write_only=True)
    token = serializers.CharField(write_only=True)
    refresh = serializers.CharField(read_only=True, min_length=200, max_length=300)
    access = serializers.CharField(read_only=True, min_length=200, max_length=300)

    def create(self, validated_data):
        provider = validated_data.pop('provider', 'google-oauth2')
        token = validated_data.pop('token')
        
        if provider == 'google-oauth2':
            return self._handle_google_auth(token)
        elif provider == 'facebook':
            return self._handle_facebook_auth(token)
        elif provider == 'apple-id':
            return self._handle_apple_auth(token)
        else:
            raise serializers.ValidationError(f"Provider {provider} not supported")

    def _handle_google_auth(self, token):
        """Handle Google OAuth2 authentication"""
        try:
            # Verify the ID token with Google
            client_id = settings.SOCIAL_AUTH_GOOGLE_OAUTH2_KEY
            idinfo = id_token.verify_oauth2_token(token, google_requests.Request(), client_id)
            
            # Check if token is valid
            if idinfo['iss'] not in ['accounts.google.com', 'https://accounts.google.com']:
                raise ValueError('Wrong issuer.')
            
            # Get user info from token
            email = idinfo['email']
            first_name = idinfo.get('given_name', '')
            last_name = idinfo.get('family_name', '')
            
            return self._get_or_create_user(email, first_name, last_name, 'google')
            
        except ValueError as e:
            print(f"Google ID token validation error: {e}")
            raise serializers.ValidationError("Invalid Google token")

    def _handle_facebook_auth(self, token):
        """Handle Facebook authentication"""
        try:
            # Verify token with Facebook Graph API
            app_id = settings.SOCIAL_AUTH_FACEBOOK_KEY
            app_secret = settings.SOCIAL_AUTH_FACEBOOK_SECRET
            
            # First, verify the token
            verify_url = f"https://graph.facebook.com/debug_token"
            verify_params = {
                'input_token': token,
                'access_token': f"{app_id}|{app_secret}"
            }
            
            verify_response = requests.get(verify_url, params=verify_params)
            verify_data = verify_response.json()
            
            if not verify_data.get('data', {}).get('is_valid'):
                raise ValueError('Invalid Facebook token')
            
            # Get user info from Facebook
            user_url = "https://graph.facebook.com/me"
            user_params = {
                'access_token': token,
                'fields': 'id,email,first_name,last_name,name'
            }
            
            user_response = requests.get(user_url, params=user_params)
            
            if user_response.status_code != 200:
                raise ValueError('Failed to get user info from Facebook')
            
            user_data = user_response.json()
            print(user_data, 'user data face')
            
            email = user_data.get('email')
            if not email:
                raise ValueError('Email not provided by Facebook')
            
            first_name = user_data.get('first_name', '')
            last_name = user_data.get('last_name', '')
            
            return self._get_or_create_user(email, first_name, last_name, 'facebook')
            
        except (ValueError, requests.RequestException) as e:
            print(f"Facebook token validation error: {e}")
            raise serializers.ValidationError("Invalid Facebook token")

    def _handle_apple_auth(self, token):
        """Handle Apple Sign In authentication"""
        try:
            # Get Apple's public keys
            apple_keys_url = "https://appleid.apple.com/auth/keys"
            apple_keys_response = requests.get(apple_keys_url)
            apple_keys = apple_keys_response.json()
            
            # Decode the JWT header to get the key ID
            header = jwt.get_unverified_header(token)
            key_id = header['kid']
            
            # Find the matching key
            apple_key = None
            for key in apple_keys['keys']:
                if key['kid'] == key_id:
                    apple_key = key
                    break
            
            if not apple_key:
                raise ValueError('Apple key not found')
            
            # Convert the key to PEM format
            public_key = jwt.algorithms.RSAAlgorithm.from_jwk(apple_key)
            
            # Verify and decode the token
            decoded_token = jwt.decode(
                token,
                public_key,
                algorithms=['RS256'],
                audience=settings.SOCIAL_AUTH_APPLE_ID_CLIENT,
                issuer='https://appleid.apple.com'
            )
            
            email = decoded_token.get('email')
            if not email:
                raise ValueError('Email not provided by Apple')
            
            # Apple doesn't always provide name info in the token
            # Name is usually provided only on first sign-in
            first_name = decoded_token.get('given_name', '')
            last_name = decoded_token.get('family_name', '')
            
            return self._get_or_create_user(email, first_name, last_name, 'apple')
            
        except (ValueError, jwt.InvalidTokenError, requests.RequestException) as e:
            print(f"Apple token validation error: {e}")
            raise serializers.ValidationError("Invalid Apple token")

    def _get_or_create_user(self, email, first_name, last_name, provider):
        """Get or create user and return tokens"""
        User = get_user_model()
        
        try:
            user = User.objects.get(email=email)
        except User.DoesNotExist:
            user = User.objects.create_user(
                username=email,  # Use email as username
                email=email,
                first_name=first_name,
                last_name=last_name
            )


            
        
        # Update user info if not already set
        updated = False
        if not user.first_name and first_name:
            user.first_name = first_name
            updated = True
        if not user.last_name and last_name:
            user.last_name = last_name
            updated = True
        
        if updated:
            user.save()
        
        # Create chat settings (import at function level to avoid circular imports)
        
        ChatSetting.objects.get_or_create(user=user)
        
        # Generate tokens
        refresh = self.get_token(user)
        print(refresh, 'refresh token')
        print(refresh.access_token)
        data = {
            'refresh': str(refresh),
            'access': str(refresh.access_token)
        }
        print(data, 'data')
        
        # Update last login
        from django.contrib.auth.models import update_last_login
        update_last_login(None, user)
        print(data, 'data--2')
        
        return data

    def get_token(self, user):
        """Override this method to return your JWT token"""
        # This should return your JWT refresh token
        # Example using djangorestframework-simplejwt:
        from rest_framework_simplejwt.tokens import RefreshToken
        return RefreshToken.for_user(user)

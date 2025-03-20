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
        strategy = load_strategy(self.context['request'])
        backend = load_backend(strategy=strategy, name=validated_data.pop('provider'), redirect_uri=None)
        token = validated_data.pop('token')
        user = backend.do_auth(token)
        ChatSetting.objects.get_or_create(user=user)

        if user and user.is_active:
            refresh = self.get_token(user)
            data = {
                'refresh': str(refresh),
                'access': str(refresh.access_token)
            }
            update_last_login(None, user)
            return data
        return None

    @staticmethod
    def get_token(user) -> RefreshToken:
        return RefreshToken.for_user(user)

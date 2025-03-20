from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework_simplejwt.exceptions import InvalidToken, TokenError
from drf_spectacular.utils import extend_schema

from apps.accounts.serializers import (
    LoginSerializer,
    RegisterSerializer,
    UsernameCheckSerializer,
    PasswordCheckSerializer,
    ChangePasswordSerializer,
    SocialAuthSerializer
)


class LoginAPIView(APIView):
    permission_classes = (AllowAny,)
    serializer_class = LoginSerializer

    @extend_schema(
        request=LoginSerializer, 
        responses={200: LoginSerializer},
        tags=['Auth'],
        description='Login user'
    )
    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        try:
            serializer.is_valid(raise_exception=True)
            return Response(serializer.validated_data, status=status.HTTP_200_OK)
        except TokenError as e:
            raise InvalidToken(e.args[0])
        except Exception as e:
            return Response({"detail": str(e)}, status=status.HTTP_400_BAD_REQUEST)


class RegisterAPIView(APIView):
    permission_classes = (AllowAny,)
    serializer_class = RegisterSerializer

    @extend_schema(
        tags=['Auth'],
        request=RegisterSerializer,
        responses={201: RegisterSerializer},
        description='Register new user'
    )
    def post(self, request):
        serializer = self.serializer_class(data=request.data, context={'request': request})
        if serializer.is_valid(raise_exception=True):
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class UsernameCheckAPIView(APIView):
    permission_classes = (AllowAny,)
    serializer_class = UsernameCheckSerializer

    @extend_schema(
        request=UsernameCheckSerializer,
        responses={200: UsernameCheckSerializer},
        tags=['Auth'],
        description='Check username availability'
    )
    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class PasswordCheckAPIView(APIView):
    permission_classes = (AllowAny,)
    serializer_class = PasswordCheckSerializer

    @extend_schema(
        request=PasswordCheckSerializer,
        responses={200: PasswordCheckSerializer},
        tags=['Auth'],
        description='Check password validity'
    )
    def post(self, request):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        return Response(serializer.data, status=status.HTTP_200_OK)


class ChangePasswordAPIView(APIView):
    permission_classes = (IsAuthenticated,)
    serializer_class = ChangePasswordSerializer

    @extend_schema(
        request=ChangePasswordSerializer,
        responses={200: None},
        tags=['Auth'],
        description='Change user password'
    )
    def post(self, request):
        serializer = self.serializer_class(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            return Response({"message": "Password successfully updated."}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class SocialAuthView(APIView):
    serializer_class = SocialAuthSerializer
    permission_classes = (AllowAny,)

    @extend_schema(
        request=SocialAuthSerializer,
        responses={200: SocialAuthSerializer},
        tags=['Auth'],
        description='Login with social provider'
    )
    def post(self, request):
        serializer = self.serializer_class(data=request.data, context={'request': request})
        if serializer.is_valid(raise_exception=True):
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

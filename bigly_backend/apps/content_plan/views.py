from django.shortcuts import get_object_or_404
from drf_spectacular.utils import extend_schema, OpenApiResponse
from rest_framework import status
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView

from apps.accounts.models import User
from apps.content_plan.models import ContentPlan
from apps.content_plan.serializers import ContentPlanSerializer, SubscriptionSerializer, ContentPlanListSerializer


class ContentPlanListAPIView(APIView):
    permission_classes = (IsAuthenticated,)

    @extend_schema(responses={200: ContentPlanListSerializer(many=True)}, tags=['Content Plan'],
                   description='Get content plans')
    def get(self, request):
        plans = ContentPlan.objects.filter(user=request.user).select_related('user')
        serializer = ContentPlanListSerializer(plans, many=True, context={'request': request})
        return Response(serializer.data, status=status.HTTP_200_OK)

    @extend_schema(request=ContentPlanSerializer, responses={201: ContentPlanSerializer}, tags=['Content Plan'],
                   description='Create content plan')
    def post(self, request):
        serializer = ContentPlanSerializer(data=request.data, context={'request': request})
        if serializer.is_valid(raise_exception=True):
            serializer.save(user=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class ContentPlanDetailAPIView(APIView):
    permission_classes = (IsAuthenticated,)

    @extend_schema(responses={200: ContentPlanSerializer}, tags=['Content Plan'],
                   description='Get content plan detail')
    def get(self, request, plan_id):
        plan = get_object_or_404(ContentPlan, id=plan_id)
        serializer = ContentPlanSerializer(plan, context={'request': request})
        return Response(serializer.data, status=status.HTTP_200_OK)

    @extend_schema(request=ContentPlanSerializer, responses={200: ContentPlanSerializer}, tags=['Content Plan'],
                   description='Update content plan')
    def put(self, request, plan_id):
        plan = get_object_or_404(ContentPlan, id=plan_id)
        serializer = ContentPlanSerializer(plan, data=request.data, partial=True, context={'request': request})
        if serializer.is_valid(raise_exception=True):
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    @extend_schema(responses={204: None}, tags=['Content Plan'], description='Delete content plan')
    def delete(self, request, plan_id):
        plan = get_object_or_404(ContentPlan, id=plan_id)
        plan.delete()
        return Response({'detail': 'Successfully deleted'}, status=status.HTTP_204_NO_CONTENT)


class UserContentPlanListAPIView(APIView):
    serializer_class = ContentPlanListSerializer
    permission_classes = (IsAuthenticated,)

    @extend_schema(responses={200: ContentPlanListSerializer(many=True)}, tags=['User'],
                   description='Get content plans')
    def get(self, request, username):
        user = get_object_or_404(User, username=username)
        plans = ContentPlan.objects.filter(user=user).select_related('user')
        serializer = ContentPlanListSerializer(plans, many=True, context={'request': request})
        return Response(serializer.data, status=status.HTTP_200_OK)


class SubscribeView(APIView):
    serializer_class = SubscriptionSerializer
    permission_classes = (IsAuthenticated,)

    @extend_schema(request=None, responses={
        200: OpenApiResponse(description='Subscribed'),
        400: OpenApiResponse(description='Bad request')
    }, tags=['Subscription'],
                   description='Subscribe to content plan')
    def post(self, request, plan_id):
        serializer = self.serializer_class(data=request.data, context={'request': request})
        if serializer.is_valid(raise_exception=True):
            serializer.save(content_plan_id=plan_id, user=request.user)
            return Response({'detail': 'Successfully subscribed'}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

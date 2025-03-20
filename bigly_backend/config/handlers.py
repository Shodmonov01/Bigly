from django.http import JsonResponse
from rest_framework import status


def handler400_view(request, *args, **kwargs):
    return JsonResponse({'detail': 'Bad Request'}, status=status.HTTP_400_BAD_REQUEST)


def handler404_view(request, *args, **kwargs):
    return JsonResponse({'detail': 'Not Found'}, status=status.HTTP_404_NOT_FOUND)


def handler500_view(request, *args, **kwargs):
    return JsonResponse({'detail': 'Internal Server Error'}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

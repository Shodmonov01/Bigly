import os
from datetime import timedelta
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent.parent.parent

SECRET_KEY = "hello-social"

ALLOWED_HOSTS = ['*']

LOCAL_APPS = [
    'apps.accounts.apps.AccountsConfig',
    'apps.content.apps.ContentConfig',
    'apps.content_plan.apps.ContentPlanConfig',
    'apps.comments.apps.CommentsConfig',
    'apps.chat.apps.ChatConfig',
    'apps.notification.apps.NotificationConfig',
]

THIRD_PARTY_APPS = [
    'rest_framework',
    'rest_framework_simplejwt',
    'rest_framework_simplejwt.token_blacklist',
    'drf_spectacular',
    'social_django',
    'fcm_django'
]

INSTALLED_APPS = [
    'daphne',
    'django.contrib.contenttypes',
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    *LOCAL_APPS,
    *THIRD_PARTY_APPS,
]

MIDDLEWARE = [
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'social_django.middleware.SocialAuthExceptionMiddleware',
]

ROOT_URLCONF = 'config.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'config.wsgi.application'
ASGI_APPLICATION = 'config.asgi.application'

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'UTC'

USE_I18N = True

USE_TZ = True

STATIC_URL = 'static/'
STATIC_ROOT = os.path.join(BASE_DIR, 'static')

MEDIA_URL = "/media/"
MEDIA_ROOT = os.path.join(BASE_DIR, "/var/www/media/")

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

AUTH_USER_MODEL = 'accounts.User'


REST_FRAMEWORK = {
    'DEFAULT_SCHEMA_CLASS': 'drf_spectacular.openapi.AutoSchema',
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.DjangoModelPermissionsOrAnonReadOnly'
    ),
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
    'DATETIME_FORMAT': "%Y-%m-%d %H:%M:%S",
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 10,
}

SIMPLE_JWT = {
    "ACCESS_TOKEN_LIFETIME": timedelta(days=7),
    "REFRESH_TOKEN_LIFETIME": timedelta(days=30),
    "ALGORITHM": "HS256",
}

SPECTACULAR_SETTINGS = {
    'TITLE': 'Social Media API',
    'DESCRIPTION': 'Social Media',
    'VERSION': '1.0.0',
    'OAS_VERSION': '3.1.0',
    'COMPONENT_SPLIT_REQUEST': True,
    'CONTACT': {
        'name': 'Komronbek Obloev',
        'url': 'https://github.com/ok7uz',
        'email': 'komronbekobloev@gmail.com',
    },
    'SWAGGER_UI_SETTINGS': {
        'defaultModelRendering': 'model',
    },
}

CHANNEL_LAYERS = {
    'default': {
        'BACKEND': 'channels.layers.InMemoryChannelLayer',
    },
}

AUTHENTICATION_BACKENDS = (
    'social_core.backends.google.GoogleOAuth2',
    'social_core.backends.facebook.FacebookOAuth2',
    'social_core.backends.apple.AppleIdAuth',
    'django.contrib.auth.backends.ModelBackend',
)

FCM_DJANGO_SETTINGS = {
    "ONE_DEVICE_PER_USER": False,
    "DELETE_INACTIVE_DEVICES": True,
}

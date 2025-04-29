from config.settings.base import *

DEBUG = True

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}

# DATABASES = {
#     'default': {
#         'ENGINE': 'django.db.backends.postgresql',
#         'NAME': 'social',
#         'USER': 'postgres',
#         'PASSWORD': '1',
#         "HOST": "localhost",
#         "PORT": 5432,
#     }
# }

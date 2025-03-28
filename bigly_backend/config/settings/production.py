from config.settings.base import *

DEBUG = False

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'social',
        'USER': 'postgres',
        'PASSWORD': '1',
        "HOST": "localhost",
        "PORT": 5432,
    }
}

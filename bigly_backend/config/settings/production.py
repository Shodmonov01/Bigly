from config.settings.base import *

DEBUG = True

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': 'social',
        'USER': 'postgres',
        'PASSWORD': '0576',
        "HOST": "localhost",
        "PORT": 5432,
    }
}

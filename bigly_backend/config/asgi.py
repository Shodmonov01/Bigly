import os

import django
from django.core.asgi import get_asgi_application
from channels.routing import ProtocolTypeRouter, URLRouter
from channels.security.websocket import AllowedHostsOriginValidator

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings.production')
django.setup()

from apps.chat.routing import websocket_urlpatterns
from apps.chat.middleware import JwtAuthMiddleware

application = ProtocolTypeRouter({
    'http': get_asgi_application(),
    'websocket': AllowedHostsOriginValidator(
        JwtAuthMiddleware(
            URLRouter(websocket_urlpatterns)
        )
    )
})

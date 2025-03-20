from django.db import models

from apps.accounts.models import User
from apps.content.models import Content
from config.utils import CustomAutoField


class Comment(models.Model):
    id = CustomAutoField(primary_key=True, editable=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='comments', db_index=True)
    content = models.ForeignKey(Content, on_delete=models.CASCADE, related_name='comments', db_index=True)
    text = models.TextField()
    created_at = models.DateTimeField(auto_now_add=True, db_index=True)

    class Meta:
        db_table = 'comments'
        verbose_name = 'comment'
        verbose_name_plural = 'comments'
        ordering = ('-created_at',)

    def __str__(self):
        return f'@{self.user.username}: {self.content}'

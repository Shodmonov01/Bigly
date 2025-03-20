from datetime import date
from typing import Optional

from django.contrib.auth.models import AbstractUser
from django.db import models

from config.utils import CustomAutoField


class User(AbstractUser):
    id = CustomAutoField(primary_key=True, editable=False, start_value=10 ** 6 + 1)
    bio = models.TextField(blank=True, null=True)
    birth_date = models.DateField(blank=True, null=True)
    profile_picture = models.ImageField(upload_to='profiles/', null=True, blank=True)
    cover_image = models.ImageField(upload_to='covers/', null=True, blank=True)
    email = models.EmailField(unique=True, null=True, db_index=True)
    interests = models.ManyToManyField('content.Tag', related_name='users', blank=True, db_index=True)
    created_at = models.DateTimeField(auto_now_add=True, db_index=True)

    class Meta:
        db_table = 'users'
        ordering = ('first_name',)
        verbose_name = 'user'
        verbose_name_plural = 'users'
        indexes = [
            models.Index(fields=['username']),
        ]

    @property
    def post_count(self) -> int:
        return self.contents.count()

    @property
    def follower_count(self) -> int:
        return Follow.objects.filter(following=self).count()

    @property
    def following_count(self) -> int:
        return Follow.objects.filter(follower=self).count()

    @property
    def subscriber_count(self) -> int:
        return User.objects.filter(subscriptions__content_plan__user=self).distinct().count()

    @property
    def age(self) -> Optional[int]:
        if self.birth_date:
            today = date.today()
            age = today.year - self.birth_date.year
            if (today.month, today.day) < (self.birth_date.month, self.birth_date.day):
                age -= 1
            return age
        return None

    def __str__(self):
        return self.username


class Follow(models.Model):
    id = CustomAutoField(primary_key=True, editable=False)
    follower = models.ForeignKey(User, related_name='following', on_delete=models.CASCADE, db_index=True)
    following = models.ForeignKey(User, related_name='followers', on_delete=models.CASCADE, db_index=True)

    class Meta:
        db_table = 'user_follows'
        unique_together = ('follower', 'following')
        verbose_name = 'follow'
        verbose_name_plural = 'follows'

    def __str__(self):
        return f'{self.follower} follows {self.following}'


class UserBlock(models.Model):
    id = CustomAutoField(primary_key=True, editable=False)
    blocker = models.ForeignKey(User, related_name='blocked_by', on_delete=models.CASCADE, db_index=True)
    blocked = models.ForeignKey(User, related_name='blocked', on_delete=models.CASCADE, db_index=True)

    class Meta:
        db_table = 'user_blocks'
        unique_together = ('blocker', 'blocked')
        verbose_name = 'block'
        verbose_name_plural = 'blocks'

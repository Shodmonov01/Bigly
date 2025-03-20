import ffmpeg
from django.db import models
from django.db.models.signals import post_save
from django.dispatch import receiver

from apps.accounts.models import User
from apps.content_plan.models import ContentPlan
from config.utils import CustomAutoField


class Tag(models.Model):
    id = CustomAutoField(primary_key=True, editable=False, start_value=10 ** 6 + 1)
    name = models.CharField(max_length=255, unique=True)
    
    start_id = 10 ** 6 + 1

    class Meta:
        db_table = 'content_tags'
        ordering = ('name',)
        verbose_name = 'tag'
        verbose_name_plural = 'tags'

    def __str__(self):
        return self.name


class Content(models.Model):

    class ContentType(models.TextChoices):
        CONTENT = 'content', 'Content'
        MESSAGE = 'message', 'Message'

    class ContentMediaType(models.TextChoices):
        VIDEO = 'video', 'Video'
        AUDIO = 'audio', 'Audio'
        TEXT = 'text', 'Text'
        IMAGE = 'image', 'Image'

    id = CustomAutoField(primary_key=True, editable=False)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='contents', db_index=True)
    text = models.CharField(max_length=255, null=True)
    media = models.FileField(upload_to='contents/', null=True, max_length=500)
    media_preview = models.FileField(upload_to='contents/', null=True, max_length=500)
    media_type = models.CharField(max_length=10, choices=ContentMediaType, null=True)
    media_aspect_ratio = models.FloatField(null=True)
    thumbnail = models.FileField(upload_to='contents/', null=True, max_length=500)
    content_plan = models.ForeignKey(ContentPlan, on_delete=models.SET_NULL, null=True, related_name='contents')
    banner = models.FileField(upload_to='banners/', null=True, max_length=500)
    type = models.CharField(max_length=100, choices=ContentType)
    main_tag = models.ForeignKey(Tag, on_delete=models.SET_NULL, null=True, related_name='main_contents')
    tags = models.ManyToManyField(Tag, related_name='contents', db_index=True)
    tagged_users = models.ManyToManyField(User, related_name='tagged_contents', db_index=True)
    created_at = models.DateTimeField(auto_now_add=True, db_index=True)

    class Meta:
        db_table = 'contents'
        ordering = ('-created_at',)
        verbose_name = 'content'
        verbose_name_plural = 'contents'

    @property
    def like_count(self) -> int:
        return Like.objects.filter(content=self).count()

    @property
    def comment_count(self) -> int:
        return self.comments.count()
    
    def add_tags(self, tags: list[str]) -> None:
        self.tags.clear()
        for tag in tags:
            tag_instance, _ = Tag.objects.get_or_create(name=tag)
            self.tags.add(tag_instance)

    def __str__(self):
        return self.text if self.text else 'Untitled'

@receiver(post_save, sender=Content)
def content_post_save(sender, instance, created, **kwargs):
    if created and instance.media and instance.media_type == 'video':
        thumbnail_path = instance.media.path + '_thumbnail.jpg'
        ffmpeg.input(instance.media.path, ss=1).output(thumbnail_path, vframes=1).run(capture_stdout=True,
                                                                                 capture_stderr=True)
        instance.thumbnail = str(instance.media) + '_thumbnail.jpg'
        instance.save()


class SavedContent(models.Model):
    id = CustomAutoField(primary_key=True, editable=False)
    content = models.ForeignKey(Content, on_delete=models.CASCADE, related_name='saved', db_index=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='saved', db_index=True)

    class Meta:
        db_table = 'content_saved'
        verbose_name = 'saved content'
        verbose_name_plural = 'saved contents'

    def __str__(self):
        return f'{self.user} saved {self.content}'


class Like(models.Model):
    id = CustomAutoField(primary_key=True, editable=False)
    content = models.ForeignKey(Content, on_delete=models.CASCADE, related_name='likes', db_index=True)
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='likes', db_index=True)

    class Meta:
        db_table = 'content_likes'
        verbose_name = 'like'
        verbose_name_plural = 'likes'

    def __str__(self):
        return f'{self.user} likes {self.content}'


class ContentReport(models.Model):
    id = CustomAutoField(primary_key=True, editable=False)
    content = models.ForeignKey(Content, on_delete=models.CASCADE, related_name='reports', db_index=True)
    message = models.CharField(max_length=512, null=True)

    class Meta:
        db_table = 'content_reports'
        verbose_name = 'Content report'
        verbose_name_plural = 'Content reports'

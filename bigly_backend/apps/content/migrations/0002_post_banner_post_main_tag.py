# Generated by Django 5.0.6 on 2024-07-30 11:56

import django.db.models.deletion
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('content', '0001_initial'),
    ]

    operations = [
        migrations.AddField(
            model_name='post',
            name='banner',
            field=models.FileField(null=True, upload_to='banners/'),
        ),
        migrations.AddField(
            model_name='post',
            name='main_tag',
            field=models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='main_posts', to='content.tag'),
        ),
    ]

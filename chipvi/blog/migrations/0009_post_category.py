# Generated by Django 4.0.2 on 2022-02-27 17:00

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('blog', '0008_alter_post_options_post_is_published_and_more'),
    ]

    operations = [
        migrations.AddField(
            model_name='post',
            name='category',
            field=models.ForeignKey(default=1, null=True, on_delete=django.db.models.deletion.PROTECT, to='blog.category'),
        ),
    ]

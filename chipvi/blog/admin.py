from django.contrib import admin

# Register your models here.

from .models import Post, Category


class PostAdmin(admin.ModelAdmin):
    list_display = ('id', 'title', 'is_published', 'category')
    list_display_links = ('id', 'title')
    search_fields = ('title', 'content')
    list_editable = ('is_published',)
    list_filter = ('is_published', 'category')

class CategoryAdmin(admin.ModelAdmin):
    list_display = ('id', 'title')
    list_display_links = ('id', 'title')
    search_fields = ('title',)


admin.site.register(Post, PostAdmin)
admin.site.register(Category, CategoryAdmin)

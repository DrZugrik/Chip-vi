from django.shortcuts import render
from django.views.generic import ListView, DetailView
from .models import Post, Category, Tag
from django.db.models import F

def blog(request):
    postses = Post.objects.all()
    return render(request, 'blog/blog.html', {'posts': postses, 'title': 'Новости и полезные статьи'})


class GetPost(DetailView):
    model = Post
    template_name = 'blog/blog_post.html'
    context_object_name = Post

'''    def get_context_data(self, *, object_list=None, **kwargs):
        context = super().get_context_data(**kwargs)
        context['title'] = Category.objects.get(slug=self.kwargs['slug'])
        self.object.views = F.('views') + 1
        self.object.save()
        self.object.refresh_from_db()
        return context'''





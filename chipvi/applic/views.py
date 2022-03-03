from django.shortcuts import render
from django.views.generic import ListView, DetailView


def applic(request):
    '''postses = Post.objects.all()'''
    return render(request, 'applic/applic.html')



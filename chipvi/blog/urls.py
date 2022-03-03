from django.conf import settings
from django.contrib import admin
from django.urls import path, include

from .views import *

urlpatterns = [
    path('blog/', blog, name='blog'),
    path('post/<str:slug>/', GetPost.as_view(), name='post'),

]


'''if settings.DEBUG:
    urlpatterns +=static(settings.MEDIA_URL,document_root=settings.MEDIA__ROOT)
'''
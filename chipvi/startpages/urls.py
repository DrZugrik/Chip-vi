from django.conf import settings
from django.contrib import admin
from django.urls import path, include

from .views import *

urlpatterns = [
    path('', index, name='home'),
    path('faq/', faq, name='faq'),
    path('donate/', donate, name='donate'),

    path('register/', register, name='register'),
    path('login/', login, name='login'),


]
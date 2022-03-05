from django.shortcuts import render, redirect
from django.contrib.auth.forms import UserCreationForm

from .forms import UserRegisterForm, UserLoginForm
from django.contrib import messages
from django.contrib.auth import login, logout



# Create your views here.

#from django.http import HttpResponse

def index(request):
    return render(request, 'startpages/index.html')

def faq(request):
    return render(request, 'startpages/faq.html')

def donate(request):
    return render(request, 'startpages/donate.html')

def personal(request):
    return render(request, 'startpages/personal_page.html')



def register(request):
    if request.method == 'POST':
        form = UserRegisterForm(request.POST)
        if form.is_valid():
            user = form.save()
            messages.error(request, 'Регистрация пройдена!!!')
            login(request, user)
            return redirect('home')
        else:
            messages.error(request, 'Ошибка регистрации')
    else:
        form = UserRegisterForm()
    return render(request, 'startpages/register.html', {"form": form})


def user_login(request):
    if request.method == 'POST':
        form = UserLoginForm(data=request.POST)
        if form.is_valid():
            user = form.get_user()
            login(request, user)
            return redirect('home')
    else:
        form = UserLoginForm()
        messages.error(request, 'Ошибка входа')
    return render(request, 'startpages/login3.html', {"form": form})

def user_logout(request):
    logout(request)
    return redirect('login')




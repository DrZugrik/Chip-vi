from django.shortcuts import render, redirect
from django.contrib.auth.forms import UserCreationForm

from .forms import UserRegisterForm
from django.contrib import messages

# Create your views here.

#from django.http import HttpResponse

def index(request):
    return render(request, 'startpages/index.html')

def faq(request):
    return render(request, 'startpages/faq.html')

def donate(request):
    return render(request, 'startpages/donate.html')




def login(request):
    return render(request, 'startpages/login.html')

def register(request):
    if request.method == 'POST':
        form = UserRegisterForm(request.POST)
        if form.is_valid():
            form.save()
            messages.error(request, 'егистрация пройдена!!!')
            return redirect('login')
        else:
            messages.error(request, 'Ошибка регистрации')
    else:
        form = UserRegisterForm()
    return render(request, 'startpages/register.html', {"form": form})




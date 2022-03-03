from django.shortcuts import render
from django.contrib.auth.forms import UserCreationForm

# Create your views here.

#from django.http import HttpResponse

def index(request):
    return render(request, 'startpages/index.html')

def faq(request):
    return render(request, 'startpages/faq.html')

def donate(request):
    return render(request, 'startpages/donate.html')

def register(request):
    if request.method == 'POST':
        form = UserCreationForm(request.POST)
        if form.is_valid():
            form.save()
    else:
        form = UserCreationForm()
    return render(request, 'startpages/register.html', {"form": form})

def login(request):
    return render(request, 'startpages/login.html')

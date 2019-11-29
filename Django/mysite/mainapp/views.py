from django.shortcuts import render

def index(request):
    return render(request, 'mainapp/homePage.html')

def contact(request):
    return render(request, 'mainapp/basic.html', {'content': ['ahdasa']})

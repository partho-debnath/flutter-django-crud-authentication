from django.urls import path
from rest_framework.authtoken import views as AuthTokenView

from . import views

urlpatterns = [
    path('api-token-auth/', AuthTokenView.obtain_auth_token),
    path('create-user/', views.UserCreateView.as_view()),
    path('', views.ListView.as_view(), name='list'),
]
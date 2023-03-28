from django.urls import path
from rest_framework.authtoken import views as AuthTokenView

from . import views

urlpatterns = [
    path('api-token-auth/', AuthTokenView.obtain_auth_token, name='user-signin'),
    path('create-user/', views.UserCreateView.as_view(), name='user-signup'),
    path('task-list/', views.ListView.as_view(), name='all-task'),
    path('task-list/<int:id>/', views.DeleteTaskView.as_view(), name='delete-task'),

]
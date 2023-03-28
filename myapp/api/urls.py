from django.urls import path
from rest_framework.authtoken import views as AuthTokenView

from . import views

urlpatterns = [
    path('api-token-auth/', AuthTokenView.obtain_auth_token, name='user-signin'),
    path('create-user/', views.UserCreateView.as_view(), name='user-signup'),
    path('create-user-task/', views.TaskCreateView.as_view(), name='create-task'),
    path('task-list/', views.ListView.as_view(), name='all-task'),
    path('task-list/<int:id>/task-details/', views.TaskDetailsView.as_view(), name='task-details'),
    path('task-list/<int:id>/delete-task/', views.TaskDeleteView.as_view(), name='delete-task'),
    path('task-list/<int:id>/update-task/', views.TaskUpdateView.as_view(), name='update-task'),
]
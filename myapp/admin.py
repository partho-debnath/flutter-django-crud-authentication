from django.contrib import admin

from .models import UserTask

# Register your models here.


class UserTaskAdmin(admin.ModelAdmin):
    model = UserTask
    list_display = ['user', 'id', 'task', 'iscomplete', 'isfavorite', ]
    fields = ['user', 'task', 'iscomplete', 'isfavorite', ]
    list_filter = ['user', ]
    search_fields = ['task', 'iscomplete', 'isfavorite',]

admin.site.register(UserTask, UserTaskAdmin)
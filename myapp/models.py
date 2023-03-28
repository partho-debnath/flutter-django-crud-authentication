from django.db import models
from django.contrib.auth.models import User


class UserTask(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    task = models.TextField(max_length=500, blank=False, null=False)
    iscomplete = models.BooleanField(default=False)
    isfavorite = models.BooleanField(default=False)
    created = models.DateTimeField(auto_now_add=True)
    updated = models.DateTimeField(auto_now=True)

    def __str__(self) -> str:
        return f'{self.user.username} |  {self.task[:10]}...'


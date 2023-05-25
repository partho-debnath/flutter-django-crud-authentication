from rest_framework import serializers
from django.contrib.auth.models import User

from myapp.models import UserTask


class UserSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(required=True)
    first_name = serializers.CharField(max_length=50, required=True)
    last_name = serializers.CharField(max_length=50, required=True)

    class Meta:
        model = User
        fields = ['username', 'email', 'first_name', 'last_name', 'password']


class UserTaskSerializer(serializers.ModelSerializer):

    class Meta:
        model = UserTask
        # fields = '__all__'
        exclude = ['user', ]

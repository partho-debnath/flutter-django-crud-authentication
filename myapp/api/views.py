from rest_framework.views import APIView
from rest_framework import generics
from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated, AllowAny
from django.contrib.auth.models import User


from myapp.models import UserTask
from .serializers import UserTaskSerializer, UserSerializer


class UserCreateView(generics.CreateAPIView):
    
    permission_classes = [AllowAny, ]
    serializer_class = UserSerializer

    def perform_create(self, serializer):
        user = User.objects.create_user(**serializer.data)
        user.set_password(raw_password=self.request.POST.get('password'))
        user.save()
        return
    

class ListView(generics.ListAPIView):
    
    permission_classes = [IsAuthenticated, ]
    authentication_classes = [TokenAuthentication, ]
    serializer_class = UserTaskSerializer

    def get_queryset(self):
        return UserTask.objects.filter(user=self.request.user).order_by('created')






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
        # print(self.request.data)
        user = User.objects.create_user(**serializer.data)
        user.set_password(raw_password=serializer.data['password'])
        user.save()


class TaskCreateView(generics.ListCreateAPIView):

    permission_classes = [IsAuthenticated, ]
    authentication_classes = [TokenAuthentication, ]
    serializer_class = UserTaskSerializer
    queryset = UserTask.objects.all().order_by('-id')

    def perform_create(self, serializer):
        serializer.save(user=self.request.user)
        return



class ListView(generics.ListAPIView):

    permission_classes = [IsAuthenticated, ]
    authentication_classes = [TokenAuthentication, ]
    serializer_class = UserTaskSerializer

    def get_queryset(self):
        return UserTask.objects.filter(user=self.request.user).order_by('created')


class TaskDetailsView(generics.RetrieveAPIView):

    permission_classes = [IsAuthenticated, ]
    authentication_classes = [TokenAuthentication, ]
    serializer_class = UserTaskSerializer
    lookup_field = 'id'

    def get_queryset(self):
        query = UserTask.objects.filter(user=self.request.user, id=self.kwargs.get('id'))
        return query


class TaskDeleteView(TaskDetailsView, generics.DestroyAPIView):
    pass


class TaskUpdateView(generics.UpdateAPIView):
    permission_classes = [IsAuthenticated, ]
    authentication_classes = [TokenAuthentication, ]
    serializer_class = UserTaskSerializer
    lookup_field = 'id'

    def get_queryset(self):
        query = UserTask.objects.filter(user=self.request.user, id=self.kwargs.get('id'))
        return query
    
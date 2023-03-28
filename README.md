# Django Restframework
## Connect to Flutter app

# Generic Views are

> generics.CreateAPIView

> generics.ListCreateAPIView

> generics.ListAPIView

> generics.RetrieveAPIView

> generics.DestroyAPIView

> generics.UpdateAPIView


## User Functionality
Signin, SignUp API View

Create Task, Retrive Task, Update Task, Delete Task



# API Endpoints

# SignUp
## Post Request
    http://10.0.2.2:8000/create-user/

> Post Data

    {
        "username": "user",
        "email": "user@gmail.com",
        "first_name": "Mr",
        "last_name": "User"
        "password": "****"
    }

> Response Data

    {
        "username": "user",
        "email": "user@gmail.com",
        "first_name": "Mr",
        "last_name": "User"
    }

# Signin
## Post Request
    http://10.0.2.2:8000/api-token-auth/

> Post data

    {
        "username": "",
        "password": ""
    }

> Response Data

    {
        "token": "0cd78ca30aadc2214bfd2dead8b106bddf747943"
    }

# Create User Task
## Post Request
    http://10.0.2.2:8000/create-user-task/

> Post data

    {
        "task": "--Testing ---Task--",
        "iscomplete": true (optional),
        "isfavorite": true (optional)
    }

> Response data

    {
        "id": 17,
        "task": "--Testing ---Task--",
        "iscomplete": true,
        "isfavorite": true,
        "created": "2023-03-28T20:43:00.848604Z",
        "updated": "2023-03-28T20:43:00.848604Z"
    }

# Task List
## Get Request
    http://10.0.2.2:8000/task-list/

> Response Data

    [
        {
            "id": 11,
            "task": "this is my new task",
            "iscomplete": true,
            "isfavorite": true,
            "created": "2023-03-28T19:33:29.718476Z",
            "updated": "2023-03-28T20:35:21.694743Z"
        },
        {
            "id": 12,
            "task": "this is my new task",
            "iscomplete": true,
            "isfavorite": true,
            "created": "2023-03-28T19:35:00.870144Z",
            "updated": "2023-03-28T19:41:26.747352Z"
        }
    ]

# Details Task
## Get Request
    http://10.0.2.2:8000/task-list/<int:id>/task-details/

> Response Data

    {
        "id": 11,
        "task": "this is my new task",
        "iscomplete": true,
        "isfavorite": true,
        "created": "2023-03-28T19:33:29.718476Z",
        "updated": "2023-03-28T20:50:00.445759Z"
    }


# Delete Task
## Delete Request
    http://10.0.2.2:8000/task-list/<int:id>/delete-task/


# Update Task
## Put, Patch Request
    http://10.0.2.2:8000/task-list/<int:id>/update-task/

> Post Data

    {
        "task": "this is my new task",
        "iscomplete": true,
        "isfavorite": true
    }

> Response Data

    {
        "id": 11,
        "task": "this is my new task",
        "iscomplete": true,
        "isfavorite": true,
        "created": "2023-03-28T19:33:29.718476Z",
        "updated": "2023-03-28T20:35:21.694743Z"
    }




> [Django REST Framework Documentation](https://www.django-rest-framework.org/)

>[Classy Django REST Framework. For Customization](https://www.cdrf.co/)


> [Django REST Framework. From Youtube](https://www.youtube.com/watch?v=aoEcKdq3frU&list=PL4NIq30KvXLDES6CUeAWiSJNQzPsoBWI6&index=1)

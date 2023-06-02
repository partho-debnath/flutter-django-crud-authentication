# Django Restframework and Flutter

## Flutter Version
- Flutter version 3.7.3 on channel stable
- Dart version 2.19.2
- DevTools version 2.20.1


# User Interface

- ## Login Screen
<img src="https://github.com/pd28CSE/flutter-django-crud-authentication/assets/71305747/a497c17f-ef79-4856-b26f-9be2a297f4cb" width="50%" height="50%"><hr>


- ## Create New Account Screen
<img src="https://github.com/pd28CSE/flutter-django-crud-authentication/assets/71305747/a34cbb17-4ab7-4844-b7a4-2ff7f8eaedbb" width="50%" height="50%"><hr>


- ## Username/E-mail or Password Error
<img src="https://github.com/pd28CSE/flutter-django-crud-authentication/assets/71305747/edb7ceed-da65-4971-871e-40660038ce41" width="50%" height="50%"><hr>


- ## Task List Screen
<img src="https://github.com/pd28CSE/flutter-django-crud-authentication/assets/71305747/cf9bc280-999b-4934-839d-b5ce733d1c51" width="50%" height="50%"><hr>


- ## Task Detail Screen
<img src="https://github.com/pd28CSE/flutter-django-crud-authentication/assets/71305747/2d106365-3131-42b0-b8b9-37c1fe5c3087" width="50%" height="50%"><hr>

- ## Favorite List Screen
<img src="https://github.com/pd28CSE/flutter-django-crud-authentication/assets/71305747/69468b6e-5ef1-47b1-9a67-cb566ec8bcf7" width="50%" height="50%"><hr>


- ## Completed List Screen
<img src="https://github.com/pd28CSE/flutter-django-crud-authentication/assets/71305747/badbb0e2-ea27-4bf4-837b-52d59c23850e" width="50%" height="50%"><hr>


- ## Add New Task Screen
<img src="https://github.com/pd28CSE/flutter-django-crud-authentication/assets/71305747/23a0bda6-616e-4fb3-8f19-dccf473e49a4" width="50%" height="50%"><hr>


- ## Delete a Task
<img src="https://github.com/pd28CSE/flutter-django-crud-authentication/assets/71305747/247095d2-3dd2-49cf-88a2-0927414f3ee4" width="50%" height="50%"><hr>


- ## Show warning, if exiting without saving a task
<img src="https://github.com/pd28CSE/flutter-django-crud-authentication/assets/71305747/7c81c4b3-5dbe-4c93-912b-bcea11d704e0" width="50%" height="50%"><hr>


- ## Logout Confirmation
<img src="https://github.com/pd28CSE/flutter-django-crud-authentication/assets/71305747/805c485f-4cae-4f45-b437-5f67d1f09457" width="50%" height="50%"><hr>


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

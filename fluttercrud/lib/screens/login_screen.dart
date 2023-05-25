import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './list_screen.dart';

import '../providers/task_provider.dart';
import './registration_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool _passwordVisibilityOff = true;
  String? _username;
  String? _password;
  String? _errorMessage;

  bool _isValid() {
    if (_form.currentState!.validate() == false) {
      return false;
    }
    return true;
  }

  void submitForm() {
    if (_isValid() == false) {
      return;
    }

    _form.currentState!.save();

    TaskProvider userProvider =
        Provider.of<TaskProvider>(context, listen: false);
    var responce =
        userProvider.loginUser(_username as String, _password!.trim());
    responce.then((value) {
      if (value != null) {
        setState(() {
          _errorMessage = value;
        });
      } else {
        _errorMessage = null;
        Provider.of<TaskProvider>(context, listen: false).fetchTask();
        Navigator.of(context).pushReplacementNamed(ListScreen.routeName);
      }
    });
  }

  Widget buildButton(String buttonText, VoidCallback onSubmit) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.93,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.blue,
          elevation: 15,
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        onPressed: onSubmit,
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Column(
            children: <Widget>[
              Form(
                key: _form,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email),
                        labelText: 'Username',
                        errorText: _errorMessage,
                      ),
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty == true) {
                          return 'Enter your Username';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: _passwordVisibilityOff,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.password),
                        labelText: 'Password',
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _passwordVisibilityOff = !_passwordVisibilityOff;
                            });
                          },
                          icon: Icon(_passwordVisibilityOff == true
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        errorText: _errorMessage,
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.isEmpty == true) {
                          return 'Enter your Password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value;
                      },
                      onEditingComplete: () {
                        _isValid();
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              buildButton('Login', () {
                submitForm();
              }),
              const SizedBox(height: 10),
              buildButton('Registration', () {
                Navigator.of(context)
                    .pushReplacementNamed(RegistrationScreen.routeName);
              }),
            ],
          ),
        ),
      ),
    );
  }
}

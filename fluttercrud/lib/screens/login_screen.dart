import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';

import '../utils/http_exception.dart';
import './registration_screen.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool _passwordVisibilityOff = true;
  bool _isRequestTimeOut = false;
  String? _username;
  String? _password;
  String? _emalErrorMessage, _passwordErrorMessage;

  bool _isValid() {
    if (_form.currentState!.validate() == false) {
      return false;
    }
    return true;
  }

  Future<void> submitForm() async {
    if (_isValid() == false) {
      return;
    }
    _form.currentState!.save();

    User user = Provider.of<User>(context, listen: false);

    try {
      await user.loginUser(_username as String, _password!.trim());
    } on HttpException catch (error) {
      if (error
          .toString()
          .contains('Unable to log in with provided credentials')) {
        _emalErrorMessage = 'Email or password is invalid.';
        _passwordErrorMessage = _emalErrorMessage;
        _isRequestTimeOut = false;
        setState(() {});
      } else if (error.toString().contains('Request TimeOut')) {
        _isRequestTimeOut = true;
        _emalErrorMessage = null;
        _passwordErrorMessage = _emalErrorMessage;
        setState(() {});
      }
    } catch (error) {
      _showAlertDialog(error.toString());
    }
  }

  Future<bool?> _showAlertDialog(String error) {
    return showDialog<bool?>(
      context: context,
      builder: (cntxt) {
        return AlertDialog(
          title: const Text('Internal Error!'),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text('Login'),
        // ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 70,
                    width: 200,
                    alignment: Alignment.center,
                    transform: Matrix4.rotationZ(-20 * pi / 180),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(95, 103, 68, 168),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Text(
                      'Task Manager',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 178, 192, 240),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Form(
                    key: _form,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.email),
                            labelText: 'Email',
                            errorText: _emalErrorMessage,
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
                                  _passwordVisibilityOff =
                                      !_passwordVisibilityOff;
                                });
                              },
                              icon: Icon(_passwordVisibilityOff == true
                                  ? Icons.visibility
                                  : Icons.visibility_off),
                            ),
                            errorText: _passwordErrorMessage,
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          maxLength: 20,
                          validator: (value) {
                            if (value == null || value.isEmpty == true) {
                              return 'Enter your Password';
                            } else if (value.length < 8) {
                              return 'Password must be at least 8 characters.';
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
                  if (_isRequestTimeOut)
                    const Text(
                      'Request TimeOut, try again later.',
                      style: TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 15),
                  buildButton('Sign in', () {
                    submitForm();
                  }),
                  const SizedBox(height: 15),
                  buildButton('Create new account', () {
                    Navigator.of(context)
                        .pushReplacementNamed(RegistrationScreen.routeName);
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildButton(String buttonText, VoidCallback onSubmit) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.93,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shadowColor: Colors.deepPurple,
          elevation: 5,
          padding: const EdgeInsets.symmetric(vertical: 8),
        ),
        onPressed: onSubmit,
        child: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

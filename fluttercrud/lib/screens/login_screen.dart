import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = '/login-screen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  bool _password_visibility_off = true;
  String? _username;
  String? _password;
  String? _error_message;

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

    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    var responce =
        userProvider.loginUser(_username as String, _password as String);
    responce.then((value) {
      if (value != null) {
        setState(() {
          _error_message = value;
        });
      } else {
        _error_message = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          children: <Widget>[
            Form(
              key: _form,
              child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: 'Username',
                      errorText: _error_message,
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
                    obscureText: _password_visibility_off,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.password),
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _password_visibility_off =
                                !_password_visibility_off;
                          });
                        },
                        icon: Icon(_password_visibility_off == true
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                      errorText: _error_message,
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
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.93,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shadowColor: Colors.blue,
                  elevation: 15,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onPressed: () {
                  submitForm();
                },
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

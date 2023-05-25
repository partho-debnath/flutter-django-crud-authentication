import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import './list_screen.dart';
import './login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String routeName = "/registration-screen";
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController? _passwordController;
  FocusNode? _confirmPasswordFocusNode;
  bool _passwordVisibilityOff = true;
  String? _username;
  String? _firstName, _lastName;
  String? _password;
  String? _errorMessage;

  @override
  void initState() {
    _passwordController = TextEditingController();
    _confirmPasswordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController!.dispose();
    _confirmPasswordFocusNode!.dispose();
    super.dispose();
  }

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
    var responce = userProvider.createNewUser(_firstName.toString(),
        _lastName.toString(), _username as String, _password!.trim());
    responce.then((value) {
      if (value != null) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(value),
          duration: const Duration(seconds: 5),
        ));
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
        title: const Text('Create New Account'),
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
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'First Name',
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty == true) {
                          return 'Enter your First Name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _firstName = value;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: 'Last Name',
                      ),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty == true) {
                          return 'Enter your Last Name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _lastName = value;
                      },
                    ),
                    const SizedBox(height: 10),
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
                      controller: _passwordController,
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
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty == true) {
                          return 'Enter your Password';
                        }
                        return null;
                      },
                      onEditingComplete: () {
                        FocusScope.of(context)
                            .requestFocus(_confirmPasswordFocusNode);
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      obscureText: _passwordVisibilityOff,
                      focusNode: _confirmPasswordFocusNode,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.password),
                        labelText: 'Confirm Password',
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
                          return 'Enter Confirm Password';
                        } else if (_passwordController!.text.trim() !=
                            value.trim()) {
                          return 'Password and Confirm Password must be the same.';
                        }
                        return null;
                      },
                      onEditingComplete: () {
                        _isValid();
                      },
                      onSaved: (value) {
                        _password = value;
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15),
              buildButton('Registration', () {
                submitForm();
              }),
              const SizedBox(height: 10),
              buildButton('Login', () {
                Navigator.of(context)
                    .pushReplacementNamed(LoginScreen.routeName);
              })
            ],
          ),
        ),
      ),
    );
  }
}

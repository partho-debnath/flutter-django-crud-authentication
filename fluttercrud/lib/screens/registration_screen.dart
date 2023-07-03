import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';
import '../utils/http_exception.dart';
import './login_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String routeName = "/registration-screen";
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  TextEditingController? _passwordController;
  FocusNode? _confirmPasswordFocusNode;
  bool _passwordVisibilityOff = true;
  bool _isTimeOut = false;
  String? _username, _emailErrorMessage, _passwordErrorMessage;
  String? _firstName, _lastName;
  String? _password;

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

  Future<void> submitForm() async {
    if (_isValid() == false) {
      return;
    }

    _form.currentState!.save();
    User userProvider = Provider.of<User>(context, listen: false);

    try {
      await userProvider.createNewUser(_firstName.toString(),
          _lastName.toString(), _username as String, _password!.trim());

      _emailErrorMessage = null;
      _passwordErrorMessage = null;
      _isTimeOut = false;
      setState(() {});
      _showSuccessMessage();
    } on HttpException catch (error) {
      if (error.toString().contains('username already exists')) {
        setState(() {
          _emailErrorMessage = error.toString();
        });
      } else if (error.toString().contains('Request TimeOut')) {
        _emailErrorMessage = null;
        _passwordErrorMessage = null;
        _isTimeOut = true;
        setState(() {});
      }
    } catch (error) {
      _emailErrorMessage = null;
      _passwordErrorMessage = null;
      _isTimeOut = false;
      setState(() {});
      _showAlertDialog(error.toString());
    }
  }

  void _showSuccessMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Account Create Successful. Now you can login.'),
      ),
    );
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
        //   title: const Text('Create New Account'),
        // ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 15),
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
                          labelText: 'Email',
                          errorText: _emailErrorMessage,
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
                        textInputAction: TextInputAction.next,
                        maxLength: 20,
                        validator: (value) {
                          if (value == null || value.isEmpty == true) {
                            return 'Enter your Password';
                          } else if (value.length < 8) {
                            return 'Password must be at least 8 characters.';
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
                            return 'Enter Confirm Password';
                          } else if (value.length < 8) {
                            return 'Password must be at least 8 characters.';
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
                if (_isTimeOut)
                  const Text(
                    'Request TimeOut, try again later.',
                    style: TextStyle(color: Colors.red),
                  ),
                const SizedBox(height: 15),
                buildButton('Sign Up', () {
                  submitForm();
                }),
                const SizedBox(height: 15),
                buildButton('Sign in', () {
                  Navigator.of(context)
                      .pushReplacementNamed(LoginScreen.routeName);
                })
              ],
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
          elevation: 7,
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

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' show Response;
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/http_exception.dart';

class User with ChangeNotifier {
  static const String domain =
      'https://filesharingbd.pythonanywhere.com/task-manager-api/';
  String? email;
  String? token;
  Timer? logoutTimer;

  String? getEmail() => email;
  String? getToken() => token;

  Future<void> loginUser(String email, String password) async {
    Map<String, String> user = {'username': email, 'password': password};
    try {
      final Uri url = Uri.parse('${domain}api-token-auth/');
      final Response response = await http
          .post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(user),
      )
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          return http.Response('{"error": "Request TimeOut"}', 408);
        },
      );
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('token') == true) {
        /// Create the user 'emain & token ID', when the user login successfully
        this.email = email;
        token = responseBody['token'];
        _autologout();
        notifyListeners();
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        final Map<String, String> userAuth = {
          'email': email,
          'token': token as String,
        };
        prefs.setString('userAuth', json.encode(userAuth));
      } else if (responseBody.containsKey('non_field_errors') == true) {
        /// Wrong username or password
        throw HttpException(responseBody['non_field_errors'][0]);
      } else if (responseBody.containsKey('error') == true) {
        throw HttpException(responseBody['error']);
      } else if (responseBody.containsKey('username') == true) {
        throw HttpException(responseBody['username'][0]);
      } else if (responseBody.containsKey('password') == true) {
        throw HttpException(responseBody['password'][0]);
      }
    } on HttpException catch (error) {
      throw HttpException(error.toString());
    } catch (error) {
      /// throw ERROR, when any errors occurs.
      throw error.toString();
    }
  }

  Future<bool> tryAutoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('userAuth') == false) {
      return false;
    } else {
      final Map<String, dynamic> userAuth =
          json.decode(prefs.getString('userAuth') as String);

      token = userAuth['token'];
      email = userAuth['email'];
      notifyListeners();
      _autologout();
      return true;
    }
  }

  Future<void> createNewUser(
      String firstName, String lastName, String email, String password) async {
    Map<String, String> user = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'username': email,
      'password': password,
    };

    try {
      final Uri url = Uri.parse('${domain}create-user/');
      final Response response = await http
          .post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(user),
      )
          .timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          return http.Response('{"error": "Request TimeOut"}', 408);
        },
      );
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (responseBody.containsKey('username') == true &&
          responseBody['username'] != email) {
        throw HttpException(responseBody['username'][0]);
      } else if (responseBody.containsKey('email') == true &&
          responseBody['email'] != email) {
        throw HttpException(responseBody['email'][0]);
      } else if (responseBody.containsKey('error') == true) {
        throw HttpException(responseBody['error']);
      }
    } on HttpException catch (error) {
      throw HttpException(error.toString());
    } catch (error) {
      /// throw ERROR, when any errors occurs.
      throw error.toString();
    }
  }

  Future<void> logout() async {
    if (logoutTimer != null) {
      logoutTimer!.cancel();
      logoutTimer = null;
    }
    email = null;
    token = null;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userAuth');
    notifyListeners();
  }

  void _autologout() {
    if (logoutTimer != null) {
      logoutTimer!.cancel();
    }

    final int days = DateTime.now().add(const Duration(days: 1)).day;
    logoutTimer = Timer(Duration(days: days), logout);
  }
}

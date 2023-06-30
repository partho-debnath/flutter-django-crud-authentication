import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../utils/http_exception.dart';

class User with ChangeNotifier {
  static const String domain =
      'https://filesharingbd.pythonanywhere.com/task-manager-api/';
  String? email;
  String? token;

  String? getEmail() => email;
  String? getToken() => token;

  Future<void> loginUser(String email, String password) async {
    Map<String, String> user = {'username': email, 'password': password};
    try {
      var url = Uri.parse('${domain}api-token-auth/');
      final response = await http
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
        notifyListeners();
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
      var url = Uri.parse('${domain}create-user/');
      final response = await http
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
        throw Exception(responseBody['username'][0]);
      } else if (responseBody.containsKey('email') == true &&
          responseBody['email'] != email) {
        throw Exception(responseBody['email'][0]);
      } else if (responseBody.containsKey('error') == true) {
        throw Exception(responseBody['error']);
      }
    } catch (error) {
      /// throw ERROR, when any errors occurs.
      throw error.toString();
    }
  }

  void logout() {
    email = null;
    token = null;
    notifyListeners();
  }
}

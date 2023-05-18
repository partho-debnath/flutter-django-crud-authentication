import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  static const String domain = 'http://10.0.2.2:8000/api-token-auth/';

  String? email;
  String? token;

  Future<String?> loginUser(String email, String password) async {
    Map<String, String> user = {'username': email, 'password': password};

    try {
      var url = Uri.parse(domain);
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(user),
      );

      Map<String, dynamic> responseBody = json.decode(response.body);

      if (responseBody.containsKey('token') == true) {
        /// store the user emain & token ID, when the user login successfully
        this.email = email;
        token = responseBody['token'];
      } else {
        ///  Return error, when the user provide wrong email and password
        return 'Email or password is incorrect.';
      }
    } catch (error) {
      /// throw ERROR, when any errors occurs.
      throw error.toString();
    }

    ///  Return null, when the user login successfully
    return null;
  }
}

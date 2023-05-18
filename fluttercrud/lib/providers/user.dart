class User {
  final String email;
  final String token;

  User({required this.email, required this.token});

  String getEmail() => email;
  String getToken() => token;
}

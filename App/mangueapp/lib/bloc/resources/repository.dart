import 'dart:async';
import 'package:mangueapp/models/classes/user.dart';
import 'api.dart';

class Repository {
  final apiProvider = ApiProvider();

  Future<User> registerUser(String username, String firstname, String lastname, String password, String email)
    => apiProvider.registerUser(username, firstname, lastname, password, email);

  Future signinUser(String username, String password)
    => apiProvider.signinUser(username, password);
}
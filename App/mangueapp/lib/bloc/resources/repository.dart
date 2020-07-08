import 'dart:async';
import 'package:mangueapp/models/classes/user.dart';
import 'api.dart';

class Repository {
  final moviesApiProvider = ApiProvider();

  Future<User> registerUser(String username, String firstname, String lastname, String password, String email)
    => moviesApiProvider.registerUser(username, firstname, lastname, password, email);
}
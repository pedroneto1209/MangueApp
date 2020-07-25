import 'dart:async';
import 'package:mangueapp/models/classes/user.dart';
import 'api.dart';

class Repository {
  final apiProvider = ApiProvider();

  Future<User> registerUser(String username, String firstname, String lastname, String password, String email)
    => apiProvider.registerUser(username, firstname, lastname, password, email);

  Future signinUser(String username, String password, String apiKey)
    => apiProvider.signinUser(username, password, apiKey);

  Future getGraphs(String apiKey)
    => apiProvider.getGraphs(apiKey);

  Future<Null> addUserGraph(String apiKey, String data, String date, String datatype) async {
    apiProvider.addUserGraph(apiKey, data, date, datatype);
  }
}
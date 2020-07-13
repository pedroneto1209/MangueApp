import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'package:mangueapp/models/classes/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiProvider {
  Client client = Client();
  final _apiKey = 'your_api_key';

  Future signinUser(String username, String password) async {
    final response = await client
        .post("http://127.0.0.1:5000/api/signin",
        body: jsonEncode({
          "username": username,
          "password": password,
        })
        );
    final Map result = json.decode(response.body);
    if (response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON
      await saveApiKey(result['data']['api_key']);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<User> registerUser(String username, String firstname, String lastname, String password, String email) async {
    final response = await client
        .post("http://127.0.0.1:5000/api/register",
        body: jsonEncode({
          "email": email,
          "username": username,
          "password": password,
          "first_name": firstname,
          "last_name": lastname
        })
        );
    final Map result = json.decode(response.body);
    if (response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON
      await saveApiKey(result['data']['api_key']);
      return User.fromJson(result['data']);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  saveApiKey(String api_key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('API_Token', api_key);
  }
}
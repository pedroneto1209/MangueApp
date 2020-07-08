import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'package:mangueapp/models/classes/user.dart';

class ApiProvider {
  Client client = Client();
  final _apiKey = 'your_api_key';

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
    print(result['data'].toString());
    if (response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON
      return User.fromJson(result['data']);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }
}
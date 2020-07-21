import 'dart:async';
import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'package:mangueapp/models/classes/user.dart';
import 'package:mangueapp/models/classes/graph.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiProvider {
  Client client = Client();

  Future signinUser(String username, String password, String apiKey) async {
    final response = await client
        .post("http://15f981ab870e.ngrok.io/api/signin",
        headers: {
          "Authorization": apiKey
        },
        body: jsonEncode({
          "username": username,
          "password": password,
        })
        );
    final Map result = json.decode(response.body);
    if (response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON
      await saveApiKey(result['data']['apiKey']);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<User> registerUser(String username, String firstname, String lastname, String password, String email) async {
    final response = await client
        .post("http://15f981ab870e.ngrok.io/api/register",
        body: jsonEncode({
          "email": email,
          "username": username,
          "password": password,
          "firstname": firstname,
          "lastname": lastname
        })
        );
    final Map result = json.decode(response.body);
    if (response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON
      await saveApiKey(result['data']['apiKey']);
      return User.fromJson(result['data']);
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  Future<List<Graph>> getGraphs(String apiKey) async {
    final response = await client
        .get("http://15f981ab870e.ngrok.io/api/graphs",
        headers: {
          'Authorization' : apiKey
        }
        );
    final Map result = json.decode(response.body);
    if (response.statusCode == 201) {
      // If the call to the server was successful, parse the JSON
      List<Graph> graphs = [];
      for (Map json_ in result['data']){
        graphs.add(Graph.fromJson(json_));
      }
      return graphs;
    } else {
      // If that call was not successful, throw an error.
      throw Exception('Failed to load post');
    }
  }

  saveApiKey(String apiKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('APIToken', apiKey);
  }
}
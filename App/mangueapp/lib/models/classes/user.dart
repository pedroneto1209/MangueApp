


class User {
  String username;
  String lastname;
  String firstname;
  String email;
  String password;
  String api_key;
  int id;
  
  User(this.username, this.lastname, this.firstname, this.email, this.password, this.api_key, this.id);

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      parsedJson['username'],
      parsedJson['last_name'],
      parsedJson['first_name'],
      parsedJson['email'],
      parsedJson['password'],
      parsedJson['api_key'],
      parsedJson['id']
      );
  }
}
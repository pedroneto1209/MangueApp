class User {
  String username;
  String lastname;
  String firstname;
  String email;
  String password;
  String apiKey;
  int id;
  
  User(this.username, this.lastname, this.firstname, this.email, this.password, this.apiKey, this.id);

  factory User.fromJson(Map<String, dynamic> parsedJson) {
    return User(
      parsedJson['username'],
      parsedJson['lastname'],
      parsedJson['firstname'],
      parsedJson['email'],
      parsedJson['password'],
      parsedJson['apiKey'],
      parsedJson['id']
      );
  }
}
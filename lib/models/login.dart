import 'dart:convert';

Login loginFromJson(String str) => Login.fromJson(json.decode(str));

String loginToJson(Login data) => json.encode(data.toJson());

class Login {
  final String login;
  final String firstName;
  final String lastName;
  final String email;
  final String token;

  Login({this.login, this.firstName, this.lastName, this.email, this.token});

  Login.fromJson(Map<String, dynamic> json)
      : login = json['login'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        email = json['email'],
        token = json['id_token'];

  Map<String, dynamic> toJson() => {
        'login': login,
        'firstName': firstName,
        'lastName': lastName,
        'login': login,
        'email': email,
        'id_token': token,
      };
}

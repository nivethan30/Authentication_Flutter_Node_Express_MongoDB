import 'dart:convert';

class UserModel {
  final String? id;
  final String name;
  final String? token;
  final String email;
  final String password;

  UserModel({
    this.id,
    required this.name,
    this.token,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'name': name,
      'token': token,
      'email': email,
      'password': password,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['_id'] != null ? map['_id'] as String : null,
      name: map['name'] as String,
      token: map['token'] != null ? map['token'] as String : null,
      email: map['email'] as String,
      password: map['password'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);
}

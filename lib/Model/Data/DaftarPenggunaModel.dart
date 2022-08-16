// To parse required this JSON data, do
//
//     final modelDaftarPengguna = modelDaftarPenggunaFromJson(jsonString);

import 'dart:convert';

ModelDaftarPengguna modelDaftarPenggunaFromJson(String str) =>
    ModelDaftarPengguna.fromJson(json.decode(str));

String modelDaftarPenggunaToJson(ModelDaftarPengguna data) =>
    json.encode(data.toJson());

class ModelDaftarPengguna {
  ModelDaftarPengguna({
    required this.messege,
    required this.user,
  });

  String messege;
  User user;

  factory ModelDaftarPengguna.fromJson(Map<String, dynamic> json) =>
      ModelDaftarPengguna(
        messege: json["messege"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "messege": messege,
        "user": user.toJson(),
      };
}

class User {
  User({
    required this.id,
    required this.nama,
    required this.username,
    required this.password,
    required this.role,
    required this.gender,
    required this.updatedAt,
    required this.createdAt,
  });

  int id;
  String nama;
  String username;
  String password;
  String role;
  String gender;
  DateTime updatedAt;
  DateTime createdAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        nama: json["nama"],
        username: json["username"],
        password: json["password"],
        role: json["role"],
        gender: json["gender"],
        updatedAt: DateTime.parse(json["updatedAt"]),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "username": username,
        "password": password,
        "role": role,
        "gender": gender,
        "updatedAt": updatedAt.toIso8601String(),
        "createdAt": createdAt.toIso8601String(),
      };
}

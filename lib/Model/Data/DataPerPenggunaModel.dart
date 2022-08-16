// To parserequired this JSON data, do
//
//     final modelDataPerPengguna = modelDataPerPenggunaFromJson(jsonString);

import 'dart:convert';

ModelDataPerPengguna modelDataPerPenggunaFromJson(String str) => ModelDataPerPengguna.fromJson(json.decode(str));

String modelDataPerPenggunaToJson(ModelDataPerPengguna data) => json.encode(data.toJson());

class ModelDataPerPengguna {
    ModelDataPerPengguna({
       required this.messege,
       required this.dataUser,
    });

    String messege;
    DataUser dataUser;

    factory ModelDataPerPengguna.fromJson(Map<String, dynamic> json) => ModelDataPerPengguna(
        messege: json["messege"],
        dataUser: DataUser.fromJson(json["dataUser"]),
    );

    Map<String, dynamic> toJson() => {
        "messege": messege,
        "dataUser": dataUser.toJson(),
    };
}

class DataUser {
    DataUser({
       required this.id,
       required this.nama,
       required this.username,
       required this.panggilan,
       required this.gender,
       required this.role,
    });

    int id;
    String nama;
    String username;
    String panggilan;
    String gender;
    String role;

    factory DataUser.fromJson(Map<String, dynamic> json) => DataUser(
        id: json["id"],
        nama: json["nama"],
        username: json["username"],
        panggilan: json["panggilan"],
        gender: json["gender"],
        role: json["role"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nama": nama,
        "username": username,
        "panggilan": panggilan,
        "gender": gender,
        "role": role,
    };
}

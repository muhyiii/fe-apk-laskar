// To parse this JSON data, do
//
//     final modelDataAbsensiPerPengguna = modelDataAbsensiPerPenggunaFromJson(jsonString);

import 'dart:convert';

ModelDataAbsensiPerPengguna modelDataAbsensiPerPenggunaFromJson(String str) =>
    ModelDataAbsensiPerPengguna.fromJson(json.decode(str));

String modelDataAbsensiPerPenggunaToJson(ModelDataAbsensiPerPengguna data) =>
    json.encode(data.toJson());

class ModelDataAbsensiPerPengguna {
  ModelDataAbsensiPerPengguna({
    required this.messege,
    required this.dataAbsensi,
  });

  String messege;
  List<DataAbsensi> dataAbsensi;

  factory ModelDataAbsensiPerPengguna.fromJson(Map<String, dynamic> json) =>
      ModelDataAbsensiPerPengguna(
        messege: json["messege"],
        dataAbsensi: List<DataAbsensi>.from(
            json["dataAbsensi"].map((x) => DataAbsensi.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "messege": messege,
        "dataAbsensi": List<dynamic>.from(dataAbsensi.map((x) => x.toJson())),
      };
}

class DataAbsensi {
  DataAbsensi({
    required this.absen,
    required this.keterangan,
    required this.tanggal,
  });

  String absen;
  String keterangan;
  DateTime tanggal;

  factory DataAbsensi.fromJson(Map<String, dynamic> json) => DataAbsensi(
        absen: json["absen"],
        keterangan: json["keterangan"],
        tanggal: DateTime.parse(json["tanggal"]),
      );

  Map<String, dynamic> toJson() => {
        "absen": absen,
        "keterangan": keterangan,
        "tanggal": tanggal.toIso8601String(),
      };
}

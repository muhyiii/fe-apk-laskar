import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/First%20Page/DashboardPage.dart';
import 'package:frontend/First%20Page/SplashScreen.dart';
import 'package:frontend/Model/Data/DataAbsensiPerPengguna.dart';
import 'package:frontend/Model/Data/DataPerPenggunaModel.dart';
import 'package:frontend/Pages/AbsenPage.dart';
import 'package:frontend/Pages/DaftarPengguna.dart';

import 'package:http/http.dart' as http;
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiAkun {
  final base = 'https://laskarseoapp.herokuapp.com/akun';
  daftarAkun(String nama, String username, String password, String gender,
      String role, context, lebar) async {
    try {
      Uri url = Uri.parse(base + '/buat-akun');
      var response = await http.post(url,
          headers: {"content-type": "application/json"},
          body: jsonEncode({
            "nama": nama,
            "username": username,
            "password": password,
            "gender": gender,
            "role": role
          }));
      print(nama + username + password + gender + role);
      print(jsonDecode(response.body));
      if (response.statusCode == 201) {
        var db = await SharedPreferences.getInstance();
        db.setInt('idPengguna', jsonDecode(response.body)['user']['id']);

        print(db.getInt('idPengguna'));
        // print(db.getString('dataPengguna'));
        Timer(Duration(milliseconds: 500), () {
          Navigator.pushAndRemoveUntil(
            context,
            PageRouteBuilder(
              pageBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
              ) {
                return AbsenPage();
              },
              transitionDuration: Duration(seconds: 3),
              transitionsBuilder: (
                BuildContext context,
                Animation<double> animation,
                Animation<double> secondaryAnimation,
                Widget child,
              ) =>
                  FadeTransition(
                opacity: animation,
                child: child,
              ),
            ),
            (route) => false,
          );
        });
      } else {
        print(jsonDecode(response.body)['errors']['errors'][0]['msg']);
        Alert(
          context: context,
          type: AlertType.error,
          style: AlertStyle(
              animationType: AnimationType.fromTop,
              titleStyle: TextStyle(fontSize: lebar / 20),
              descStyle: TextStyle(fontSize: lebar / 25)),
          title: "Ada kesalahan",
          desc: jsonDecode(response.body)['errors']['errors'][0]['msg'],
          buttons: [
            DialogButton(
              child: Text(
                "Baik",
                style: TextStyle(color: Colors.white, fontSize: lebar / 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      }
    } catch (e) {
      print(e);
    }
  }

  masukAkun(String username, String password, context, lebar) async {
    try {
      Uri url = Uri.parse(base + '/masuk');
      var response = await http.post(url,
          headers: {"content-type": "application/json"},
          body: jsonEncode({
            "username": username,
            "password": password,
          }));
      if (response.statusCode == 200) {
        print('============================================================');
        var db = await SharedPreferences.getInstance();
        db.setInt('idPengguna', jsonDecode(response.body)['dataUser']['id']);

        db.setString('panggilanPengguna',
            jsonDecode(response.body)['dataUser']['panggilan']);

        Uri urls =
            Uri.parse(base + '/pengguna/${db.getInt('idPengguna')}/absensi');
        var responsea = await http.get(urls);
        ModelDataAbsensiPerPengguna absensi =
            modelDataAbsensiPerPenggunaFromJson(responsea.body.toString());
        print(absensi.dataAbsensi);
        var b = absensi.dataAbsensi
            .where((e) =>
                e.tanggal.year == DateTime.now().year &&
                e.tanggal.month == DateTime.now().month &&
                e.tanggal.day == DateTime.now().day)
            .length;

        // print(db.getString('dataPengguna'));
        Timer(Duration(milliseconds: 500), () {
          Navigator.pushAndRemoveUntil(
              context,
              PageRouteBuilder(
                pageBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                ) {
                  if (b == 1) return DashboardPage();
                  return AbsenPage();
                },
                transitionDuration: Duration(seconds: 3),
                transitionsBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child,
                ) =>
                    FadeTransition(
                  opacity: animation,
                  child: child,
                ),
              ),
              (e) => false);
        });
      } else {
        Alert(
          context: context,
          type: AlertType.error,
          style: AlertStyle(
              animationType: AnimationType.fromTop,
              titleStyle: TextStyle(fontSize: lebar / 20),
              descStyle: TextStyle(fontSize: lebar / 25)),
          title: "Ada kesalahan",
          desc: jsonDecode(response.body)['messege'],
          buttons: [
            DialogButton(
              child: Text(
                "Baik",
                style: TextStyle(color: Colors.white, fontSize: lebar / 20),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      }
    } catch (e) {
      print(e);
    }
  }

  tambahPanggilan(String panggilan, context, lebar) async {
    try {
      var db = await SharedPreferences.getInstance();
      Uri url = Uri.parse(
          base + '/pengguna/${db.getInt('idPengguna')}/tambah-panggilan');
      var response = await http.put(url,
          headers: {"content-type": "application/json"},
          body: jsonEncode({'panggilan': panggilan}));
      if (response.statusCode == 200) {
        db.setString(
            'panggilanPengguna', jsonDecode(response.body)['namaPanggilan']);
        print(db.getString('panggilanPengguna'));
        Timer(Duration(milliseconds: 500), () {
          return Navigator.pop(context);
        });
      } else {
        Alert(
          context: context,
          type: AlertType.error,
          style: AlertStyle(
              animationType: AnimationType.fromTop,
              titleStyle: TextStyle(fontSize: lebar),
              descStyle: TextStyle(fontSize: 15)),
          title: "Ada kesalahan",
          desc: jsonDecode(response.body)['messege'],
          buttons: [
            DialogButton(
              child: Text(
                "Baik",
                style: TextStyle(color: Colors.white, fontSize: lebar),
              ),
              onPressed: () => Navigator.pop(context),
              width: 120,
            )
          ],
        ).show();
      }
    } catch (e) {
      print(e);
    }
  }

  getDataPerAkun() async {
    try {
      var db = await SharedPreferences.getInstance();
      Uri url = Uri.parse(base + '/pengguna/${db.getInt('idPengguna')}');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['dataUser'];
      } else
        return throw Exception('Gagal mendapatkan data');
    } catch (e) {
      print(e);
    }
  }

  keluarAkun(context) async {
    try {
      var db = await SharedPreferences.getInstance();
      db.clear();
      Timer(Duration(milliseconds: 500), () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => SplashScreen()),
            (route) => false);
      });
    } catch (e) {
      print(e);
    }
  }
}

class ApiAbsen {
  final base = 'https://laskarseoapp.herokuapp.com/akun/pengguna';

  tambahAbsensi(String absen, String keterangan, context) async {
    var db = await SharedPreferences.getInstance();
    Uri url =
        Uri.parse(base + '/${db.getInt('idPengguna')}/absensi/tambah-absensi');
    var tanggal = DateTime.now().toString();
    print(tanggal);
    var response = await http.post(url,
        headers: {"content-type": "application/json"},
        body: jsonEncode(
            {"absen": absen, "keterangan": keterangan, "tanggal": tanggal}));

    if (response.statusCode == 200) {
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              return DashboardPage();
            },
            transitionDuration: Duration(seconds: 3),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
          (route) => false);
    }
  }

  getAbsensiPerPengguna() async {
    try {
      var db = await SharedPreferences.getInstance();
      Uri url = Uri.parse(base + '/${db.getInt('idPengguna')}/absensi');
      var response = await http.get(url);

      if (response.statusCode == 200) {
        ModelDataAbsensiPerPengguna absensi =
            modelDataAbsensiPerPenggunaFromJson(response.body.toString());
        // print(response.body);
        return absensi.dataAbsensi;
      } else
        return throw Exception('Gagal mendapatkan data');
    } catch (e) {
      print(e);
    }
  }
}

// ignore_for_file: use_key_in_widget_constructors, unused_import, file_names

import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Component/Loader.dart';
import 'package:frontend/Component/Style.dart';
import 'package:frontend/First%20Page/DashboardPage.dart';
import 'package:frontend/Model/Data/DataAbsensiPerPengguna.dart';
import 'package:frontend/Pages/AbsenPage.dart';
import 'package:frontend/Pages/DaftarPengguna.dart';

import 'package:frontend/Service/index.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  DateTime today = new DateTime.now();
  late Future absen;
  List<DataAbsensi> tes = [];
  var angka;
  Future getAbsen() async {
    absen = ApiAbsen().getAbsensiPerPengguna();
    var db = await SharedPreferences.getInstance();
    absen.then((value) {
      setState(() {
        tes = value;
        angka = tes
            .where((e) =>
                e.tanggal.year == DateTime.now().year &&
                e.tanggal.month == DateTime.now().month &&
                e.tanggal.day == DateTime.now().day)
            .length;
        // db.setInt('isAbsen', angka);
      });

      db.setInt('isAbsen', angka);

      print('angka' + angka);
    });
  }

  getDb() async {
    var db = await SharedPreferences.getInstance();
    if (db.containsKey('idPengguna')) {
      getAbsen();
    }
  }

  @override
  void initState() {
    initializeDateFormatting();
    FocusManager.instance.primaryFocus?.unfocus();
    controller = AnimationController(
        duration: Duration(milliseconds: 200),
        vsync: this,
        value: 0,
        lowerBound: 0,
        upperBound: 1);
    controller.forward();
    super.initState();
    getDb();
    startSplashScreen();
  }

  startSplashScreen() async {
    var duration = const Duration(seconds: 2);
    var db = await SharedPreferences.getInstance();
    return Timer(duration, () {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) {
              if (db.containsKey('idPengguna')) {
                // print('angka' + angka.toString());
                if (angka == 1) return DashboardPage();
                return AbsenPage();
              }
              return DaftarPengguna();
            },
            transitionDuration: Duration(seconds: 3),
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) =>
                ScaleTransition(
                  scale: Tween<double>(
                    begin: 0.0,
                    end: 1.0,
                  ).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                  child: child,
                )),
      );
    });
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  late AnimationController controller;
  @override
  Widget build(BuildContext context) {
    final tinggi = MediaQuery.of(context).size.height;
    final lebar = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: bg,
      body: Container(
        height: tinggi,
        width: lebar,
        child: FadeTransition(
          opacity:
              CurvedAnimation(parent: controller, curve: Curves.slowMiddle),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: lebar / 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Text(
                    //   'LASKARSE',
                    //   style: TextStyle(
                    //       letterSpacing: 2.5,
                    //       fontSize: lebar / 10,
                    //       color: kuning,
                    //       fontFamily: 'brokenVessel'),
                    // ),
                    DefaultTextStyle(
                      style: TextStyle(
                          letterSpacing: 2.5,
                          fontSize: lebar / 10,
                          color: kuning,
                          fontFamily: 'brokenVessel'),
                      child: AnimatedTextKit(
                          isRepeatingAnimation: false,
                          animatedTexts: [TyperAnimatedText('LASKARSE')],
                          repeatForever: false),
                    ),
                    Image.asset(
                      'assets/images/lingkaran.png',
                      height: lebar / 6.5,
                    )
                  ],
                ),
                Container(
                    margin: EdgeInsets.only(left: lebar / 7),
                    child: DefaultTextStyle(
                      style: TextStyle(fontSize: lebar / 10, color: oren),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          FadeAnimatedText('APP'),
                        ],
                        isRepeatingAnimation: false,
                        pause: Duration(seconds: 1),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

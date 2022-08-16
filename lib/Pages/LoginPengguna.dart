// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/Component/Loader.dart';
import 'package:frontend/Component/Style.dart';
import 'package:frontend/Model/Data/DataAbsensiPerPengguna.dart';
import 'package:frontend/Service/index.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPengguna extends StatefulWidget {
  const LoginPengguna({Key? key}) : super(key: key);

  @override
  State<LoginPengguna> createState() => _LoginPenggunaState();
}

class _LoginPenggunaState extends State<LoginPengguna> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  PageController formController =
      PageController(initialPage: 0, keepPage: true);

  bool ob = false;

  bool errorText = true;
  bool one = false;
  bool loading = false;

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
      });
      db.setInt('isAbsen', angka);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tinggi = MediaQuery.of(context).size.height;
    final lebar = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        backgroundColor: bg,
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                        top: lebar / 50,
                        left: lebar / 50,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CircleAvatar(
                            maxRadius: lebar / 13,
                            backgroundColor: oren,
                          ),
                          SizedBox(
                            width: lebar / 50,
                          ),
                          CircleAvatar(
                            maxRadius: lebar / 25,
                            backgroundColor: biru,
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 10,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: lebar / 50),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin:
                                    EdgeInsets.symmetric(vertical: lebar / 30),
                                child: Text(
                                  'Login Account',
                                  style: TextStyle(
                                      color: putih, fontSize: lebar / 25),
                                ),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.symmetric(vertical: lebar / 8),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'LASKARSE',
                                          style: TextStyle(
                                              letterSpacing: 2.5,
                                              fontFeatures: [
                                                FontFeature.enable('vatu')
                                              ],
                                              fontSize: lebar / 10,
                                              color: kuning,
                                              fontFamily: 'brokenVessel'),
                                        ),
                                        Image.asset(
                                          'assets/images/lingkaran.png',
                                          height: lebar / 6.5,
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: lebar / 7),
                                      child: Text(
                                        'APP',
                                        style: TextStyle(
                                            fontSize: lebar / 10, color: oren),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: tinggi / 3.7,
                                width: lebar,
                                child: Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: lebar / 10,
                                      horizontal: lebar / 30),
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        TextFormField(
                                          controller: username,
                                          cursorColor: putih,
                                          style: TextStyle(
                                              color: Colors.white,
                                              height: 1,
                                              fontSize: lebar / 25),
                                          decoration: InputDecoration(
                                            labelText: 'Username',
                                            labelStyle: TextStyle(color: putih),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 2, color: putih),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 2, color: putih),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 2, color: putih),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        TextFormField(
                                          controller: password,
                                          cursorColor: putih,
                                          obscureText: !ob,
                                          style: TextStyle(
                                              color: Colors.white,
                                              height: 1,
                                              fontSize: lebar / 25),
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                                onPressed: () => setState(() {
                                                      ob = !ob;
                                                    }),
                                                icon: Icon(
                                                  !ob
                                                      ? Icons
                                                          .visibility_off_rounded
                                                      : Icons
                                                          .visibility_rounded,
                                                  color: putih,
                                                )),
                                            labelText: 'Password',
                                            labelStyle: TextStyle(color: putih),
                                            enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 2, color: putih),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedErrorBorder:
                                                OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 2, color: putih),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 2, color: putih),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            errorBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 2, color: putih),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ]),
                                ),
                              ),
                              SizedBox(
                                height: lebar / 10,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                  horizontal: lebar / 30,
                                ),
                                child: ButtonTheme(
                                  height: lebar / 8,
                                  minWidth: lebar,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(lebar / 50))),
                                    color: oren,
                                    onPressed: () {
                                      if (username.text.isNotEmpty ||
                                          password.text.isNotEmpty) {
                                        if (password.text.length >= 8) {
                                          setState(() {
                                            loading = true;
                                          });
                                          ApiAkun().masukAkun(username.text,
                                              password.text, context, lebar);
                                          Timer(Duration(seconds: 5), () {
                                            setState(() {
                                              loading = false;
                                            });
                                          });
                                        } else {
                                          Alert(
                                            context: context,
                                            type: AlertType.error,
                                            style: AlertStyle(
                                                animationDuration:
                                                    Duration(milliseconds: 500),
                                                animationType:
                                                    AnimationType.fromTop,
                                                titleStyle: TextStyle(
                                                    fontSize: lebar / 20),
                                                descStyle: TextStyle(
                                                    fontSize: lebar / 25)),
                                            title: "Ada kesalahan",
                                            desc:
                                                "Passwordnya minimal 8 karakter",
                                            buttons: [
                                              DialogButton(
                                                child: Text(
                                                  "Baik",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: lebar / 20),
                                                ),
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                width: 120,
                                              )
                                            ],
                                          ).show();
                                        }
                                      } else {
                                        Alert(
                                          context: context,
                                          type: AlertType.error,
                                          style: AlertStyle(
                                              animationDuration:
                                                  Duration(milliseconds: 500),
                                              animationType:
                                                  AnimationType.fromTop,
                                              titleStyle: TextStyle(
                                                  fontSize: lebar / 20),
                                              descStyle: TextStyle(
                                                  fontSize: lebar / 25)),
                                          title: "Ada kesalahan",
                                          desc:
                                              "Formnya gak diisi lengkap nih, tolong diisi ya",
                                          buttons: [
                                            DialogButton(
                                              child: Text(
                                                "Baik",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: lebar / 20),
                                              ),
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              width: 120,
                                            )
                                          ],
                                        ).show();
                                        FocusManager.instance.primaryFocus
                                            ?.unfocus();
                                      }
                                    },
                                    child: Text(
                                      'Masuk',
                                      style: TextStyle(
                                          fontSize: lebar / 20, color: pText),
                                    ),
                                  ),
                                ),
                              ),
                              if (one)
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: lebar / 30,
                                  ),
                                  child: ButtonTheme(
                                    height: lebar / 10,
                                    // ignore: deprecated_member_use
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(lebar / 50))),
                                      color: biru,
                                      onPressed: () {
                                        formController.animateToPage(0,
                                            duration:
                                                Duration(milliseconds: 800),
                                            curve: Curves.bounceInOut);
                                        setState(() {
                                          one = false;
                                        });
                                      },
                                      child: Text(
                                        'Kembali',
                                        style: TextStyle(
                                            fontSize: lebar / 20, color: pText),
                                      ),
                                      // style: ElevatedButton.styleFrom(primary: oren,
                                      //   shape: RoundedRectangleBorder(
                                      //     borderRadius: BorderRadius.circular(10),
                                      //   ),
                                      // ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(
                          right: lebar / 40,
                          left: lebar / 30,
                          bottom: lebar / 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            maxRadius: lebar / 25,
                            backgroundColor: oren,
                          ),
                          SizedBox(
                            width: lebar / 50,
                          ),
                          CircleAvatar(
                            maxRadius: lebar / 13,
                            backgroundColor: biru,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            if (loading) ColorLoader3()
          ],
        ),
      ),
    );
  }
}

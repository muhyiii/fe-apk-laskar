import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/Component/Loader.dart';
import 'package:frontend/Component/Style.dart';
import 'package:frontend/Model/Data/DataAbsensiPerPengguna.dart';
import 'package:frontend/Service/index.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AbsenPage extends StatefulWidget {
  @override
  State<AbsenPage> createState() => _AbsenPageState();
}

class _AbsenPageState extends State<AbsenPage> {
  late final hari;
  late final tanggal;
  var size;
  var wifi;

  final NetworkInfo networkInfo = NetworkInfo();

  String namaPanggilan = '';
  DateTime today = new DateTime.now();

  bool uHadir = false;
  bool uIzin = false;

  bool loading = false;
  String absen = '';
  TextEditingController alasan = TextEditingController();
  TextEditingController panggilan = TextEditingController();

  cekWifi() async {
    try {
      if (!kIsWeb && Platform.isAndroid) {
        wifi = await networkInfo.getWifiBSSID();
      }
    } on PlatformException catch (e) {
      wifi = 'Failed to get Wifi Name';
    }
    print(wifi);
  }

  cekPanggilan(size) async {
    var db = await SharedPreferences.getInstance();

    var a = db.getString('panggilanPengguna');
    print(a);
    setState(() {
      namaPanggilan = db.getString('panggilanPengguna').toString();
    });
    if (!db.containsKey('panggilanPengguna')) {
      Alert(
          context: context,
          desc: "Kamu belum masukin nama panggilan, mau dipanggil siapa nih",
          style: AlertStyle(
            isOverlayTapDismiss: false,
            isCloseButton: false,
            animationDuration: Duration(milliseconds: 500),
            animationType: AnimationType.fromTop,
            titleStyle: TextStyle(fontSize: size),
            descStyle: TextStyle(fontSize: 15),
          ),
          content: Container(
            margin: EdgeInsets.only(top: 15),
            child: TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: panggilan,
              cursorColor: item,
              style: TextStyle(color: item, fontSize: size),
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 2, horizontal: 15),
                  hintText: 'Panggilan kamu',
                  fillColor: krem,
                  filled: true,
                  labelStyle: TextStyle(color: putih),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: putih),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none)),
            ),
          ),
          closeIcon: null,
          buttons: [
            DialogButton(
              width: 120,
              onPressed: () {
                ApiAkun().tambahPanggilan(panggilan.text, context, size);

                setState(() {
                  namaPanggilan = panggilan.text;
                });
              },
              child: Text(
                "Yakin",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            )
          ]).show();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    initializeDateFormatting();
    hari = new DateFormat.EEEE('id');
    tanggal = new DateFormat.yMMMMd('id');
    cekPanggilan(size);
    // getAbsen();
    // cekWifi();
    // print(wifi);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tinggi = MediaQuery.of(context).size.height;
    final lebar = MediaQuery.of(context).size.width;
    setState(() {
      size = lebar / 30;
    });
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        backgroundColor: bg,
        body: Stack(
          children: [
            SafeArea(
                child: Container(
              child: Stack(
                children: [
                  Container(
                    alignment: Alignment.bottomCenter,
                    height: tinggi / 2.5,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/images/home.png'))),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: lebar / 15, horizontal: lebar / 15),
                      width: lebar,
                      height: tinggi / 1.8,
                      decoration: BoxDecoration(
                          boxShadow: [
                            //background color of box
                            BoxShadow(
                              color: bg,
                              blurRadius: 5.0, // soften the shadow
                              spreadRadius: 2.0, //extend the shadow
                              offset: Offset(
                                0, // Move to right 10  horizontally
                                0.5, // Move to bottom 10 Vertically
                              ),
                            )
                          ],
                          color: putih,
                          borderRadius: BorderRadius.vertical(
                              top: Radius.circular(lebar / 12))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hari.format(today),
                            style: TextStyle(
                                fontSize: lebar / 25,
                                color: bg,
                                fontFamily: 'marmelad'),
                          ),
                          Text(
                            tanggal.format(today),
                            style: TextStyle(
                                fontSize: lebar / 20,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'heebo'),
                          ),
                          SizedBox(
                            height: lebar / 35,
                          ),
                          Text(
                            'Hi $namaPanggilan',
                            style: TextStyle(
                                fontSize: lebar / 20,
                                color: bg,
                                fontFamily: 'marmelad'),
                          ),
                          SizedBox(
                            height: lebar / 30,
                          ),
                          Text('Kamu belum nentuin absen kamu hari ini nih'),
                          Text('Absen dulu yuk'),
                          SizedBox(
                            height: lebar / 25,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Container(
                                child: ButtonTheme(
                                  minWidth: lebar / 4,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        side: uHadir
                                            ? BorderSide(color: bg)
                                            : BorderSide(color: polos),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(lebar / 50))),
                                    color: uHadir ? biru : oren,
                                    onPressed: () {
                                      if (uIzin)
                                        setState(() {
                                          uIzin = false;
                                        });
                                      setState(() {
                                        uHadir = true;
                                        absen = 'HADIR';
                                      });
                                    },
                                    child: Text(
                                      'Hadir',
                                      style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontSize: lebar / 25,
                                          color: uHadir ? bg : pText),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                child: ButtonTheme(
                                  minWidth: lebar / 4,
                                  child: RaisedButton(
                                    shape: RoundedRectangleBorder(
                                        side: uIzin
                                            ? BorderSide(color: bg)
                                            : BorderSide(color: polos),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(lebar / 50))),
                                    color: uIzin ? biru : oren,
                                    onPressed: () {
                                      if (uHadir)
                                        setState(() {
                                          uHadir = false;
                                        });
                                      setState(() {
                                        uIzin = true;
                                        absen = 'IZIN';
                                      });
                                    },
                                    child: Text(
                                      'Izin',
                                      style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontSize: lebar / 25,
                                          color: uIzin ? bg : pText),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: lebar / 35,
                          ),
                          if (uIzin)
                            TextFormField(
                              textCapitalization: TextCapitalization.sentences,
                              controller: alasan,
                              maxLines: 3,
                              cursorColor: item,
                              style:
                                  TextStyle(color: item, fontSize: lebar / 30),
                              decoration: InputDecoration(
                                  hintText:
                                      'Kasih alasannya dong kenapa kamu izin',
                                  fillColor: krem,
                                  filled: true,
                                  labelStyle: TextStyle(color: putih),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(width: 2, color: putih),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(lebar / 30),
                                      borderSide: BorderSide.none)),
                            ),
                          Container(
                            margin: EdgeInsets.symmetric(vertical: lebar / 30),
                            child: ButtonTheme(
                              height: lebar / 8,
                              minWidth: lebar,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(lebar / 50))),
                                color: oren,
                                onPressed: () {
                                  if (absen == '')
                                    return;
                                  else if (absen == 'IZIN' && alasan.text == '')
                                    return;
                                  setState(() {
                                    loading = true;
                                  });
                                  ApiAbsen().tambahAbsensi(
                                      absen, alasan.text, context);
                                  Timer(Duration(seconds: 3), () {
                                    setState(() {
                                      loading = false;
                                    });
                                  });
                                  // if (nama.text.isEmpty ||
                                  //     gender.text.isEmpty ||
                                  //     role.text.isEmpty) {
                                  //   return null;
                                  // }

                                  // setState(() {
                                  //   formController =
                                  //       PageController(initialPage: 0);
                                  // });
                                },
                                child: Text(
                                  'Aku Yakin',
                                  style: TextStyle(
                                      fontSize: lebar / 20, color: pText),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )),
            if (loading) ColorLoader3()
          ],
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:frontend/Component/Loader.dart';
import 'package:frontend/Component/Style.dart';
import 'package:frontend/Pages/LoginPengguna.dart';
import 'package:frontend/Service/index.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class DaftarPengguna extends StatefulWidget {
  const DaftarPengguna({Key? key}) : super(key: key);

  @override
  State<DaftarPengguna> createState() => _DaftarPenggunaState();
}

class _DaftarPenggunaState extends State<DaftarPengguna> {
  TextEditingController nama = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController role = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController konfirmasi = TextEditingController();

  List<DropdownMenuItem<String>> get genderItem {
    List<DropdownMenuItem<String>> itemGender = [
      DropdownMenuItem(child: Text("Laki - Laki"), value: "Laki-Laki"),
      DropdownMenuItem(child: Text("Perempuan"), value: "Perempuan"),
    ];
    return itemGender;
  }

  List<DropdownMenuItem<String>> get roleItem {
    List<DropdownMenuItem<String>> itemRole = [
      DropdownMenuItem(child: Text("Marketing"), value: "Marketing"),
      DropdownMenuItem(child: Text("Produksi"), value: "Produksi"),
      DropdownMenuItem(child: Text("Freelancer"), value: "Freelancer"),
    ];
    return itemRole;
  }

  PageController formController =
      PageController(initialPage: 0, keepPage: true);
  String? selectedValue;
  bool ob = false;
  bool ob2 = false;
  bool errorText = true;
  bool one = false;
  bool loading = false;
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
                                  'Register Account',
                                  style: TextStyle(
                                      color: putih, fontSize: lebar / 25),
                                ),
                              ),
                              Container(
                                margin:
                                    EdgeInsets.symmetric(vertical: lebar / 9),
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
                                      margin: EdgeInsets.only(left: lebar / 10),
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
                                height: tinggi / 3.5,
                                width: lebar,
                                child: PageView(
                                  controller: formController,
                                  physics: NeverScrollableScrollPhysics(),
                                  children: [
                                    Container(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: lebar / 30),
                                      child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            TextFormField(
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              controller: nama,
                                              cursorColor: putih,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  height: 1.4,
                                                  fontSize: lebar / 25),
                                              decoration: InputDecoration(
                                                labelText: 'Nama',
                                                labelStyle:
                                                    TextStyle(color: putih),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 2, color: putih),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                            DropdownButtonFormField(
                                                decoration: InputDecoration(
                                                  labelText: 'Jenis Kelamin',
                                                  labelStyle:
                                                      TextStyle(color: putih),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 2, color: putih),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 2, color: putih),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 2, color: putih),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                dropdownColor: bg,
                                                value: selectedValue,
                                                autofocus: false,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    height: 1,
                                                    fontSize: lebar / 25),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    gender.text = newValue!;
                                                  });
                                                },
                                                items: genderItem),
                                            DropdownButtonFormField(
                                                decoration: InputDecoration(
                                                  labelText: 'Role',
                                                  labelStyle:
                                                      TextStyle(color: putih),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 2, color: putih),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 2, color: putih),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  errorBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 2, color: putih),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                ),
                                                dropdownColor: bg,
                                                value: selectedValue,
                                                autofocus: false,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    height: 1,
                                                    fontSize: lebar / 25),
                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    role.text = newValue!;
                                                  });
                                                },
                                                items: roleItem),
                                          ]),
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(
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
                                                labelStyle:
                                                    TextStyle(color: putih),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 2, color: putih),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                                    onPressed: () =>
                                                        setState(() {
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
                                                labelStyle:
                                                    TextStyle(color: putih),
                                                enabledBorder:
                                                    OutlineInputBorder(
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
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                              controller: konfirmasi,
                                              cursorColor: putih,
                                              obscureText: !ob2,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  height: 1,
                                                  fontSize: lebar / 25),
                                              decoration: InputDecoration(
                                                suffixIcon: IconButton(
                                                    onPressed: () =>
                                                        setState(() {
                                                          ob2 = !ob2;
                                                        }),
                                                    icon: Icon(
                                                      !ob2
                                                          ? Icons
                                                              .visibility_off_rounded
                                                          : Icons
                                                              .visibility_rounded,
                                                      color: putih,
                                                    )),
                                                labelText:
                                                    'Konfirmasi Password',
                                                labelStyle:
                                                    TextStyle(color: putih),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 2, color: putih),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
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
                                  ],
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
                                      if (!one) {
                                        if (nama.text.isEmpty ||
                                            gender.text.isEmpty ||
                                            role.text.isEmpty) {
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
                                        } else {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          Timer(Duration(milliseconds: 100),
                                              () {
                                            formController.animateToPage(1,
                                                duration:
                                                    Duration(milliseconds: 900),
                                                curve: Curves.ease);
                                          });
                                          setState(() {
                                            one = true;
                                          });
                                        }
                                      } else {
                                        if (username.text.isNotEmpty ||
                                            password.text.isNotEmpty) {
                                          if (password.text.length >= 8) {
                                            if (konfirmasi.text ==
                                                password.text) {
                                              setState(() {
                                                loading = true;
                                              });
                                              ApiAkun().daftarAkun(
                                                  nama.text,
                                                  username.text,
                                                  password.text,
                                                  gender.text,
                                                  role.text,
                                                  context,
                                                  lebar);
                                              Timer(Duration(seconds: 3), () {
                                                setState(() {
                                                  loading = false;
                                                });
                                              });
                                            } else
                                              Alert(
                                                context: context,
                                                type: AlertType.error,
                                                style: AlertStyle(
                                                    animationDuration: Duration(
                                                        milliseconds: 500),
                                                    animationType:
                                                        AnimationType.fromTop,
                                                    titleStyle: TextStyle(
                                                        fontSize: lebar / 20),
                                                    descStyle: TextStyle(
                                                        fontSize: lebar / 25)),
                                                title: "Ada kesalahan",
                                                desc:
                                                    "Password dan konfirmasinya berbeda nih",
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
                                          } else {
                                            Alert(
                                              context: context,
                                              type: AlertType.error,
                                              style: AlertStyle(
                                                  animationDuration: Duration(
                                                      milliseconds: 500),
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
                                      }
                                    },
                                    child: Text(
                                      'Daftar',
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
                              if (one)
                                Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: lebar / 30,
                                  ),
                                  child: ButtonTheme(
                                    height: lebar / 10,
                                    child: RaisedButton(
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(lebar / 50))),
                                      color: biru,
                                      onPressed: () {
                                        formController.animateToPage(0,
                                            duration:
                                                Duration(milliseconds: 1000),
                                            curve: Curves.decelerate);
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
                          left: lebar / 40,
                          bottom: lebar / 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Sudah punya akun?',
                                style: TextStyle(
                                    color: pText,
                                    fontSize: lebar / 20,
                                    fontFamily: 'outfit'),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                        pageBuilder: (
                                          BuildContext context,
                                          Animation<double> animation,
                                          Animation<double> secondaryAnimation,
                                        ) =>
                                            LoginPengguna(),
                                        transitionDuration:
                                            Duration(seconds: 1),
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
                                },
                                child: Text(
                                  'Masuk',
                                  style: TextStyle(
                                      color: biru,
                                      fontSize: lebar / 20,
                                      fontFamily: 'outfit'),
                                ),
                              )
                            ],
                          ),
                          Row(
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

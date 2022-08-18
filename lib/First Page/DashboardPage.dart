import 'dart:async';
import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Component/Loader.dart';
import 'package:frontend/Component/Style.dart';
import 'package:frontend/First%20Page/SplashScreen.dart';
import 'package:frontend/Model/Data/DaftarPenggunaModel.dart';
import 'package:frontend/Model/Data/DataPerPenggunaModel.dart';
import 'package:frontend/Pages/AbsenPerPengguna.dart';
import 'package:frontend/Service/index.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  var db;
  bool loading = false;

  getDB() async {
    db = await SharedPreferences.getInstance();
  }

  final NetworkInfo info = NetworkInfo();
  String nama = '';
  var user;

  getWifiName() async {
    String? wifi;
    try {
      wifi = (await info.getLocationServiceAuthorization()) as String?;
      print(wifi);
    } catch (e) {}
  }

  getData() async {
    user = await ApiAkun().getDataPerAkun();
    setState(() {
      nama = user['nama'];
    });
    print(user['nama']);
  }

  String ket = '';

  DateTime? today;
  final jam = new DateFormat.jm('id');
  final tanggal = new DateFormat.yMMMMd('id');
  getWaktu() {
    today = new DateTime.now();
    print(today);
    print(jam.format(today!));

    var tes = num.parse(jam.format(today!));
    if (tes < 11.30) {
      setState(() {
        ket = 'Pagi';
      });
    } else if (tes > 11.30 && tes < 15.30) {
      setState(() {
        ket = 'Siang';
      });
    } else if (tes > 15.30 && tes < 18.00) {
      setState(() {
        ket = 'Sore';
      });
    } else if (tes > 18.00)
      setState(() {
        ket = 'Malam';
      });
  }

  FutureOr onGoBack(dynamic value) {
    getWaktu();
  }

  @override
  void initState() {
    // TODO: implement initState
    initializeDateFormatting();
    setState(() {
      loading = true;
    });
    Timer(Duration(seconds: 1), () {
      setState(() {
        loading = false;
      });
    });
    getDB();
    getData();
    // getWifiName();
    getData();
    getWaktu();
    super.initState();
  }

  // @override
  // void dispose() {
  //   getWaktu();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final tinggi = MediaQuery.of(context).size.height;
    final lebar = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: bg,
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Container(
                margin: EdgeInsets.only(
                    top: lebar / 35, left: lebar / 20, right: lebar / 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                        child: Text(
                      'Home',
                      style: TextStyle(
                          color: pText,
                          fontSize: lebar / 25,
                          fontFamily: 'heebo',
                          fontWeight: FontWeight.w600),
                    )),
                    SizedBox(
                      height: lebar / 35,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                nama,
                                style: TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    color: pText,
                                    fontSize: lebar / 15,
                                    fontFamily: 'outfit'),
                              ),
                              Text(
                                'Selamat $ket',
                                style: TextStyle(
                                    color: pText,
                                    fontSize: lebar / 30,
                                    fontFamily: 'outfit'),
                              ),
                              Text(
                                jam.format(today!),
                                style: TextStyle(
                                    color: pText,
                                    fontSize: lebar / 30,
                                    fontFamily: 'outfit'),
                              ),
                              Text(
                                tanggal.format(today!),
                                style: TextStyle(
                                    color: pText,
                                    fontSize: lebar / 30,
                                    fontFamily: 'outfit'),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: CircleAvatar(
                            maxRadius: lebar / 7,
                            child: Image.asset('assets/images/$ket.png',
                                fit: BoxFit.cover),
                          ),
                        )
                      ],
                    ),
                    Text(
                      'Fitur App',
                      style: TextStyle(
                          color: pText,
                          fontSize: lebar / 25,
                          fontFamily: 'heebo',
                          fontWeight: FontWeight.w600),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (
                              BuildContext context,
                              Animation<double> animation,
                              Animation<double> secondaryAnimation,
                            ) {
                              return AbsenPerPengguna();
                            },
                            transitionDuration: Duration(seconds: 2),
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
                          )).then((value) => onGoBack(value)),
                      child: Container(
                        margin: EdgeInsets.only(top: lebar / 30),
                        height: lebar / 10,
                        alignment: Alignment.center,
                        width: lebar,
                        decoration: BoxDecoration(
                            color: biru,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.shade600,
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 5),
                              )
                            ],
                            borderRadius: BorderRadius.circular(lebar / 40)),
                        child: Text(
                          'Absensi',
                          style: TextStyle(color: pText),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: tinggi / 1.7,
                    ),
                    Container(
                      child: ButtonTheme(
                        height: lebar / 8,
                        minWidth: lebar,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(lebar / 50))),
                          color: oren,
                          onPressed: () {
                            setState(() {
                              loading = true;
                            });
                            db.clear();
                            Timer(Duration(seconds: 2), () {
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (
                                      BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation,
                                    ) =>
                                        SplashScreen(),
                                    transitionDuration: Duration(seconds: 2),
                                    transitionsBuilder: (
                                      BuildContext context,
                                      Animation<double> animation,
                                      Animation<double> secondaryAnimation,
                                      Widget child,
                                    ) =>
                                        Align(
                                      child: SizeTransition(
                                        sizeFactor: animation,
                                        child: child,
                                      ),
                                    ),
                                  ),
                                  (route) => false);
                            });
                            Timer(Duration(seconds: 2), () {
                              setState(() {
                                loading = false;
                              });
                            });
                          },
                          child: Text(
                            'LOG OUT',
                            style:
                                TextStyle(fontSize: lebar / 20, color: pText),
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
            ),
          ),
          if (loading) ColorLoader3()
        ],
      ),
    );
  }
}




































// Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'Untuk kamu',
//                       style: TextStyle(
//                         fontSize: lebar / 30,
//                         fontFamily: 'heebo',
//                         fontWeight: FontWeight.w500,
//                         color: pText,
//                       ),
//                     ),
//                     DefaultTextStyle(
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: lebar / 25,
//                         fontFamily: 'heebo',
//                         fontWeight: FontWeight.w600,
//                         color: pText,
//                       ),
//                       child: AnimatedTextKit(
//                         animatedTexts: [
//                           FadeAnimatedText(
//                               '"Bekerja keraslah, bermimpilah lebih besar dan jadilah yang terbaik."'),
//                           FadeAnimatedText(
//                               '"Kegagalan ada bukan untuk ditakuti, tetapi untuk dipelajari."'),
//                           FadeAnimatedText(
//                               '"Guru terbaik kamu adalah kesalahan terakhir yang kamu lakukan."'),
//                           FadeAnimatedText(
//                               '"Jika hari ini sudah sempurna, maka apalah arti hari esok."'),
//                           FadeAnimatedText(
//                               '"Kesalahan adalah bukti bahwa kamu sedang mencoba."'),
//                           FadeAnimatedText(
//                               '"Kehidupan yang besar dimulai dari mimpi yang besar."'),
//                           FadeAnimatedText(
//                               '"Jenius adalah gabungan dari 1% gagasan, dan 99% kerja keras."'),
//                           FadeAnimatedText(
//                               '"Hidup ini sederhana, tapi kitalah yang membuatnya rumit." - Confucius'),
//                           FadeAnimatedText(
//                               '"Bekerjalah dengan ikhlas karena bekerja tanpa paksaan akan memberi hasil maksimal."'),
//                           FadeAnimatedText(
//                               '"Kegagalan terbesar adalah ketika tidak berani mencoba."'),
//                           FadeAnimatedText(
//                               '"Lihat ke atas agar terinspirasi, lihat ke bawah agar bersyukur."')
//                         ],
//                         isRepeatingAnimation: true,
//                         pause: Duration(milliseconds: 5000),
//                         repeatForever: true,
//                       ),
//                     ),
//                   ],
//                 ),
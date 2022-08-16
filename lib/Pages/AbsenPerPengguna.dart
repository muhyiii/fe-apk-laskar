import 'dart:async';

import 'package:flutter/material.dart';
import 'package:frontend/Component/Loader.dart';
import 'package:frontend/Component/Style.dart';
import 'package:frontend/Model/Data/DataAbsensiPerPengguna.dart';
import 'package:frontend/Service/index.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class AbsenPerPengguna extends StatefulWidget {
  @override
  State<AbsenPerPengguna> createState() => _AbsenPerPenggunaState();
}

class _AbsenPerPenggunaState extends State<AbsenPerPengguna> {
  late final hari;
  late final tanggal;
  var size;

  String namaPanggilan = '';
  DateTime today = new DateTime.now();

  bool uHadir = false;
  bool uIzin = false;

  bool loading = false;
  String absen = '';
  TextEditingController alasan = TextEditingController();
  TextEditingController panggilan = TextEditingController();

  late Future absent;
  var angka;
  Future getAbsen() async {
    absent = ApiAbsen().getAbsensiPerPengguna();
    var db = await SharedPreferences.getInstance();
  }

  _getEventsfromDay(
    tanggal,
  ) {
    return print(tanggal);
  }

  Map absensi = {};
  CalendarFormat format = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    initializeDateFormatting();
    hari = new DateFormat.EEEE('id');
    tanggal = new DateFormat.yMMMMd('id');

    getAbsen();
    super.initState();
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
        backgroundColor: putih,
        body: FutureBuilder(
          future: absent,
          initialData: 'Demo Name',
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ColorLoader3();
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('Ada Kesalahan');
              } else if (snapshot.hasData) {
                return SafeArea(
                  child: CustomScrollView(
                    physics: BouncingScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        backgroundColor: bg,
                        expandedHeight: lebar / 1.5,
                        title: Text('Daftar Absensi'),
                        centerTitle: true,
                        flexibleSpace: FlexibleSpaceBar(
                          stretchModes: [StretchMode.fadeTitle],
                          background: Padding(
                            padding: EdgeInsets.only(top: lebar / 7),
                            child:
                                Image.asset('assets/images/absenPengguna.png'),
                          ),
                        ),
                      ),

                      SliverToBoxAdapter(
                          child: TableCalendar(
                        firstDay: DateTime(2020),
                        lastDay: DateTime(2030),
                        focusedDay: DateTime.now(),
                        selectedDayPredicate: (day) {
                          return isSameDay(_selectedDay, day);
                        },
                        headerStyle: HeaderStyle(
                          formatButtonVisible: false,
                          titleCentered: true,
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                            // weekdayStyle: TextStyle(fontFamily: "popinsemi"),
                            weekendStyle: TextStyle(
                                fontFamily: "outfit", color: Colors.red)),
                        calendarStyle: CalendarStyle(
                            selectedDecoration: BoxDecoration(
                              color: biru,
                            ),
                            holidayTextStyle: TextStyle(color: Colors.red),
                            todayDecoration: BoxDecoration(
                              color: bg,
                            )),
                        onDaySelected: (selectedDay, focusedDay) {
                          setState(() {
                            _selectedDay = selectedDay;
                            _focusedDay =
                                focusedDay; // update `_focusedDay` here as well
                            print(_selectedDay);
                          });
                        },
                      )),
                      SliverToBoxAdapter(
                          child: Container(
                        margin: EdgeInsets.symmetric(horizontal: lebar / 20),
                        height: lebar / 5,
                        child: ListView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            // print(tes.first.tanggal);
                            print(snapshot.data);
                            var tes = snapshot.data;
                            var let = tes
                                .where((element) =>
                                    element.tanggal.day == _selectedDay.day &&
                                    element.tanggal.month == _selectedDay.month)
                                .length;
                            print(let);
                            // return Text('ds');
                            // var let = tes
                            //     .where((element) =>
                            //         element.tanggal.day == _selectedDay.day &&
                            //         element.tanggal.month == _selectedDay.month)
                            //     .length;
                            var ab;
                            // print(tes[index].tanggal);
                            if (let == 1) {
                              ab = tes
                                  .where((element) =>
                                      element.tanggal.year ==
                                          _selectedDay.year &&
                                      element.tanggal.day == _selectedDay.day &&
                                      element.tanggal.month ==
                                          _selectedDay.month)
                                  .toList();
                            } else
                              ab = null;
                            // print(ab.first.absen);
                            return Column(
                              children: [
                                Text(let != 1
                                    ? _selectedDay.weekday == 6 ||
                                            _selectedDay.weekday == 7
                                        ? 'Hari Libur'
                                        : 'Data Tidak Ada'
                                    : ab.first.absen),
                                if (let == 1) Text(ab.first.keterangan)
                              ],
                            );
                          },
                        ),
                      ))
                      // SliverToBoxAdapter(
                      //   child: Container(color: putih,
                      //       margin: EdgeInsets.symmetric(
                      //           horizontal: lebar / 15, vertical: lebar / 35),
                      //       child: Text(
                      //         'Daftar Kehadiran',
                      //         style: TextStyle(
                      //             fontSize: lebar / 20,
                      //             fontFamily: 'heebo',
                      //             fontWeight: FontWeight.w600),
                      //       )),
                      // ),
                      // SliverToBoxAdapter(
                      //   child: Container(
                      //     margin: EdgeInsets.symmetric(
                      //         horizontal: lebar / 30, vertical: lebar / 35),

                      //     child: Column(
                      //       mainAxisAlignment: MainAxisAlignment.spaceAround,
                      //       children: tes
                      //           .map(
                      //             (ee) => Container( decoration: BoxDecoration(
                      //         color: biru,
                      //         borderRadius: BorderRadius.circular(lebar / 30)),
                      //             margin: EdgeInsets.only(top: 10),
                      //               child: ListTile(
                      //                 leading: CircleAvatar(
                      //                   child: Text(ee.tanggal.day.toString()),
                      //                 ),
                      //                 title: Text(ee.absen),
                      //                 subtitle: Text(ee.tanggal.hour.toString() +'.'+ ee.tanggal.minute.toString()),
                      //                 trailing: Icon(Icons.chevron_right_rounded),
                      //               ),
                      //             ),
                      //           )
                      //           .toList(),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                );
              } else {
                return const Text('Data Tidak Ada');
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          },
        ),
      ),
    );
  }

  builditem(BuildContext, lebar) {
    return Container(
      height: 100,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Container(
            height: 200,
            margin: EdgeInsets.symmetric(
                horizontal: lebar / 30, vertical: lebar / 35),
            decoration: BoxDecoration(
                color: biru, borderRadius: BorderRadius.circular(lebar / 30)),
            child: ListTile(
              leading: CircleAvatar(
                child: Text('1'),
              ),
              title: Text('HADIR'),
              subtitle: Text('08.20'),
              trailing: Icon(Icons.chevron_right_rounded),
            ),
          );
        },
      ),
    );
  }
}


// Stack(
//           children: [
//             SafeArea(
//                 child: Container(
//               child: Stack(
//                 children: [
//                   Positioned(
//                     left: lebar / 4,
//                     top: 20,
//                     child: Container(
//                       height: lebar / 2,
//                       width: lebar,
//                       decoration: BoxDecoration(
//                           image: DecorationImage(
//                               image: AssetImage(
//                                   'assets/images/absenPengguna.png'))),
//                     ),
//                   ),
//                   Container(
//                     height: tinggi / 3,
//                     padding: EdgeInsets.symmetric(horizontal: lebar / 30),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Icon(
//                           Icons.chevron_left_rounded,
//                           size: lebar / 8,
//                           color: pText,
//                         ),
//                         Text(
//                           'Agustus',
//                           style: TextStyle(
//                               color: putih,
//                               fontFamily: 'outfit',
//                               fontSize: lebar / 10),
//                         )
//                       ],
//                     ),
//                   ),
//                   Align(
//                     alignment: Alignment.bottomCenter,
//                     child: Container(
//                       padding: EdgeInsets.symmetric(
//                           vertical: lebar / 15, horizontal: lebar / 15),
//                       width: lebar,
//                       height: tinggi / 1.4,
//                       decoration: BoxDecoration(
//                           boxShadow: [
//                             //background color of box
//                             BoxShadow(
//                               color: bg,
//                               blurRadius: 5.0, // soften the shadow
//                               spreadRadius: 2.0, //extend the shadow
//                               offset: Offset(
//                                 0, // Move to right 10  horizontally
//                                 0.5, // Move to bottom 10 Vertically
//                               ),
//                             )
//                           ],
//                           color: putih,
//                           borderRadius: BorderRadius.vertical(
//                               top: Radius.circular(lebar / 12))),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Daftar Kehadiran'),
//                           // tes.map((e) {
//                           //   return ListTile(
//                           //     title: Text(e.absen),
//                           //   );
//                           // }).toList()
//                         ],
//                       ),
//                     ),
//                   )
//                 ],
//               ),
//             )),
//             if (loading) ColorLoader3()
//           ],
//         )
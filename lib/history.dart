import 'dart:convert';

import 'package:exercise/loading.dart';
import 'package:exercise/nogication.dart';
import 'package:exercise/playvideo.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class History extends StatefulWidget {
  @override
  _DataTableExample createState() => _DataTableExample();
}

class _DataTableExample extends State<History> {
  String name;
  String email;
  String id;
  String tokens;
  var data = [
    DataRow(cells: [
      DataCell(Text('27-02-2564')),
      DataCell(Text('21:46')),
    ]),
  ];

  Future<bool> checktoken() async {
    if (tokens == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      String url = 'https://infinite-caverns-30215.herokuapp.com/getdata/${decodedToken['id']}';
      var response = await http.get(url);
      var uu = jsonDecode(response.body);
      data.clear();
      for (var prop in uu['status']) {
        data.add(
          DataRow(cells: [
            DataCell(Text(prop[1])),
            DataCell(Text(prop[2])),
          ]),
        );
      }
      setState(() {
        tokens = token;
        email = decodedToken['email'];
        name = decodedToken['name'];
        id = decodedToken['id'];
      });
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: checktoken(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (tokens != null) {
            return MaterialApp(
              home: Scaffold(
                appBar: AppBar(
                  title: Text('สิถิติการออกกำลังกาย'),
                ),
                body: ListView(children: <Widget>[
                  Center(
                      child: Text(
                    'สิถิติการออกกำลังกาย',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  )),
                  DataTable(columns: [
                    DataColumn(
                        label: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text('วัน',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    )),
                    DataColumn(
                        label: Text('เวลา',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold))),
                  ], rows: data),
                ]),
                drawer: Container(
                  width: width * 0.6,
                  child: Drawer(
                    // Add a ListView to the drawer. This ensures the user can scroll
                    // through the options in the drawer if there isn't enough vertical
                    // space to fit everything.
                    child: ListView(
                      // Important: Remove any padding from the ListView.
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        DrawerHeader(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                child: Image.asset(
                                  'assets/logo.png',
                                ),
                              ),
                              Text('ชื่อ : $name'),
                              Text('อีเมล์ : $email')
                            ],
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            'วีดีโอ',
                            style: TextStyle(fontSize: 18),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Playvideo()));
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            // Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: Text(
                            'ตั้งค่า',
                            style: TextStyle(fontSize: 18),
                          ),
                          onTap: () async {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Notication()));
                          },
                        ),
                        ListTile(
                          title: Text(
                            'ออกจากระบบ',
                            style: TextStyle(fontSize: 18),
                          ),
                          onTap: () async {
                            // Update the state of the app
                            // ...
                            // Then close the drawer
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.clear();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyApp()));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              body: Loading(),
            );
          }
        });
  }
}

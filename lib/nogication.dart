import 'dart:async';
import 'dart:convert';

import 'package:exercise/history.dart';
import 'package:exercise/loading.dart';
import 'package:exercise/main.dart';
import 'package:exercise/playvideo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Notication extends StatefulWidget {
  @override
  _NoticationState createState() => _NoticationState();
}

class _NoticationState extends State<Notication> {
  TimeOfDay time;
  TimeOfDay timeday;
  TimeOfDay picked;
  DateTime _dateTime;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
  String name;
  String email;
  String id;
  String tokens;
  Timer timer;
  String payLoad;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    initializing();
    _dateTime = DateTime.now();
    // time = TimeOfDay.now();
    // timeday = TimeOfDay.now();
  }

  Future<bool> checktoken() async {
    if (tokens == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token');
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      time = TimeOfDay(
          hour: int.parse(decodedToken['morning'].split(":")[0]),
          minute: int.parse(decodedToken['morning'].split(":")[1]));
      timeday = TimeOfDay(
          hour: int.parse(decodedToken['Evening'].split(":")[0]),
          minute: int.parse(decodedToken['Evening'].split(":")[1]));
      setState(() {
        print(decodedToken);
        tokens = token;
        email = decodedToken['email'];
        name = decodedToken['name'];
        id = decodedToken['id'].toString();
      });
    }
    return true;
  }

  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('app_icon');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }
  void _showNotificationsAfterSecond() async {
    await notificationAfterSec();
  }

  void _showNotificationsAfterSecondday() async {
    await notificationAfterday();
  }

  Future<void> notificationAfterSec() async {
    print('เช้า');
    var now = new DateTime.now();
    var timenow = TimeOfDay.now();
    var tod = time;
    // var tod = TimeOfDay(hour: 20, minute: 00);
    double _doubleYourTime = tod.hour.toDouble() + (tod.minute.toDouble() / 60);
    double _doubleNowTime =
        timenow.hour.toDouble() + (timenow.minute.toDouble() / 60);
    print('now ${_doubleNowTime}');
    print('Your ${_doubleYourTime}');
    var timeDelayed = Time(int.parse(tod.hour.toString()),int.parse(tod.minute.toString()));
    
    // if (_doubleYourTime < _doubleNowTime) {
    //   print("น้อยกว่า");
    //   timeDelayed =
    //       DateTime(now.year, now.month, now.day + 1, tod.hour, tod.minute);
    //   print(timeDelayed);
    // }
    // if (_doubleYourTime >= _doubleNowTime) {
    //   print("มากกว่า");
    //   timeDelayed =
    //       DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    //   print(timeDelayed);
    // }
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'second channel ID', 'second Channel title', 'second channel body',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: "ticker");

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.showDailyAtTime(1, 'คุณ $name',
        'ถึงเวลาออกกำลังกายแล้ว นะคะ', timeDelayed, notificationDetails,
        payload: 'morning-${timeday.hour}:${timeday.minute}');
  }

  Future<void> notificationAfterday() async {
    print('เย็น');
    var now = new DateTime.now();
    var timenow = TimeOfDay.now();
    var tod = timeday;
    // var tod = TimeOfDay(hour: 20, minute: 00);
    double _doubleYourTime = tod.hour.toDouble() + (tod.minute.toDouble() / 60);
    double _doubleNowTime =
        timenow.hour.toDouble() + (timenow.minute.toDouble() / 60);
    print('now ${_doubleNowTime}');
    print('Your ${_doubleYourTime}');
    var timeDelayed = Time(int.parse(tod.hour.toString()),int.parse(tod.minute.toString()));
    // if (_doubleYourTime < _doubleNowTime) {
    //   print("น้อยกว่า");
    //   timeDelayed =
    //       DateTime(now.year, now.month, now.day + 1, tod.hour, tod.minute);
    //   print(timeDelayed);
    // }
    // if (_doubleYourTime >= _doubleNowTime) {
    //   print("มากกว่า");
    //   timeDelayed =
    //       DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    //   print(timeDelayed);
    // }
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'second channel ID', 'second Channel title', 'second channel body',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: 'ticker');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.showDailyAtTime(1, 'คุณ $name',
        'ถึงเวลาออกกำลังกายแล้ว นะคะ', timeDelayed, notificationDetails,
        payload: 'Evening-${time.hour}:${time.minute}');
  }

  Future onSelectNotification(String payLoad) async {
    print(payLoad);

    if (payLoad != null) {
      if (payLoad.split("-")[0] == 'Evening') {
        setState(() {
          time = TimeOfDay(
              hour: int.parse(payLoad.split("-")[1].split(":")[0]),
              minute: int.parse(payLoad.split("-")[1].split(":")[1]));
        });
        _showNotificationsAfterSecond();
      }
      if (payLoad.split("-")[0] == 'morning') {
        setState(() {
          timeday = TimeOfDay(
              hour: int.parse(payLoad.split("-")[1].split(":")[0]),
              minute: int.parse(payLoad.split("-")[1].split(":")[1]));
        });
        _showNotificationsAfterSecondday();
      }
    }

    // we can set navigator to navigate another screen
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("sdfsfsf");
            },
            child: Text("Okay")),
      ],
    );
  }

  void sendtime() async {
    setState(() {
      isLoading = false;
    });
    String url = 'https://infinite-caverns-30215.herokuapp.com/updatetime';
    String json =
        '{"id": "${id}","morning": "${time.hour}:${time.minute}","Evening":"${timeday.hour}:${timeday.minute}"}';
    var response = await http.post(url, body: json);
    var uu = jsonDecode(response.body);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', uu['status']);
    setnoti();
    setState(() {
      isLoading = true;
    });
  }

  void setnoti() {
    var timenow = TimeOfDay.now();
    double _doubleYourTime =
        time.hour.toDouble() + (time.minute.toDouble() / 60);
    double _doubleNowTime =
        timenow.hour.toDouble() + (timenow.minute.toDouble() / 60);
    if (_doubleYourTime < _doubleNowTime) {
      _showNotificationsAfterSecondday();
    }
    if (_doubleYourTime >= _doubleNowTime) {
      _showNotificationsAfterSecond();
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('กรุณาเลือกเวลาตามที่ต้องการ'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(
                  height: 80,
                  child: CupertinoDatePicker(
                    initialDateTime: _dateTime,
                    use24hFormat: true,
                    mode: CupertinoDatePickerMode.time,
                    onDateTimeChanged: (dateTime) {
                      setState(() {
                        time = TimeOfDay(
                            hour: dateTime.hour, minute: dateTime.minute);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ยืนยัน'),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _showMyDialogday() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('กรุณาเลือกเวลาตามที่ต้องการ'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(
                  height: 80,
                  child: CupertinoDatePicker(
                    initialDateTime: _dateTime,
                    use24hFormat: true,
                    mode: CupertinoDatePickerMode.time,
                    onDateTimeChanged: (dateTime) {
                      setState(() {
                        timeday = TimeOfDay(
                            hour: dateTime.hour, minute: dateTime.minute);
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ยืนยัน'),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return FutureBuilder(
        future: checktoken(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (tokens != null) {
            return Scaffold(
              appBar: AppBar(title: Text("ตั้งค่า")),
              body: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.access_alarm),
                              title: Text('เวลาการเเจ้งเตือนในตอนเช้า'),
                              subtitle: Text(
                                '${time.hour}:${time.minute}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                const SizedBox(width: 8),
                                TextButton(
                                  child: const Text('เปลี่ยนเวลา'),
                                  onPressed: () {
                                    _showMyDialog();
                                  },
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.access_alarm),
                              title: Text('เวลาการเเจ้งเตือนในตอนเย็น'),
                              subtitle: Text(
                                '${timeday.hour}:${timeday.minute}',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                const SizedBox(width: 8),
                                TextButton(
                                  child: const Text('เปลี่ยนเวลา'),
                                  onPressed: () {
                                    _showMyDialogday();
                                  },
                                ),
                                const SizedBox(width: 8),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    isLoading
                        ? RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.red)),
                            child: Text('ยืนการตั้งแจ้งเตือน'),
                            color: Color(0xffEE7B23),
                            onPressed: () {
                              sendtime();
                              // _showNotificationsAfterSecond();
                            },
                          )
                        : Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
              drawer: Container(
                width: width * 0.6,
                child: Drawer(
                  child: ListView(
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
                        },
                      ),
                      ListTile(
                        title: Text(
                          'สถิติ',
                          style: TextStyle(fontSize: 18),
                        ),
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => History()));
                        },
                      ),
                      ListTile(
                        title: Text(
                          'ออกจากระบบ',
                          style: TextStyle(fontSize: 18),
                        ),
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.clear();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => MyApp()));
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(body: Loading());
          }
        });
  }
}

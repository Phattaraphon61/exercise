import 'package:exercise/playvideo.dart';
import 'package:exercise/register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notication extends StatefulWidget {
  @override
  _NoticationState createState() => _NoticationState();
}

class _NoticationState extends State<Notication> {
  TimeOfDay time;
  TimeOfDay picked;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;
  var timeDelayed;

  @override
  void initState() {
    super.initState();
    initializing();
    time = TimeOfDay.now();
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

  void _showNotifications() async {
    await notification();
  }

  void _showNotificationsAfterSecond() async {
    await notificationAfterSec();
  }

  Future<void> notification() async {
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'Channel ID', 'Channel title', 'channel body',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        0, 'Hello there', 'please subscribe my channel', notificationDetails);
  }

  Future<void> notificationAfterSec() async {
    var now = new DateTime.now();
    var timenow = TimeOfDay.now();
    var tod = time;
    // var tod = TimeOfDay(hour: 20, minute: 00);
    double _doubleYourTime = tod.hour.toDouble() + (tod.minute.toDouble() / 60);
    double _doubleNowTime =
        timenow.hour.toDouble() + (timenow.minute.toDouble() / 60);
    print('now ${_doubleNowTime}');
    print('Your ${_doubleYourTime}');
    if (_doubleYourTime < _doubleNowTime) {
      print("น้อยกว่า");
      timeDelayed =
          DateTime(now.year, now.month, now.day + 1, tod.hour, tod.minute);
      print(timeDelayed);
    }
    if (_doubleYourTime >= _doubleNowTime) {
      print("มากกว่า");
      timeDelayed =
          DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
      print(timeDelayed);
    }
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            'second channel ID', 'second Channel title', 'second channel body',
            priority: Priority.High,
            importance: Importance.Max,
            ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
        NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.schedule(
      1,
      'Hello there',
      '5555555',
      timeDelayed,
      notificationDetails,
    );
  }

  Future onSelectNotification(String payLoad) {
    print("6666");
    if (payLoad != null) {
      print("88888");
      print(payLoad);
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
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (timePicked != null)
      setState(() {
        time = timePicked;
      });
    print(time);
    _showNotificationsAfterSecond();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("setting")),
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              color: Colors.blue,
              onPressed: _showNotifications,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Show Notification",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
            FlatButton(
              color: Colors.blue,
              onPressed: _showNotificationsAfterSecond,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Show Notification after few sec",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
            FlatButton(
              onPressed: () {
                _selectTime(context);
                print(time);
              },
              color: Colors.blue,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "testpickedclok",
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Item 1'),
              onTap: () {
                print("ddd");
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Playvideo()));
                // Update the state of the app
                // ...
                // Then close the drawer
                // Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Item 2'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

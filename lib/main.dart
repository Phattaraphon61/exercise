import 'dart:convert';
import 'package:exercise/history.dart';
import 'package:exercise/loading.dart';
import 'package:exercise/login.dart';
import 'package:exercise/nogication.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

void main(){
runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String tokens;
  String ttt;
  Future<bool> loadList() async {
    if (ttt != 'Welcome') {
      String url = 'https://infinite-caverns-30215.herokuapp.com';
      var response = await http.get(url);
      var uu = jsonDecode(response.body);
      print(uu);
      setState(() {
        ttt = uu['status'];
      });
      if (uu['status'] == 'Welcome') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String token = prefs.getString('token');
        print(token);
        setState(() {
          tokens = token;
        });

      }
    }
    // String url = 'https://infinite-caverns-30215.herokuapp.com';
    // var response = await http.get(url);
    // var uu = jsonDecode(response.body);
    // print(uu);
    // if (uu['status'] == 'Welcome') {
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //   String token = prefs.getString('token');
    //   print(token);
    //   setState(() {
    //     tokens = token;
    //   });
    //   return true;
    // }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Deomos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder(
        future: loadList(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (tokens != null) {
              return Scaffold(
                body: History(),
              );
            } if(tokens == null) {
              print("ddddd");
              return Scaffold(
                body: Login(),
              );
            }
            // return Scaffold(
            //   body: Notication(),
            // );
          } else {
            return Scaffold(
              body: Loading(),
            );
          }
        },
      ),
    );
  }
}

// class MyApp extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: Scaffold(
//         backgroundColor: Colors.blue[900],
//         body: Center(
//           child: SpinKitPouringHourglass(
//             color: Colors.white,
//             size: 120,
//           ),
//         ),
//       )
//     );
//   }
// }

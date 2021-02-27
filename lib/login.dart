import 'dart:convert';

import 'package:exercise/main.dart';
import 'package:exercise/playvideo.dart';
import 'package:exercise/register.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'nogication.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = true;
  bool _passwordVisible = true;
  final email = TextEditingController();
  final password = TextEditingController();

  void signin() async {
    String url = 'http://192.168.1.64:5000/signin';
    String json = '{"email": "${email.text}","password":"${password.text}"}';
    var response = await http.post(url, body: json);
    var uu = jsonDecode(response.body);
    if (uu['status'] == "singin success") {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', uu['token']);
      Navigator.push(context, MaterialPageRoute(builder: (context) => MyApp()));
    }
    setState(() {
    isLoading = true;
    });
    
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: width,
                height: height * 0.45,
                child: Image.asset(
                  'logo.png',
                  fit: BoxFit.fill,
                ),
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isLoading
                        ? Text("")
                        : Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'เข้าสู่ระบบ',
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30.0,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: email,
                  // style: TextStyle(height: 0.1),
                  decoration: InputDecoration(
                    hintText: 'อีเมล์',
                    isDense: true,
                    contentPadding: EdgeInsets.all(8),
                    suffixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: password,
                  obscureText: _passwordVisible,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: 'รหัสผ่าน',
                    isDense: true,
                    contentPadding: EdgeInsets.all(8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        // Based on passwordVisible state choose the icon
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ลืมรหัสผ่าน',
                      style: TextStyle(fontSize: 12.0),
                    ),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)),
                      child: Text('ยืนยัน'),
                      color: Color(0xffEE7B23),
                      onPressed: () {
                        setState(() {
                          isLoading = false;
                        });

                        signin();
                        // Navigator.push(context,
                        //     MaterialPageRoute(builder: (context) => Playvideo()));
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Second()));
                },
                child: Text.rich(
                  TextSpan(text: 'ไปหน้า', children: [
                    TextSpan(
                      text: 'สมัครสมาชิก',
                      style: TextStyle(color: Color(0xffEE7B23)),
                    ),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

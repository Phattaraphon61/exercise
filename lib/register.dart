import 'dart:convert';

import 'package:exercise/login.dart';
import 'package:exercise/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Second extends StatefulWidget {
  @override
  _SecondState createState() => _SecondState();
}

class _SecondState extends State<Second> {
  bool erroremail = false;
  bool _passwordVisible = true;
  bool _passwordVisibles = true;
  bool errorpass = false;
  bool errorconpass = false;
  bool isLoading = true;
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final conpassword = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    conpassword.dispose();
    super.dispose();
  }

  void signup() async {
    setState(() {
      isLoading = false;
      erroremail = false;
    });
    String url = 'https://infinite-caverns-30215.herokuapp.com/signup';
    String json =
        '{"name": "${name.text}","email": "${email.text}","password":"${password.text}"}';
    var response = await http.post(url, body: json);
    var uu = jsonDecode(response.body);
    print(uu['status']);
    if (uu['status'] == 'this email has already been used') {
      setState(() {
        isLoading = true;
        erroremail = true;
      });
    }
    if (uu['status'] == "success") {
      print("yes");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Login()));
      setState(() {
        isLoading = true;
      });
    }
  }

  void checktext() {
    setState(() {
      errorconpass = false;
      errorpass = false;
    });
    if (password.text.length >= 8 && password.text == conpassword.text) {
      signup();
    }
    if (password.text.length < 8) {
      setState(() {
        errorpass = true;
      });
    }
    if (password.text != conpassword.text) {
      setState(() {
        errorconpass = true;
      });
    }
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
                height: height * 0.15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'สมัครสมาชิก',
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: name,
                  decoration: InputDecoration(
                    hintText: 'ชื่อ นามสกุล',
                    isDense: true,
                    contentPadding: EdgeInsets.all(8),
                    suffixIcon: Icon(Icons.account_box),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: email,
                  decoration: InputDecoration(
                    hintText: 'อีเมล์',
                    isDense: true,
                    contentPadding: EdgeInsets.all(8),
                    suffixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    errorText: erroremail ? 'อีเมล์นี้มีคนใช้ไปแล้ว' : null,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: password,
                  obscureText: _passwordVisibles,
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
                        _passwordVisibles
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        // Update the state i.e. toogle the state of passwordVisible variable
                        setState(() {
                          _passwordVisibles = !_passwordVisibles;
                        });
                      },
                    ),
                    errorText:
                        errorpass ? 'รหัสผ่านต้องมีอย่างน้อย 8 ตัว' : null,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: conpassword,
                  obscureText: _passwordVisible,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    hintText: 'ยืนยันรหัสผ่าน',
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
                    errorText: errorconpass ? 'รหัสผ่านไม่ตรงกัน' : null,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    isLoading
                        ? RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                                side: BorderSide(color: Colors.red)),
                            child: Text('ยืนยันการสมัครสมาชิก'),
                            color: Color(0xffEE7B23),
                            onPressed: () {
                              checktext();
                            },
                          )
                        : Center(child: CircularProgressIndicator()),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Login()));
                },
                child: Text.rich(
                  TextSpan(text: 'กลับไปหน้า', children: [
                    TextSpan(
                      text: 'เข้าสู่ระบบ',
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

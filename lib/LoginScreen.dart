import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Forget.dart';
import 'SignUp.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController phone, password;
  final url = "https://familybaskets.co.in/api/login.php";

  @override
  void initState() {
    phone = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: Text('SignIn'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'image/login.json',
                ),
                TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Field is empty';
                    }
                    return null;
                  },
                  controller: phone,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter phone',
                    label: Text('Phone'),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  validator: (text) {
                    if (text == null || text.isEmpty) {
                      return 'Field is empty';
                    }
                    return null;
                  },
                  controller: password,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter Password',
                    label: Text('Password'),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                MaterialButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    if (_formKey.currentState.validate()) {
                      final response = await http.post(Uri.parse(url), body: {
                        "action": "login",
                        "phone": phone.text.toString(),
                        "password": password.text.toString(),
                      });
                      // print(response.body);
                      final body = json.decode(response.body);
                      if (body['status'] == 200) {
                        await prefs.setBool('login', true);
                        await prefs.setString(
                            'userid', body['data']['username']);
                        await prefs.setString('name', body['data']['name']);
                        await prefs.setString(
                            'username', body['data']['username']);
                        await prefs.setString('phone', body['data']['phone']);
                        Fluttertoast.showToast(msg: body['message']);
                        print(body);
                        Navigator.pop(context);
                      } else {
                        Fluttertoast.showToast(msg: body['message']);
                        print(body);
                      }
                    }
                  },
                  // onPressed: () => Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => Dashboard())),
                  minWidth: double.maxFinite,
                  color: Colors.lightGreen,
                  shape: RoundedRectangleBorder(),
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child: Text(
                        'SignIn',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                        textScaleFactor: 1.0,
                      )),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(onTap: () =>Navigator.push(context, new MaterialPageRoute(builder: (context) => Forget())),
                    child: Text('Forget Password',style: TextStyle(fontWeight: FontWeight.w500),))
                  ],
                ),
                Align(
                  alignment: Alignment.center,
                  child: ListTile(
                    title: Text(
                      "Don't have account?",
                    ),
                    subtitle: InkWell(
                        onTap: () => Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => SignUp()),
                            ),
                        child: Text(
                          'Signup Here',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.red),
                        )),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

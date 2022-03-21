import 'dart:convert';
import 'package:call_look/verifyOtp.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key key}) : super(key: key);

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController email, name, password, phone;
  final urlSms = "https://www.calllook.com/api/sms.php";
  final urlprivacypolicy = "https://www.calllook.com/api/privacy.php";
  final urltermsofservice = "https://www.calllook.com/api/terms.php";

  @override
  void initState() {
    email = TextEditingController();
    name = TextEditingController();
    phone = TextEditingController();
    password = TextEditingController();
    getprivacyandpolicy();
    getTermsOfService();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(
        title: Text('SignUp'),
      ),
      body: Form(
        key: _formKey,
        child: Container(
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('image/Signup.json'),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Text is empty';
                      }
                      return null;
                    },
                    controller: name,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Full Name',
                      label: Text('Name'),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Text is empty';
                      }
                      return null;
                    },
                    controller: phone,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Mobile No',
                      label: Text('Phone'),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Text is empty';
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
                    height: 15,
                  ),
                  MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setString('name', name.text);
                        prefs.setString('phone', phone.text);
                        prefs.setString('password', password.text);
                        Navigator.of(context).pushReplacement(new MaterialPageRoute(
                          builder: (context) => verifyOtp(),
                        ));
                        final response = await http.post(Uri.parse(urlSms),
                            body: {
                              "name": name.text.toString(),
                              "phone": phone.text.toString()
                            });
                        final body = json.decode(response.body);
                        if (body['status'] == 200) {
                          Fluttertoast.showToast(msg: body['message']);
                          generateOtp(body);
                          print(body);
                        } else if (body['status'] == 404) {
                          Fluttertoast.showToast(msg: body['message']);
                          print(body);
                        }
                      }
                    },
                    minWidth: double.maxFinite,
                    color: Colors.lightGreen,
                    shape: RoundedRectangleBorder(),
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: Text(
                          'SignUp',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                          textScaleFactor: 1.0,
                        )),
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Center(
                        child: Text.rich(TextSpan(
                            text: 'By continuing, you agree to our ',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                            children: <TextSpan>[
                          // TextSpan(
                          //     text: 'Terms of Service',
                          //     style: TextStyle(
                          //       fontSize: 16,
                          //       color: Colors.blue,
                          //       decoration: TextDecoration.underline,
                          //     ),
                          //     recognizer: TapGestureRecognizer()
                          //       ..onTap = () {
                          //         launchtermsodservices();
                          //       }),
                          TextSpan(
                              // text: ' and ',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                              children: <TextSpan>[
                                TextSpan(
                                    text: 'Privacy Policy',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        launchprivacy();
                                      })
                              ])
                        ]))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void generateOtp(body) async {
  }

  void getprivacyandpolicy() async{
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(urlprivacypolicy),);
    final body = json.decode(response.body);
    if (body['status'] == 200) {
      print(body);
      prefs.setString('privacypolicy', body['data'].toString().trim());
    } else if (body['status'] == 404) {
      Fluttertoast.showToast(msg: 'Something went wrong');
      print(body);
    }
  }

  void getTermsOfService() async{
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(urltermsofservice),);
    final body = json.decode(response.body);
    if (body['status'] == 200) {
      prefs.setString('termsofservice', body['data'].toString().trim());
      print(body);
    } else if (body['status'] == 404) {
      Fluttertoast.showToast(msg: 'Something went wrong');
      print(body);
    }
  }

  void launchprivacy() async {
    final prefs = await SharedPreferences.getInstance();
    var _url = "https://"+prefs.getString('privacypolicy');
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }

  void launchtermsodservices() async {
    final prefs = await SharedPreferences.getInstance();
    var _url = "https://"+prefs.getString('termsofservice');
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
  }
}

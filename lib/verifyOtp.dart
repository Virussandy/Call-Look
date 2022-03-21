import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class verifyOtp extends StatefulWidget {
  @override
  _verifyOtpState createState() => _verifyOtpState();
}

class _verifyOtpState extends State<verifyOtp> {
  TextEditingController otp;
  final _formKey = GlobalKey<FormState>();
  String otpValue;
  final urlSignUp = "https://www.calllook.com/api/login.php";
  final urlSms = "https://www.calllook.com/api/sms.php";
  BuildContext dialogContext;

  @override
  void initState() {
    otp = TextEditingController();
    getotp();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Otp Verification'),),
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
                  Lottie.asset('image/otp.json'),
                  SizedBox(height: 15,),
                  TextFormField(
                    validator: (text) {
                      if (text == null || text.isEmpty) {
                        return 'Text is empty';
                      }
                      return null;
                    },
                    controller: otp,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter Otp',
                      label: Text('Otp'),
                    ),
                  ),
                  SizedBox(height: 15,),
                  MaterialButton(onPressed: ()async {
                    if (_formKey.currentState.validate()) {
                      if(otpValue == otp.text.toString()){
                        showLoading();
                        final prefs = await SharedPreferences.getInstance();
                        final response = await http.post(Uri.parse(urlSignUp),
                            body: {
                          "action":"register",
                              "name":prefs.getString('name'),
                              "phone" : prefs.getString('phone'),
                              "password" : prefs.getString('password'),
                              "deviceid": prefs.getString('deviceid')
                            });
                        final body = json.decode(response.body);
                        if(body['status'] == 200){
                          print(response.body);
                          Fluttertoast.showToast(msg: body['message']);
                        }else{
                          print(response.body);
                          Fluttertoast.showToast(msg: body['message']);
                        }
                        Fluttertoast.showToast(msg: 'Account Created Successfully');
                        Navigator.pop(dialogContext);
                        Navigator.pop(context);
                      }else{
                        Fluttertoast.showToast(msg: 'Please enter correct otp');
                      }
                    }
                  },
                    minWidth: double.maxFinite,
                    color: Colors.lightGreen,
                    shape: RoundedRectangleBorder(),
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: Text('Submit',style: TextStyle(fontSize: 20,color: Colors.white),textScaleFactor: 1.0,)),
                  ),
                  SizedBox(height: 15,),
                  SizedBox(
                    child: Text.rich(TextSpan(text: "Didn't get otp? ",style: TextStyle(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(text: "Resend",recognizer: TapGestureRecognizer()
                        ..onTap = () => getotp(),style: TextStyle(decoration: TextDecoration.underline,color: Colors.blue)),
                    ])),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getotp() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(urlSms),
        body: {
          "name":prefs.getString('name'),
          "phone" : prefs.getString('phone'),
        });
    final body = json.decode(response.body);
    if(body['status'] == 200){
      print(response.body);
      if (body['otp'] != null) {
        otpValue = body['otp'];
      }
      Fluttertoast.showToast(msg: body['message']);
    }else{
      print(response.body);
      Fluttertoast.showToast(msg: body['message']);
    }
  }

  void showLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        dialogContext = context;
        return Dialog(
          backgroundColor: Colors.transparent,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              new CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }
}

import 'dart:convert';

import 'package:call_look/ResetPassword.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VerifyForgetOtp extends StatefulWidget {
  const VerifyForgetOtp({Key key}) : super(key: key);

  @override
  _VerifyForgetOtpState createState() => _VerifyForgetOtpState();
}

class _VerifyForgetOtpState extends State<VerifyForgetOtp> {
  final urlVerifyOtp = "https://www.calllook.com/api/verifyotp.php";
  TextEditingController otp;
  final _formKey = GlobalKey<FormState>();
  String otpValue;
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
                        Fluttertoast.showToast(msg: 'Otp Verified');
                        deleteotp();
                        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => ResetPassword()));
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
                            ..onTap = ()async{
                            showLoading();
                              final prefs = await SharedPreferences.getInstance();
                              final response = await http.post(Uri.parse(urlVerifyOtp),
                                  body: {
                                    "phone": prefs.getString('phone'),
                                  });
                              final body = json.decode(response.body);
                              if (body['status'] == 200) {
                                Navigator.pop(dialogContext);
                                Fluttertoast.showToast(msg: body['message']);
                                setState(() {
                                  otpValue = body['otp'];
                                });
                                print(body);
                              } else {
                                Navigator.pop(dialogContext);
                                Fluttertoast.showToast(msg: body['message']);
                                print(body);
                              }
                            },style: TextStyle(decoration: TextDecoration.underline,color: Colors.blue)),
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
  void getotp() async{
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString('otp')!= null) {
      otpValue = prefs.getString('otp');
      print(otpValue);
    }
  }

  void deleteotp() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getString('otp')!= null) {
      prefs.remove('otp');
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

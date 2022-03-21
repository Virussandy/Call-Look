import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'VerifyForgetOtp.dart';

class Forget extends StatefulWidget {
  @override
  _ForgetState createState() => _ForgetState();
}

class _ForgetState extends State<Forget> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController phone;
  final urlVerifyOtp = "https://www.calllook.com/api/verifyotp.php";
  BuildContext dialogContext;

  @override
  void initState() {
    phone = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(title: Text('Forget Password'),),
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
                  Lottie.asset('image/forget.json'),
                  SizedBox(height: 15,),
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
                      hintText: 'Enter Registered Mobile No',
                      label: Text('Phone'),
                    ),
                  ),
                  SizedBox(height: 15,),
                  MaterialButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        showLoading();
                        final response = await http.post(Uri.parse(urlVerifyOtp),
                            body: {
                              "phone": phone.text.toString(),
                            });
                        final body = json.decode(response.body);
                        if (body['status'] == 200) {
                          Navigator.pop(dialogContext);
                          Fluttertoast.showToast(msg: body['message']);
                          setotp(body['otp'],phone.text.toString());
                          print(body);
                        } else {
                          Navigator.pop(dialogContext);
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
                          'Next', style: TextStyle(fontSize: 20, color: Colors
                            .white), textScaleFactor: 1.0,)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void setotp(otp, String phone) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('otp', otp);
    prefs.setString('phone', phone);
    print(otp);
    Navigator.pushReplacement(context,
        new MaterialPageRoute(builder: (context) => VerifyForgetOtp()));
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

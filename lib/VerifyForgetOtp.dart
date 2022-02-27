import 'package:call_look/ResetPassword.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyForgetOtp extends StatefulWidget {
  const VerifyForgetOtp({Key key}) : super(key: key);

  @override
  _VerifyForgetOtpState createState() => _VerifyForgetOtpState();
}

class _VerifyForgetOtpState extends State<VerifyForgetOtp> {
  TextEditingController otp;
  final _formKey = GlobalKey<FormState>();
  String otpValue;

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
}

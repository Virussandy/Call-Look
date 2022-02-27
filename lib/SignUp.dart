import 'dart:convert';
import 'package:call_look/verifyOtp.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget{
  const SignUp({Key key}) : super(key: key);
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController email,name,password,phone;
  final urlVerifyNumber = "https://familybaskets.co.in/api/verifyotp.php";
  final urlOtp = "https://familybaskets.co.in/api/sms.php";

  @override
  void initState() {
    email = TextEditingController();
    name = TextEditingController();
    phone = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(title: Text('SignUp'),),
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
                  SizedBox(height: 15,),
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
                      hintText: 'Enter Mobile No',
                      label: Text('Phone'),
                    ),
                  ),


                  // SizedBox(height: 15,),
                  // TextFormField(
                  //   validator: (text) {
                  //     if (text == null || text.isEmpty) {
                  //       return 'Text is empty';
                  //     }
                  //     return null;
                  //   },
                  //   controller: email,
                  //   keyboardType: TextInputType.text,
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     hintText: 'Enter Email',
                  //     label: Text('Email'),
                  //   ),
                  // ),


                  SizedBox(height: 15,),
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
                  SizedBox(height: 15,),
                  MaterialButton(onPressed: ()async{
                    if(_formKey.currentState.validate()){
                      final response = await http.post(Uri.parse(urlVerifyNumber),
                          body: {
                            "phone" : phone.text.toString(),
                          });
                      final body = json.decode(response.body);
                      if(body['status'] == 200){
                        Fluttertoast.showToast(msg: body['message']);
                        print(body);
                      }else if(body['status'] == 404){
                        generateOtp();
                        print(body);
                      }
                    }
                  },
                    minWidth: double.maxFinite,
                    color: Colors.lightGreen,
                    shape: RoundedRectangleBorder(),
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                        child: Text('SignIn',style: TextStyle(fontSize: 20,color: Colors.white),textScaleFactor: 1.0,)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void generateOtp() async {
    final prefs = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(urlOtp),
        body: {
          "name": name.text.toString(),
          "number" : phone.text.toString()
        });
    final body = json.decode(response.body);
    if(body['status'] == 200){
      prefs.setString('otp', body['otp']);
      prefs.setString('name', name.text);
      prefs.setString('phone', phone.text);
      prefs.setString('password', password.text);
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (context) => verifyOtp(),));
      Fluttertoast.showToast(msg: body['message']);
      print(body);
    }else if(body['status'] == 404){
      Fluttertoast.showToast(msg: body['message']);
      print(body);
    }
  }
}
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key key}) : super(key: key);

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController password,confirmPassword;
  String _phone;
  final urlupdatePassword = "https://familybaskets.co.in/api/updatepass.php";

  @override
  void initState() {
    password = TextEditingController();
    confirmPassword = TextEditingController();
    getPhone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[100],
      appBar: AppBar(title: Text('Reset Password'),),
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
                  Lottie.asset('image/reset.json'),
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
                      hintText: 'Password',
                      label: Text('Password'),
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
                    controller: confirmPassword,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Confirm Password',
                      label: Text('Confirm Password'),
                    ),
                  ),
                  SizedBox(height: 15,),
                  MaterialButton(onPressed: ()async{

                    if(_formKey.currentState.validate()){
                      if(password.text == confirmPassword.text){
                        final response = await http.post(Uri.parse(urlupdatePassword),
                            body: {
                          'phone' : _phone,
                              'password' : password.text.toString()
                            });
                        final body = json.decode(response.body);
                        if(body['status'] == 200){
                          Fluttertoast.showToast(msg: body['message']);
                          print(body);
                          Navigator.pop(context);
                        }else{
                          Fluttertoast.showToast(msg: body['message']);
                          print(body);
                        }
                      }else{
                        Fluttertoast.showToast(msg: 'password do not match');
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

  void getPhone() async {
    final prefs = await SharedPreferences.getInstance();
    _phone = prefs.getString('phone');
  }
}

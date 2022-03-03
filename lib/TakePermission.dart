import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Dashboard.dart';
import 'PermissionClass.dart';
import 'package:http/http.dart' as http;

class TakePermission extends StatefulWidget {
  // const Permission({Key key}) : super(key: key);
  @override
  TakePermissionState createState() => TakePermissionState();
}

class TakePermissionState extends State<TakePermission> {
  Color phoneColor, contactColor;
  PermissionClass permissionClass = new PermissionClass();
  final url_statusCheck = "https://familybaskets.co.in/api/statusCheck.php";
  final url_deleteolddata = "https://familybaskets.co.in/api/deleteolddata.php";
  final url_login = "https://familybaskets.co.in/api/login.php";

  @override
  void initState() {
    pageNavigation();
    phoneColorfunction();
    contactColorfunction();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => Scaffold(
        backgroundColor: Colors.green[100],
        appBar: AppBar(
          title: Text('Permissions'),
        ),
        body: Align(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Lottie.asset(
                    'image/permission.json',
                  ),
                ),
                SizedBox(
                  height: 30.h,
                ),
                Card(
                  margin: EdgeInsets.all(10.0),
                  color: Colors.transparent,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 15.h,
                      ),
                      ListTile(
                        leading:
                        Icon(
                          Icons.call,
                          size: 35.r,
                          color: Colors.white,
                        ),
                        trailing: IconButton(
                          iconSize: 25.r,
                          onPressed: ()async{
                            bool value =  await permissionClass.checkPermission(Permission.phone);
                            if(value){
                              setState(() {
                                phoneColor = Colors.green;
                                Fluttertoast.showToast(msg: 'Call logs permission Allowed');
                              });
                            }else{
                              if(await Permission.phone.status.isPermanentlyDenied || await Permission.phone.status.isRestricted || await Permission.phone.status.isDenied){
                                setState(() async {
                                  // phoneColor = Colors.red;
                                  // Fluttertoast.showToast(msg: 'Please Allow Call logs Permission');
                                  openAppSettings();
                                });
                              }
                            }
                          },
                          icon: Icon(
                            Icons.circle,
                            color: phoneColor,
                          ),
                        ),
                        title: Text(
                          'Call logs',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Call Look needs permission to make and manage phone calls and read your call logs.',
                          style: TextStyle(fontSize: 15.sp),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Divider(
                        color: Colors.black26,
                        thickness: 1.0.h,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      ListTile(
                        leading:
                        Icon(
                          Icons.contacts,
                          size: 35.r,
                          color: Colors.white,
                        ),
                        trailing: IconButton(
                          iconSize: 25.r,
                          onPressed: ()async{
                            bool value = await permissionClass.checkPermission(Permission.contacts);
                            if(value){
                              setState(() {
                                contactColor = Colors.green;
                                Fluttertoast.showToast(msg: 'Contacts permission allowed');
                              });
                            }else{
                              if(await Permission.contacts.status.isPermanentlyDenied || await Permission.contacts.status.isRestricted || await Permission.contacts.status.isDenied){
                                setState(()  {
                                  // contactColor = Colors.red;
                                  // Fluttertoast.showToast(msg: 'Please allow contacts permission');
                                  openAppSettings();
                                });
                              }
                            }
                          },
                          icon: Icon(
                            Icons.circle,
                            color: contactColor,
                          ),
                        ),
                        title: Text(
                          'Contacts',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Call Look needs permission to read your contacts.',
                          style: TextStyle(fontSize: 15.sp),
                        ),
                      ),
                      SizedBox(
                        height: 15.h,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: MaterialButton(
                    minWidth: double.infinity,
                    color: Colors.lightGreen,
                    onPressed: ()async{
                      if(await permissionClass.pageNavigation()){
                        pageNavigation();
                        // statuscheck();
                      }else if((!await permissionClass.checkPermission(Permission.phone))&&(! await permissionClass.checkPermission(Permission.contacts))){
                        Fluttertoast.showToast(msg: 'Please allow all Permissions');
                      } else if(!await permissionClass.checkPermission(Permission.phone)){
                        Fluttertoast.showToast(msg: 'Please allow Call logs Permission');
                      }else if(! await permissionClass.checkPermission(Permission.contacts)){
                        Fluttertoast.showToast(msg: 'Please allow Contacts Permission');
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 12, 0, 12),
                      child: Text(
                        'Next',
                        style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50.h,)
              ],
            ),
          ),
        )
      ),
      designSize:  Size(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height),
    );
  }

  void pageNavigation() async{
      if(await permissionClass.pageNavigation()){
        statuscheck();
        // Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => Dashboard()));
      }else {
        await permissionClass.checkPermission(Permission.phone);
        await permissionClass.checkPermission(Permission.contacts);
      }
  }

  void phoneColorfunction() async {
      MaterialColor phone = await permissionClass.checkphoneColor();
    setState(() {
      phoneColor = phone;
    });
  }

  void contactColorfunction()async {
    MaterialColor contact = await permissionClass.checkcontactColor();
    setState(() {
      contactColor = contact;
    });
  }

  void statuscheck() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('login')==null)
      {
        final response = await http.post(Uri.parse(url_login),
            body: {
              "action" : "register",
              // "email": email.text.toString(),
              "name" : "0",
              "password" : "0",
              "phone" : "0",
              "deviceid" : prefs.getString('deviceid')
            });
        print(response.body);
      }
    final response = await http.post(Uri.parse(url_statusCheck),
        body: {
          "deviceid" : prefs.getString('deviceid')
        });
    final body = json.decode(response.body);
    if(body['status'] == 200){
      print(body);
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => Dashboard()));
    }else if(body['status'] == 404){
      print(body);
      // delete(prefs.getString('deviceid'));
      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => Dashboard()));
    }
  }

  Future<void> delete(String string) async {
    final response = await http.post(Uri.parse(url_deleteolddata),
        body: {
          "deviceid" : string
        });
    print(response.body);
  }
}

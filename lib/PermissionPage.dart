import 'dart:io';

import 'package:call_look/PermissionClass.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'Dashboard.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({Key key}) : super(key: key);

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {

  PermissionClass permissionClass = new PermissionClass();

  @override
  void initState() {
    askPermission();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Permission'),
      ),
      backgroundColor: Colors.green[100],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Grant Permissions',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
                  Lottie.asset('image/permission.json'),
                  SizedBox(height: 20,),
                  ListTile(
                    title: Text('Enable Calllogs',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Please provide us access to your calllog, which is required for Augmented Reality',textAlign: TextAlign.center,),
                    ),
                  ),
                  SizedBox(height: 20,),
                  ListTile(
                    title: Text('Enable Contacts',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center,),
                    subtitle: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Please provide us access to your contact, which is required for Augmented Reality',textAlign: TextAlign.center,),
                    ),
                  ),
                  SizedBox(height: 20,),
                  MaterialButton(onPressed: (){
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Dashboard()));
                  },
                    color: Colors.green,
                    minWidth: double.maxFinite,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text("Next",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.white),),
                  ),)
                ],
              ),
            ),
          )
        ),
      )
    );
  }

  void askPermission() async {
    Future<bool> allow = permissionClass.isgranted();
    if(!await allow){
      Alert(
        onWillPopActive: true,
        context: context,
        useRootNavigator: false,
        style: const AlertStyle(
          isCloseButton: false,
          isOverlayTapDismiss: false,
        ),
        type: AlertType.error,
        title: "Permission",
        desc: "Please grant permissions to use the application",
        buttons: [
          DialogButton(
              color: Colors.red,
              child: const Text(
                "Close",
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              onPressed: () async {
                Future<bool> recheck = permissionClass.pageNavigation();
                if(await recheck){
                  Navigator.pop(context);
                  // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Dashboard()));
                }
                if(!await recheck){
                  exit(0);
                }
              }
          ),
          DialogButton(
            child: const Text(
              "Setting",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => openAppSettings(),
          )
        ],
      ).show();
    }
  }
}

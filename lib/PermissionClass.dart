

import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionClass {
  MaterialColor phoneColor, contactColor;
  Icon phoneIcon, contactIcon;

  // PermissionClass(this.phoneColor,this.contactColor);

  Future<bool> pageNavigation() async {
    if ((await Permission.phone.status.isGranted && await Permission.contacts.status.isGranted) || (await Permission.phone.status.isLimited && await Permission.contacts.status.isLimited)) {
      return true;
    } else {
      return false;
    }
  }
  Future<MaterialColor> checkphoneColor()async{
    if(await Permission.phone.status.isGranted || await Permission.phone.status.isLimited){
      phoneColor = Colors.green;
    }
    // else{
    //   phoneColor = Colors.red;
    // }
    return phoneColor;
  }

  Future<MaterialColor> checkcontactColor()async{
    if(await Permission.contacts.status.isGranted || await Permission.contacts.status.isLimited){
      contactColor = Colors.green;
    }
    // else{
    //   contactColor = Colors.red;
    // }
    return contactColor;
  }

  Future<bool> checkPermission(Permission permission) async {
    final result = await permission.request();
    switch (result) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return true;
      case PermissionStatus.denied:
      case PermissionStatus.restricted:
      case PermissionStatus.permanentlyDenied:
        return false;
    }
  }
}

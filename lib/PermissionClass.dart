import 'package:call_look/UploadData.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PermissionClass {
  final url_login = "https://www.calllook.com/api/login.php";

  UploadData uploadData = new UploadData();

  Future<bool> pageNavigation() async {
    if ((await Permission.phone.status.isGranted && await Permission.contacts.status.isGranted) || (await Permission.phone.status.isLimited && await Permission.contacts.status.isLimited)) {
      statuscheck();
      return true;
    }
    else {
      return false;
    }
  }

  Future<bool> isgranted()async{
    if((await checkPermission(Permission.phone))&&(await checkPermission(Permission.contacts))){
      return true;
    }
    else{
      return false;
    }
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

  void statuscheck() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.getBool('login')==null)
    {
      final response = await http.post(Uri.parse(url_login),
          body: {
            "action" : "register",
            "name" : "0",
            "password" : "0",
            "phone" : "0",
            "deviceid" : prefs.getString('deviceid')
          });
      print(response.body);
    }
    uploadData.getuserid();
  }
}

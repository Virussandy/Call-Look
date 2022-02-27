import 'package:call_log/call_log.dart';
import 'package:call_look/CallCode.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_dialpad/flutter_dialpad.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class CallLogs extends StatefulWidget {
  CallLogsState createState() => CallLogsState();
}

class CallLogsState extends State<CallLogs> with WidgetsBindingObserver {
  final url = "https://familybaskets.co.in/api/calllog.php";
  CallCode callCode = new CallCode();
  AppLifecycleState _notification;
  Future<Iterable<CallLogEntry>> logs;
  TextEditingController _textController;
  var name, phone, calltype, callingtime, duration, userid;

  @override
  void initState() {
    super.initState();
    checkuserid();
    _textController = TextEditingController();
    WidgetsBinding.instance.addObserver(this);
    logs = callCode.getCallLogs();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (AppLifecycleState.resumed == state) {
      setState(() {
        logs = callCode.getCallLogs();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.lightGreen[100],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialer(context, _textController);
        },
        child: Icon(Icons.dialpad),
        elevation: 5.0,
      ),
      // appBar: AppBar(
      //   title: Text('Call Logs'),
      // ),
      body: Column(
        children: [
          FutureBuilder(
              future: logs,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Iterable<CallLogEntry> entries = snapshot.data;
                  return Expanded(
                      child: ListView.builder(
                    itemBuilder: (context, index) {
                      _checkuserid(entries, index);
                      return GestureDetector(
                        child: Card(semanticContainer: true,
                          elevation: 1.0,
                          child: ListTile(
                            leading: callCode
                                .getAvator(entries.elementAt(index).callType),
                            title: callCode.getTitle(entries.elementAt(index)),
                            subtitle: Text(callCode.formatdate(
                                    new DateTime.fromMillisecondsSinceEpoch(
                                        entries.elementAt(index).timestamp)) +
                                "\n" +
                                callCode.printDuration(
                                    entries.elementAt(index).duration)),
                            isThreeLine: true,
                            trailing: IconButton(
                              icon: Icon(Icons.phone),
                              color: Colors.green,
                              onPressed: () {
                                _callNumber(entries.elementAt(index).number);
                              },
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: entries.length,
                  ));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              })
        ],
      ),
    );
  }

  void checkuserid() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.get('userid') != null) {
      userid = prefs.getString('userid');
    }
  }

  void uploaddata() async {
    final response = await http.post(Uri.parse(url), body: {
      "name": name,
      "phone": phone,
      "calltype": calltype,
      "callingtime": callingtime,
      "duration": duration,
      "userid": userid
    });

    print(response.body);
  }

  _checkuserid(Iterable<CallLogEntry> entries, int index) {
    name = callCode.getName(entries.elementAt(index));
    phone = entries.elementAt(index).number;
    calltype = callCode.calltypes(entries.elementAt(index).callType);
    callingtime = callCode.formatdate(new DateTime.fromMillisecondsSinceEpoch(
        entries.elementAt(index).timestamp));
    duration = callCode.printDuration(entries.elementAt(index).duration);
    print(name);
    print(phone);
    print(calltype);
    print(callingtime);
    print(duration);
    print(userid);
    uploaddata();
  }
}

void _showDialer(context, TextEditingController textController) {
  _insertText(String textToInsert) {
    if (textController.selection.start >= 0) {
      int newPosition = textController.selection.start + textToInsert.length;
      textController.text = textController.text.replaceRange(
        textController.selection.start,
        textController.selection.end,
        textToInsert,
      );
      textController.selection = TextSelection(
        baseOffset: newPosition,
        extentOffset: newPosition,
      );
    } else {
      textController.text += textToInsert;
    }
  }

  showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        textController.clear();
        return Container(
            height: MediaQuery.of(context).size.height * .80,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    style: TextStyle(fontSize: 30),
                    controller: textController,
                    textAlign: TextAlign.center,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () => _insertText('1'),
                        radius: 0,
                        child: CircleAvatar(
                            radius: 33,
                            backgroundColor: Colors.lightGreen[100],
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    '1',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 40),
                                  ),
                                  Icon(
                                    Icons.voicemail,
                                    size: 15,
                                  ),
                                ],
                              ),
                            )),
                      ),
                      InkWell(
                        radius: 0,
                        onTap: () => _insertText('2'),
                        child: CircleAvatar(
                            radius: 33,
                            backgroundColor: Colors.lightGreen[100],
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    '2',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 40),
                                  ),
                                  Text(
                                    'ABC',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                ],
                              ),
                            )),
                      ),
                      InkWell(
                        radius: 0,
                        onTap: () => _insertText('3'),
                        child: CircleAvatar(
                            radius: 33,
                            backgroundColor: Colors.lightGreen[100],
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    '3',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 40),
                                  ),
                                  Text(
                                    'DEF',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        radius: 0,
                        onTap: () => _insertText('4'),
                        child: CircleAvatar(
                            radius: 33,
                            backgroundColor: Colors.lightGreen[100],
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    '4',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 40),
                                  ),
                                  Text(
                                    'GHI',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                ],
                              ),
                            )),
                      ),
                      InkWell(
                        radius: 0,
                        onTap: () => _insertText('5'),
                        child: CircleAvatar(
                            radius: 33,
                            backgroundColor: Colors.lightGreen[100],
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    '5',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 40),
                                  ),
                                  Text(
                                    'JKL',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                ],
                              ),
                            )),
                      ),
                      InkWell(
                        radius: 0,
                        onTap: () => _insertText('6'),
                        child: CircleAvatar(
                            radius: 33,
                            backgroundColor: Colors.lightGreen[100],
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    '6',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 40),
                                  ),
                                  Text(
                                    'MNO',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        radius: 0,
                        onTap: () => _insertText('7'),
                        child: CircleAvatar(
                            radius: 33,
                            backgroundColor: Colors.lightGreen[100],
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    '7',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 40),
                                  ),
                                  Text(
                                    'PQRS',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                ],
                              ),
                            )),
                      ),
                      InkWell(
                        radius: 0,
                        onTap: () => _insertText('8'),
                        child: CircleAvatar(
                            radius: 33,
                            backgroundColor: Colors.lightGreen[100],
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    '8',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 40),
                                  ),
                                  Text(
                                    'TUV',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                ],
                              ),
                            )),
                      ),
                      InkWell(
                        radius: 0,
                        onTap: () => _insertText('9'),
                        child: CircleAvatar(
                            radius: 33,
                            backgroundColor: Colors.lightGreen[100],
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    '9',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 40),
                                  ),
                                  Text(
                                    'WXYZ',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        radius: 0,
                        onTap: () => _insertText('*'),
                        child: CircleAvatar(
                            radius: 33,
                            backgroundColor: Colors.lightGreen[100],
                            child: Center(
                                child: Text(
                              '*',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 40),
                            ))),
                      ),
                      InkWell(
                        radius: 0,
                        onTap: () => _insertText('0'),
                        onLongPress: () => _insertText('+'),
                        child: CircleAvatar(
                            radius: 33,
                            backgroundColor: Colors.lightGreen[100],
                            child: Center(
                              child: Column(
                                children: [
                                  Text(
                                    '0',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 40),
                                  ),
                                  Text(
                                    '+',
                                    style: TextStyle(
                                        color: Colors.black, fontSize: 10),
                                  ),
                                ],
                              ),
                            )),
                      ),
                      InkWell(
                        radius: 0,
                        onTap: () => _insertText('#'),
                        child: CircleAvatar(
                            radius: 33,
                            backgroundColor: Colors.lightGreen[100],
                            child: Center(
                                child: Text(
                              '#',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 40),
                            ))),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        radius: 0,
                        onTap: () {
                          if (textController.text.length > 0) {
                            goToWhatsapp(textController.text.length > 10
                                ? textController.text
                                : '+91' + textController.text);
                          }
                        },
                        child: CircleAvatar(
                            radius: 33,
                            backgroundColor: Colors.lightGreen[100],
                            child: Center(
                                child: Icon(
                              MaterialCommunityIcons.whatsapp,
                              color: Colors.black,
                            ))),
                      ),
                      InkWell(
                        radius: 0,
                        onTap: () => {
                          if (textController.text.length > 0)
                            {_callNumber(textController.text)}
                        },
                        child: CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.lightGreen[100],
                            child: Center(
                                child: Center(
                                    child: Icon(
                              Icons.phone,
                              size: 40,
                            )))),
                      ),
                      InkWell(
                        radius: 0,
                        onTap: () {
                          textController.text = (textController.text
                              .substring(0, (textController.text.length - 1)));
                        },
                        onLongPress: () => textController.clear(),
                        child: CircleAvatar(
                            radius: 33,
                            backgroundColor: Colors.lightGreen[100],
                            child: Center(
                                child: Icon(
                              Icons.backspace_outlined,
                              color: Colors.black,
                            ))),
                      ),
                    ],
                  ),
                ],
              ),
            ));
      });
}

Future<void> goToWhatsapp(String value) async {
  var whatsapp = "$value";
  var whatsappUrl = "whatsapp://send?phone=" + whatsapp;
  await canLaunch(whatsappUrl)
      ? launch(whatsappUrl)
      : print(
          "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
}

Future<void> _callNumber(String number) async {
  print(number);
  await FlutterPhoneDirectCaller.callNumber(number);
}

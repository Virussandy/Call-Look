import 'dart:ui';
import 'package:call_log/call_log.dart';
import 'package:call_look/CallCode.dart';
import 'package:flutter/material.dart';
import 'package:move_to_background/move_to_background.dart';
// import 'package:flutter_dialpad/flutter_dialpad.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class CallLogs extends StatefulWidget {
  CallLogsState createState() => CallLogsState();
}

class CallLogsState extends State<CallLogs> with WidgetsBindingObserver {

  CallCode callCode = new CallCode();
  Future<Iterable<CallLogEntry>> logs;
  List<CallLogs> calllogs = [];
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
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
    // if (AppLifecycleState.resumed == state) {
    //   setState(() {
    //     logs = callCode.getCallLogs();
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        MoveToBackground.moveTaskToBack();
        return false;
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showDialer(context, _textController);
          },
          child: Icon(Icons.dialpad),
          elevation: 5.0,
        ),
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
                            return GestureDetector(
                              child: Card(semanticContainer: true,
                                elevation: 1.0,
                                child: ListTile(
                                  leading: callCode
                                      .getAvator(entries
                                      .elementAt(index)
                                      .callType),
                                  title: callCode.getTitle(
                                      entries.elementAt(index)),
                                  subtitle: Text(callCode.formatdate(
                                      new DateTime.fromMillisecondsSinceEpoch(
                                          entries
                                              .elementAt(index)
                                              .timestamp)) +
                                      "\n" +
                                      callCode.printDuration(
                                          entries
                                              .elementAt(index)
                                              .duration)),
                                  isThreeLine: true,
                                  trailing: IconButton(
                                    icon: Icon(Icons.phone),
                                    color: Colors.green,
                                    onPressed: () {
                                      _callNumber(entries
                                          .elementAt(index)
                                          .number);
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
      ),
    );
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
    isScrollControlled: true,
      context: context,
      builder: (BuildContext bc) {
        textController.clear();
        return ScreenUtilInit(
          builder: () => Container(
            height: 450.h,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      style: TextStyle(fontSize: 30.sp,fontWeight: FontWeight.w500),
                      controller: textController,
                      textAlign: TextAlign.center,
                      readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          onTap: () => _insertText('1'),
                          radius: 0.r,
                          child: CircleAvatar(
                              radius: 25.r,
                              backgroundColor: Colors.lightGreen[100],
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      '1',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 30.sp,fontWeight: FontWeight.w500),
                                    ),
                                    Icon(
                                      Icons.voicemail,
                                      size: 10.r,
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        InkWell(
                          radius: 0.r,
                          onTap: () => _insertText('2'),
                          child: CircleAvatar(
                              radius: 25.r,
                              backgroundColor: Colors.lightGreen[100],
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      '2',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 30.sp,fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'ABC',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 8.sp),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        InkWell(
                          radius: 0.r,
                          onTap: () => _insertText('3'),
                          child: CircleAvatar(
                              radius: 25.r,
                              backgroundColor: Colors.lightGreen[100],
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      '3',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 30.sp,fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'DEF',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 8.sp),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          radius: 0.r,
                          onTap: () => _insertText('4'),
                          child: CircleAvatar(
                              radius: 25.r,
                              backgroundColor: Colors.lightGreen[100],
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      '4',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 30.sp,fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'GHI',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 8.sp),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        InkWell(
                          radius: 0.r,
                          onTap: () => _insertText('5'),
                          child: CircleAvatar(
                              radius: 25.r,
                              backgroundColor: Colors.lightGreen[100],
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      '5',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 30.sp,fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'JKL',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 8.sp),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        InkWell(
                          radius: 0.r,
                          onTap: () => _insertText('6'),
                          child: CircleAvatar(
                              radius: 25.r,
                              backgroundColor: Colors.lightGreen[100],
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      '6',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 30.sp,fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'MNO',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 8.sp),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          radius: 0.r,
                          onTap: () => _insertText('7'),
                          child: CircleAvatar(
                              radius: 25.r,
                              backgroundColor: Colors.lightGreen[100],
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      '7',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 30.sp,fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'PQRS',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 8.sp),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        InkWell(
                          radius: 0.r,
                          onTap: () => _insertText('8'),
                          child: CircleAvatar(
                              radius: 25.r,
                              backgroundColor: Colors.lightGreen[100],
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      '8',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 30.sp,fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'TUV',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 8.sp),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        InkWell(
                          radius: 0.r,
                          onTap: () => _insertText('9'),
                          child: CircleAvatar(
                              radius: 25.r,
                              backgroundColor: Colors.lightGreen[100],
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      '9',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 30.sp,fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      'WXYZ',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 8.sp),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          radius: 0.r,
                          onTap: () => _insertText('*'),
                          child: CircleAvatar(
                              radius: 25.r,
                              backgroundColor: Colors.lightGreen[100],
                              child: Center(
                                  child: Text(
                                '*',
                                style:
                                    TextStyle(color: Colors.black, fontSize: 30.sp,fontWeight: FontWeight.w500),
                              ))),
                        ),
                        InkWell(
                          radius: 0.r,
                          onTap: () => _insertText('0'),
                          onLongPress: () => _insertText('+'),
                          child: CircleAvatar(
                              radius: 25.r,
                              backgroundColor: Colors.lightGreen[100],
                              child: Center(
                                child: Column(
                                  children: [
                                    Text(
                                      '0',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 30.sp,fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      '+',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 12.sp),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                        InkWell(
                          radius: 0.r,
                          onTap: () => _insertText('#'),
                          child: CircleAvatar(
                              radius: 25.r,
                              backgroundColor: Colors.lightGreen[100],
                              child: Center(
                                  child: Text(
                                '#',
                                style:
                                    TextStyle(color: Colors.black, fontSize: 30.sp,fontWeight: FontWeight.w500),
                              ))),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          radius: 0.r,
                          onTap: () {
                            if (textController.text.length > 0) {
                              goToWhatsapp(textController.text.length > 10
                                  ? textController.text
                                  : '+91' + textController.text);
                            }
                          },
                          child: CircleAvatar(
                              radius: 28.r,
                              backgroundColor: Colors.lightGreen[100],
                              child: Center(
                                  child: Icon(
                                MaterialCommunityIcons.whatsapp,
                                color: Colors.black,
                                    size: 25.r,
                              ))),
                        ),
                        InkWell(
                          radius: 0.r,
                          onTap: () => {
                            if (textController.text.length > 0)
                              {_callNumber(textController.text)}
                          },
                          child: CircleAvatar(
                              radius: 35.r,
                              backgroundColor: Colors.lightGreen[100],
                              child: Center(
                                  child: Center(
                                      child: Icon(
                                Icons.phone,
                                size: 35.r,
                              )))),
                        ),
                        InkWell(
                          radius: 0.r,
                          onTap: () {
                            textController.text = (textController.text
                                .substring(0, (textController.text.length - 1)));
                          },
                          onLongPress: () => textController.clear(),
                          child: CircleAvatar(
                              radius: 28.r,
                              backgroundColor: Colors.lightGreen[100],
                              child: Center(
                                  child: Icon(
                                Icons.backspace_outlined,
                                color: Colors.black,
                                    size: 25.r,
                              ))),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          designSize:  Size(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height),
        );
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

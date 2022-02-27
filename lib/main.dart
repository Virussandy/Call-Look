import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'TakePermission.dart';
import 'package:device_info_plus/device_info_plus.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) {
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
      debugShowCheckedModeBanner: false,
      title: 'Call Look',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        // buttonTheme: ButtonThemeData(
        //   shape: RoundedRectangleBorder(),
        //   buttonColor: Colors.lightGreen,
        //   textTheme: ButtonTextTheme.accent,
        // ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  // MyHomePage({Key key, this.title}) : super(key: key);
  // final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo;

  @override
  void initState(){
    super.initState();
    generateUserid();
    new Future.delayed(
        const Duration(seconds: 3),
            () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TakePermission()),
        ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(200, 230, 201, 1.00),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 100,
                    child: Image.asset('image/call.png'),
                  )
              ),
              SizedBox(height: 20,),
              Text(
                'Call Look',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 150,
              child: Lottie.asset(
                'image/loading.json',
              ),
            ),
          )
        ],
      ),
    );
  }

  void generateUserid() async {
    final prefs = await SharedPreferences.getInstance();
    androidInfo = await deviceInfo.androidInfo;
    prefs.setString('userid', androidInfo.androidId);
    prefs.setString('deviceid', androidInfo.androidId);
  }
}

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'TakePermission.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: MyHomePage(),
        debugShowCheckedModeBanner: false,
      ),
      designSize:  Size(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height),
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
            () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TakePermission()),));
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
                    height: 100.h,
                    child: Image.asset('image/call.png'),
                  )
              ),
              SizedBox(height: 20.h,),
              Text(
                'Call Look',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.normal),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 150.h,
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

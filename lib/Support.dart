import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Support extends StatelessWidget {
  const Support({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Support'),
        ),
        body:Column(
          mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text('Need more help!',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 28),),
                  ),
                  Lottie.asset('image/support.json'),
                  Center(
                    child: Text('Contact us on',style: TextStyle(fontWeight: FontWeight.w500,fontSize: 24,color: Colors.lightBlue),),
                  ),
                  Center(
                    child: Text('support@calllook.com',style: TextStyle(color: Colors.lightBlueAccent),),
                  )
                ],
        ),
      ),
    );
  }
}
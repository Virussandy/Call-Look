import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'CallLogs.dart';
import 'Contacts.dart';
import 'LoginScreen.dart';

class Dashboard extends StatefulWidget{
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard>{

  GlobalKey<ScaffoldState> _key = GlobalKey();
  String _name = "full name",_phone = "phone no",_button = "SignIn";
  // _username = "username"
  int selectedPage = 0;
  final _pageOptions = [
    CallLogs(),
    Contacts()
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     key: _key,
     appBar: AppBar(
       title: Text('Call Look'),
       leading: InkWell(
         onTap: (){
           getNames();

         },
         child: Icon(Icons.menu),
       ),
     ),
       drawer: Drawer(
         child: ListView(
           children: [
             UserAccountsDrawerHeader(
               accountName: Text(_name),
               accountEmail: Text(_phone),
               currentAccountPicture: CircleAvatar(
                 child: ClipOval(
                   child: Image.network(
                     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRJ0tCOel3GeTItNxpqvhsILtxfV8yrbD5yA&usqp=CAU',
                     fit: BoxFit.cover,
                     width: 90,
                     height: 90,
                   ),
                 ),
               ),
               decoration: BoxDecoration(
                 color: Colors.blue,
                 image: DecorationImage(
                     fit: BoxFit.fill,
                     image: NetworkImage('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHFybNTldC8rUBh-yoZnTCvUx1edM8eHjnHw&usqp=CAU')
                 ),
               ),
             ),
             ListTile(
                 leading: Icon(Icons.login),
                 title: Text(_button),
                 onTap: ()async{
                   final prefs = await SharedPreferences.getInstance();
                   if (_button == 'SignOut') {
                     prefs.setBool('login', false);
                     prefs.remove('userid');
                     prefs.remove('name');
                     prefs.remove('username');
                     prefs.remove('phone');
                     setState(() {
                       _phone = 'phone no';
                       _name = 'full name';
                       _button = 'SignIn';
                     });
                     _key.currentState.openEndDrawer();
                     Fluttertoast.showToast(msg: 'SignOut Successfully');
                     // Navigator.pop(context);
                   } else {
                     _key.currentState.openEndDrawer();
                     Navigator.push(
                         context, new MaterialPageRoute(
                         builder: (context) => LoginScreen()));
                   }
                 }
             ),
           ],
         ),
       ),
       backgroundColor: Colors.white,
       body: _pageOptions[selectedPage],
       bottomNavigationBar: BottomNavigationBar(
         items: [
           BottomNavigationBarItem(icon: Icon(Icons.watch_later_outlined, size: 30), label: 'Recent'),
           BottomNavigationBarItem(icon: Icon(Icons.people, size: 30), label: 'Contacts'),
         ],
         selectedItemColor: Colors.green[900],
         elevation: 10.0,
         selectedLabelStyle: TextStyle(fontWeight: FontWeight.w900),
         unselectedItemColor: Colors.green,
         currentIndex: selectedPage,
         backgroundColor: Colors.lightGreen[100],
         onTap: (index){
           setState(() {
             selectedPage = index;
           });
         },
       )
   );
  }

  void getNames() async {
    final prefs = await SharedPreferences.getInstance();
    _key.currentState.openDrawer();
    if(prefs.getBool('login')!= null){
      if (prefs.getBool('login')) {
          setState(() {
            _name = prefs.getString('name');
            _phone = prefs.getString('phone');
            _button = 'SignOut';
          });
      }
    }

    // showModalBottomSheet(backgroundColor: Colors.green[100],
    //     isScrollControlled: true,
    //     context: context,
    //     builder: (BuildContext bc) {
    //       return Container(
    //         height: MediaQuery.of(context).size.height*0.70,
    //         width: MediaQuery.of(context).size.width,
    //         margin: EdgeInsets.all(10),
    //         alignment: Alignment.center,
    //         child: Column(
    //           children: [
    //             CircleAvatar(radius: 50,
    //               backgroundColor: Colors.white,
    //               child: Icon(Icons.person, size: 60, color: Colors.black,),),
    //             SizedBox(height: 20,),
    //             Card(
    //               child: Column(
    //                 children: [
    //                   ListTile(leading: Icon(Icons.person,color: Colors.blue,size: 35,),
    //                     title: Text('Fullname',style: TextStyle(fontWeight: FontWeight.w700),),
    //                     subtitle: Text(_name),),
    //                   ListTile(leading: Icon(Icons.drive_file_rename_outline,color: Colors.red,size: 35,),
    //                     title: Text('Username',style: TextStyle(fontWeight: FontWeight.w700),),
    //                     subtitle: Text(_username),),
    //                   ListTile(leading: Icon(Icons.phone,color: Colors.green,size: 35,),
    //                     title: Text('Phone no',style: TextStyle(fontWeight: FontWeight.w700),),
    //                     subtitle: Text(_phone),),
    //                   SizedBox(height: 20,),
    //                   MaterialButton(onPressed: () {
    //                     if (buttonText == 'SignOut') {
    //                       Navigator.pop(context);
    //                       prefs.setBool('login', false);
    //                       prefs.remove('userid');
    //                       prefs.remove('name');
    //                       prefs.remove('username');
    //                       prefs.remove('phone');
    //                     } else {
    //                       Navigator.pushReplacement(
    //                           context, new MaterialPageRoute(
    //                           builder: (context) => LoginScreen()));
    //                     }
    //                   },
    //                     color: Colors.black,
    //                     child: Text(buttonText,style: TextStyle(color: Colors.white),),
    //                   ),
    //                 ],
    //               ),
    //             )
    //           ],
    //         ),
    //       );
    //     });
  }

}
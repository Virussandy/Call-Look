import 'package:call_look/PermissionClass.dart';
import 'package:call_look/UploadData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'CallLogs.dart';
import 'Contacts.dart';
import 'LoginScreen.dart';
import 'Support.dart';

class Dashboard extends StatefulWidget{
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> with WidgetsBindingObserver{

  GlobalKey<ScaffoldState> _key = GlobalKey();
  String _name = "",_phone = "",_button = "SignIn";
  PermissionClass permissionClass = new PermissionClass();
  UploadData uploadData = new UploadData();
  int selectedPage = 0;
  final _pageOptions = [
    CallLogs(),
    Contacts()
  ];

  @override
  void initState() {
    super.initState();
    checkPermission();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
   return ScreenUtilInit(
     builder: () => Scaffold(
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
           child: Column(
             children: [
               UserAccountsDrawerHeader(
                 accountName: Text(_name),
                 accountEmail: Text(_phone),
                 currentAccountPicture: CircleAvatar(
                   child: ClipOval(
                     child: Image.network(
                       'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRRJ0tCOel3GeTItNxpqvhsILtxfV8yrbD5yA&usqp=CAU',
                       fit: BoxFit.cover,
                       width: 90.h,
                       height: 90.h,
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
               Expanded(
                 child: Column(
                   children: [
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
                               _phone = '';
                               _name = '';
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
                     ListTile(
                       leading: Icon(Icons.support_agent),
                       title: Text('Support'),
                       onTap: (){
                         Navigator.of(context).push(new MaterialPageRoute(builder: (Context) => Support()));
                       },
                     ),
                   ],
                 ),
               ),
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Align(alignment: Alignment.bottomCenter, child: Text('Copyright © CallLook'),
                 ),
           )
             ],
           ),
         ),
         backgroundColor: Colors.white,
         body: _pageOptions[selectedPage],
         bottomNavigationBar: BottomNavigationBar(
           items: [
             BottomNavigationBarItem(icon: Icon(Icons.watch_later_outlined, size: 30.r), label: 'Recent'),
             BottomNavigationBarItem(icon: Icon(Icons.people, size: 30.r), label: 'Contacts'),
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
     ),
     designSize:  Size(MediaQuery.of(context).size.width,MediaQuery.of(context).size.height),
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
  }

  void checkPermission() async {
   permissionClass.pageNavigation();
  }
}
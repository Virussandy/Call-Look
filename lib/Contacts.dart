import 'package:flutter_icons/flutter_icons.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class Contacts extends StatefulWidget {
  ContactsState createState() => ContactsState();
}

class ContactsState extends State<Contacts> with WidgetsBindingObserver{
  List<Contact> contacts = [];
  List<Item> _phones = [];
  

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    getAllContacts();
    super.initState();
  }

  getAllContacts() async {
    List<Contact> _contacts = await ContactsService.getContacts(withThumbnails: false);
    setState(() {
      contacts = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView.builder(
          shrinkWrap: true,
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            Contact contact = contacts[index];
            return Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ListTile(
                  onTap: (){
                    _phones = contact.phones;
                    displayContact(context);
                  },
                  leading: (contact.avatar != null && contact.avatar.length > 0)
                      ? CircleAvatar(
                          backgroundImage: MemoryImage(contact.avatar),radius: 25,
                        )
                      : CircleAvatar(
                          child: Text(contact.initials(),style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),radius: 25,
                        ),
                  title: Text(contact.displayName,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15),),
                ),
              ),
            );
          },
        ),
      );
  }

  void displayContact(BuildContext context) {
    showModalBottomSheet(context: context, builder: (BuildContext bc){
      return ListView.builder(shrinkWrap:true,itemCount:_phones.length ,itemBuilder: (context, index){
        return ListTile(
          leading: Icon(Icons.call,size: 28,color: Colors.green,),
          title: Text(_phones[index].value,style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
          trailing: InkWell(
            onTap: () {
              goToWhatsapp(((_phones[index].value.replaceAll(' ', '').length) > 10)?(_phones[index].value.trim()):("+91"+_phones[index].value));
            },
              child: Icon(MaterialCommunityIcons.whatsapp,size: 30,color: Colors.green[900],)),
        );
      });
    });
  }

 Future<void> goToWhatsapp(String value) async{
   var whatsapp ="$value";
   var whatsappUrl = "whatsapp://send?phone="+whatsapp;
   await canLaunch(whatsappUrl)? launch(whatsappUrl):print("open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
  }
}

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../utils/firebase_data.dart';
import '../../../utils/shared_preferences.dart';
import 'contact_info.dart';

List<ContactInfo> gContactsList = new List<ContactInfo>();

void fGetContactsFromMemory() {
  String contactsJson = gPrefs.getString(gContactsDatabaseKey);
  if (contactsJson != null) {
    gContactsList
        .addAll(json.decode(contactsJson).map<ContactInfo>((contactInfo) {
      return new ContactInfo(
          contactInfo['mId'],
          contactInfo['mName'],
          contactInfo['mDescription'],
          contactInfo['mPhoneNumber'],
          contactInfo['mEmail']);
    }).toList());
  }
}

void fAddContactToList(aContactId, aContactInfo) {
  print("fAddContactToList");
  ContactInfo contactInfo = new ContactInfo(
      fGetDatabaseId(aContactId, 2),
      aContactInfo["name"],
      aContactInfo["description"],
      aContactInfo['phone_number'],
      aContactInfo['email']);
  contactInfo.log();
  gContactsList.add(contactInfo);
}

class ContactWidget extends StatefulWidget {
  @override
  ContactPage createState() => new ContactPage();
}

class ContactPage extends State<ContactWidget> {
  static const String Id = "ContactPage";

  StreamSubscription<bool> mStreamSub;

  @override
  void initState() {
    print("ContactPage:initState");
    super.initState();
    mStreamSub = fGetStream(gContactsDatabaseKey).listen((aContactInfo) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    print("ContactPage:dispose");
    super.dispose();
    mStreamSub.cancel();
    fCloseStream(gContactsDatabaseKey);
  }

  void sortContactList() {
    gContactsList.sort((firstContact, secondContact) {
      if (firstContact.mId > secondContact.mId) {
        return 1;
      } else {
        return -1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("ContactPage:build:gContactsList.length=" +
        gContactsList.length.toString());
    this.sortContactList();
    return new Scaffold(
        body: new ListView.builder(
            itemCount: gContactsList.length,
            padding: const EdgeInsets.all(6.0),
            itemBuilder: (context, index) {
              return new Card(
                  child: new _ContactListItem(gContactsList[index]));
            }));
  }
}

class _ContactListItem extends ListTile {
  _ContactListItem(ContactInfo contactInfo)
      : super(
          leading: new Container(child: new Icon(Icons.person)),
          title: new Container(
              child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              new Text(contactInfo.mName,
                  style: new TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0))
            ],
          )),
          subtitle: new Container(
              child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[new Text(contactInfo.mDescription)],
          )),
          trailing: new Container(
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new IconButton(
                    icon: Icon(Icons.email),
                    onPressed: () => launch("mailto://" + contactInfo.mEmail)),
                new IconButton(
                    icon: Icon(Icons.phone),
                    padding: new EdgeInsets.all(1.0),
                    onPressed: () => launch("tel://" + contactInfo.mPhoneNumber))
              ],
            ),
          ),
        );
}
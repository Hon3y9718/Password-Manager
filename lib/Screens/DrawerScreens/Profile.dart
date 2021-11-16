import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:passmanager/Screens/DrawerScreens/YourData.dart';
import 'package:passmanager/Screens/Redirector.dart';
import 'package:passmanager/Screens/SignIn.dart';
import 'package:passmanager/api/DatabaseFunc.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key, required this.auth}) : super(key: key);
  final auth;

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser!;
  Account account = Account();
  popUpNoAuthSet(context) {
    Alert(
        context: context,
        content: Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 30),
          child: Text('Are you sure?'),
        ),
        style: AlertStyle(isCloseButton: false),
        buttons: [
          DialogButton(
            color: Colors.red,
            onPressed: () {
              account.LogOut();
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignIn(auth: widget.auth)));
            },
            child: Text('Yes',
                style: TextStyle(
                    fontFamily: 'Glory',
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('No',
                style: TextStyle(
                    fontFamily: 'Glory',
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    DatabaseFunc db = DatabaseFunc();
    Sync sync = Sync();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.angleLeft,
            size: 25,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 90,
              backgroundImage: NetworkImage(user.photoURL.toString()),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              '${user.displayName}',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).accentColor),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              '${user.email}',
              style: TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(
              height: 10,
            ),
            Divider(
              color: Colors.grey,
            ),
            Column(
              children: [
                ListTile(
                  title: Text(
                    'Local Passwords',
                    style: TextStyle(fontSize: 20),
                  ),
                  leading: Icon(Icons.signal_wifi_off_outlined),
                  trailing: FaIcon(
                    FontAwesomeIcons.angleRight,
                    size: 22,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(
                    'Cloud Data',
                    style: TextStyle(fontSize: 20),
                  ),
                  leading: Icon(Icons.wifi),
                  trailing: FaIcon(
                    FontAwesomeIcons.angleRight,
                    size: 22,
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => YourData()));
                  },
                ),
                ListTile(
                  title: Text(
                    'Sync',
                    style: TextStyle(fontSize: 20),
                  ),
                  leading: FaIcon(FontAwesomeIcons.syncAlt),
                  onTap: () async {
                    await db.backupAllPasswords();
                    await sync.syncFromFirestore();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sync Complete!')),
                    );
                  },
                ),
                ListTile(
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationName: 'Password Manager',
                      applicationVersion: 'v1.0.1',
                      applicationLegalese:
                          'Copyright © 2021 Techicious - All Rights Reserved',
                    );
                  },
                  title: Text(
                    'Licenses',
                    style: TextStyle(fontSize: 20),
                  ),
                  leading: Icon(
                    Icons.assignment,
                    size: 25,
                  ),
                ),
                Divider(
                  color: Colors.grey,
                ),
                ListTile(
                  onTap: () {
                    popUpNoAuthSet(context);
                  },
                  title: Text(
                    'Log Out',
                    style: TextStyle(
                        fontSize: 20, color: Theme.of(context).accentColor),
                  ),
                  leading: Icon(Icons.logout,
                      size: 25, color: Theme.of(context).accentColor),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

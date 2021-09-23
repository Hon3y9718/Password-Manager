import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:passmanager/Screens/DrawerScreens/YourData.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.arrowLeft,
            size: 18,
            color: Colors.black,
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
              style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
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
                    FontAwesomeIcons.arrowRight,
                    size: 18,
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
                    FontAwesomeIcons.arrowRight,
                    size: 18,
                  ),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => YourData()));
                  },
                ),
                ListTile(
                  title: Text(
                    'About',
                    style: TextStyle(fontSize: 20),
                  ),
                  leading: FaIcon(FontAwesomeIcons.solidAddressCard),
                ),
                ListTile(
                  title: Text(
                    'Legal',
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
                  title: Text(
                    'Delete My Account',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  leading: Icon(Icons.assignment, size: 25, color: Colors.red),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

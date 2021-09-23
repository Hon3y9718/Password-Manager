import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:passmanager/Screens/Home.dart';
import 'package:passmanager/api/localAuthAPI.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class BioLock extends StatefulWidget {
  const BioLock({Key? key, this.authAPI}) : super(key: key);
  final authAPI;

  @override
  _BioLockState createState() => _BioLockState();
}

class _BioLockState extends State<BioLock> {
  var isAuthenticated = false;
  TextEditingController securtiyKey = TextEditingController();
  var key = 'Yolo';

  AuthenticateFingerprint() async {
    isAuthenticated = await widget.authAPI.authenticate();
    if (isAuthenticated) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
      return;
    }
    popUpNoAuthSet(context);
  }

  popUpNoAuthSet(context) {
    Alert(
        context: context,
        content: Padding(
          padding: const EdgeInsets.only(top: 30, bottom: 30),
          child: Text('Fingerprint Not Set!'),
        ),
        style: AlertStyle(isCloseButton: false),
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Ok',
                style: TextStyle(
                    fontFamily: 'Glory',
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        ]).show();
  }

  @override
  void initState() {
    if (Platform.isAndroid || Platform.isIOS) {
      AuthenticateFingerprint();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Authenticate',
          style: TextStyle(
              color: Colors.black,
              fontFamily: 'Glory',
              fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.fingerprint,
              size: 60,
              color: !isAuthenticated ? Colors.deepOrange : Colors.green,
            ),
            SizedBox(height: 30),
            Text('Click Fingerprint to Authenticate!')
          ],
        ),
      ),
    );
  }
}

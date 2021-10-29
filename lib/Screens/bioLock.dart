import 'dart:io';
import 'package:flutter/material.dart';

import 'package:passmanager/Screens/Home.dart';
import 'package:passmanager/colorPalletes/pallet.dart';

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

  authenticateFingerprint() async {
    isAuthenticated = await widget.authAPI.authenticate();
    if (isAuthenticated) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Home(auth: widget.authAPI)));
      return;
    }
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BioLock(
                            authAPI: widget.authAPI,
                          )));
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
      authenticateFingerprint();
    }
    super.initState();
  }

  // @override
  // void dispose() {
  //   widget.authAPI.dispose();
  //   super.dispose();
  // }

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
            Icon(isAuthenticated ? Icons.check_circle : Icons.fingerprint,
                size: 60, color: Pallete.pallet1),
            SizedBox(height: 30),
            Text('Click Fingerprint to Authenticate!')
          ],
        ),
      ),
    );
  }
}

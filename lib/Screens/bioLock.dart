import 'package:flutter/material.dart';
import 'package:passmanager/Screens/Home.dart';
import 'package:passmanager/api/localAuthAPI.dart';

class BioLock extends StatefulWidget {
  const BioLock({Key? key, this.authAPI}) : super(key: key);
  final authAPI;

  @override
  _BioLockState createState() => _BioLockState();
}

class _BioLockState extends State<BioLock> {
  var isAuthenticated = false;
  AuthenticateFingerprint() async {
    isAuthenticated = await widget.authAPI.authenticate();
    if (isAuthenticated) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Home(title: 'Home')));
    }
  }

  // @override
  // void initState() {
  //   AuthenticateFingerprint();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Authenticate',
          style: TextStyle(color: Colors.green),
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

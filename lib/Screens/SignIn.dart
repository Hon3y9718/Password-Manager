import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:passmanager/Screens/Home.dart';
import 'package:passmanager/Screens/Redirector.dart';
import 'package:passmanager/api/DatabaseFunc.dart';
import 'package:passmanager/api/googleSignInProvider.dart';
import 'package:passmanager/api/localAuthAPI.dart';
import 'package:provider/provider.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key, required this.auth}) : super(key: key);
  final LocalAuthApi auth;
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  var user;

  Future<bool> adduser() async {
    Sync sync = Sync();
    try {
      FirebaseFirestore.instance
          .collection('user')
          .doc(user!.email)
          .get()
          .then((docRef) {
        return {
          if (!docRef.exists)
            {
              FirebaseFirestore.instance
                  .collection('user')
                  .doc(user!.email)
                  .set({
                'Email': user!.email,
                'Name': user!.displayName,
                'ProfileImage': user!.photoURL,
                'uid': user!.uid
              })
            }
          else
            {sync.syncFromFirestore()}
        };
      });
      return true;
    } on Exception catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Hey There, Log In',
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                  minimumSize: Size(80, 50)),
              onPressed: () async {
                final provider =
                    Provider.of<GoogleSignInProvider>(context, listen: false);
                await provider.googleLogin();
                Duration(seconds: 5);
                user = FirebaseAuth.instance.currentUser;
                var isUserAdded = await adduser();
                if (isUserAdded) {
                  Navigator.pop(context);
                }
              },
              label: Text('Sign In with Google'),
              icon: FaIcon(FontAwesomeIcons.google),
            )
          ],
        ),
      ),
    );
  }
}

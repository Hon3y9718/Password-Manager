import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:passmanager/Screens/SignIn.dart';
import 'package:passmanager/Screens/bioLock.dart';
import 'package:passmanager/api/localAuthAPI.dart';

class Redirector extends StatefulWidget {
  const Redirector({Key? key, required this.auth}) : super(key: key);

  final LocalAuthApi auth;

  @override
  _RedirectorState createState() => _RedirectorState();
}

class _RedirectorState extends State<Redirector> {
  final user = FirebaseAuth.instance.currentUser!;

  addUser() async {
    await FirebaseFirestore.instance
        .collection('user')
        .doc(user.email)
        .get()
        .then((docRef) => {
              if (!docRef.exists)
                {
                  FirebaseFirestore.instance
                      .collection('user')
                      .doc(user.email)
                      .set({
                    'Email': user.email,
                    'Name': user.displayName,
                    'ProfileImage': user.photoURL,
                    'uid': user.uid
                  })
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            addUser();
            return BioLock(
              authAPI: widget.auth,
            );
          } else if (snapshot.hasError) {
            return SignIn(auth: widget.auth);
          } else {
            return SignIn(auth: widget.auth);
          }
        },
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/error_codes.dart';
import 'package:passmanager/model/passwordModel.dart';

class YourData extends StatefulWidget {
  const YourData({Key? key}) : super(key: key);

  @override
  _YourDataState createState() => _YourDataState();
}

class _YourDataState extends State<YourData> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cloud Data'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('user')
            .doc(user.email)
            .collection('passwords')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            return SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: ListView(
                      shrinkWrap: true,
                      children: snapshot.data!.docs.map((doc) {
                        return Card(
                          child: ExpansionTile(
                              subtitle: Text(doc['username'],
                                  overflow: TextOverflow.ellipsis),
                              title: Row(
                                children: [
                                  Text(doc['clientName'],
                                      overflow: TextOverflow.ellipsis),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  FaIcon(
                                    FontAwesomeIcons.solidCheckCircle,
                                    color: Colors.blueGrey,
                                    size: 15,
                                  )
                                ],
                              ),
                              trailing: GestureDetector(
                                onTap: () {
                                  Clipboard.setData(ClipboardData(
                                          text: '${doc['username']}'))
                                      .then((_) => ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text('Password Copied'),
                                            duration: Duration(milliseconds: 500),
                                          )));
                                },
                                onLongPress: () {
                                  Clipboard.setData(ClipboardData(
                                          text:
                                              '${doc['username']} : ${doc['password']}'))
                                      .then((_) => ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'Username and Password Copied'),
                                            duration: Duration(milliseconds: 500),
                                          )));
                                },
                                child: FaIcon(FontAwesomeIcons.copy),
                              ),
                              leading: FaIcon(
                                FontAwesomeIcons.userAlt,
                                color: Colors.blueGrey,
                              ),
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: ListTile(
                                        leading: FaIcon(
                                          FontAwesomeIcons.userSecret,
                                          size: 22,
                                        ),
                                        title: Text(
                                          '${doc['username']}',
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(
                                                  text: '${doc['username']}'))
                                              .then((_) =>
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content:
                                                        Text('Username Copied'),
                                                    duration: Duration(
                                                        milliseconds: 500),
                                                  )));
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: ListTile(
                                        leading: FaIcon(
                                          FontAwesomeIcons.lock,
                                          size: 20,
                                        ),
                                        title: Text('${doc['password']}'),
                                        onTap: () {
                                          Clipboard.setData(ClipboardData(
                                                  text: '${doc['username']}'))
                                              .then((_) =>
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                    content:
                                                        Text('Password Copied'),
                                                    duration: Duration(
                                                        milliseconds: 500),
                                                  )));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ]),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child:
                        Text('If you see Nothing, well there is Nothing. 🙂'),
                  )
                ],
              ),
            );
          } else {
            return ListView(children: [
              Container(
                alignment: Alignment.center,
                child: Wrap(children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          height: 400,
                          width: 300,
                          child:
                              SvgPicture.asset('assets/images/NotFound.svg')),
                      Text(
                        'I am',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'Glory',
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Alone',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 50, fontFamily: 'Glory'),
                      ),
                    ],
                  ),
                ]),
              ),
            ]);
          }
        },
      ),
    );
  }
}

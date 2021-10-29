import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:passmanager/Screens/EditPassword.dart';
import 'package:passmanager/api/DatabaseFunc.dart';
import 'package:passmanager/model/passwordModel.dart';

Widget buildPasswordTile(
    BuildContext context, PasswordsModel passwordsModel, DatabaseFunc db) {
  final data = DateFormat.yMMMd().format(passwordsModel.createdDate);

  return Card(
    child: ExpansionTile(
        subtitle:
            Text(passwordsModel.UserName, overflow: TextOverflow.ellipsis),
        title: Row(
          children: [
            Text(passwordsModel.ClientName, overflow: TextOverflow.ellipsis),
            SizedBox(
              width: 5,
            ),
            passwordsModel.isUpdated
                ? FaIcon(
                    FontAwesomeIcons.solidCheckCircle,
                    color: Colors.blueGrey,
                    size: 15,
                  )
                : Container()
          ],
        ),
        trailing: GestureDetector(
          onTap: () {
            Clipboard.setData(ClipboardData(text: '${passwordsModel.UserName}'))
                .then(
                    (_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Password Copied'),
                          duration: Duration(milliseconds: 500),
                        )));
          },
          onLongPress: () {
            Clipboard.setData(ClipboardData(
                    text:
                        '${passwordsModel.UserName} : ${passwordsModel.Password}'))
                .then(
                    (_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Username and Password Copied'),
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
                    '${passwordsModel.UserName}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Clipboard.setData(
                            ClipboardData(text: '${passwordsModel.UserName}'))
                        .then((_) =>
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Username Copied'),
                              duration: Duration(milliseconds: 500),
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
                  title: Text('${passwordsModel.Password}'),
                  onTap: () {
                    Clipboard.setData(
                            ClipboardData(text: '${passwordsModel.UserName}'))
                        .then((_) =>
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Password Copied'),
                              duration: Duration(milliseconds: 500),
                            )));
                  },
                ),
              ),
            ],
          ),
          ListTile(
            title: Row(
              children: [
                Expanded(
                    child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditPassword(
                                  passwordModel: passwordsModel,
                                  db: db,
                                )));
                  },
                  icon: FaIcon(FontAwesomeIcons.edit),
                  color: Colors.grey,
                )),
                Expanded(
                  child: IconButton(
                    onPressed: () {
                      var isSent = db.sendPassword(passwordsModel);

                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: isSent
                            ? Text('Password sent to your PC')
                            : Text(
                                'This Password is Not on Cloud.\nBackup this Password to Share it with your PC'),
                        duration: isSent
                            ? Duration(milliseconds: 500)
                            : Duration(seconds: 2),
                      ));
                    },
                    icon: FaIcon(FontAwesomeIcons.externalLinkAlt),
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                    child: IconButton(
                  onPressed: () {
                    db.deletePasswordLocal(passwordsModel);
                    db.deletePasswordRemote(passwordsModel);
                  },
                  icon: FaIcon(FontAwesomeIcons.trash),
                  color: Colors.grey,
                )),
              ],
            ),
          ),
        ]),
  );
}

Widget buildContent(List<PasswordsModel> passwords, DatabaseFunc db) {
  return Column(
    children: [
      SizedBox(
        height: 24,
      ),
      passwords.length > 0
          ? Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: passwords.length,
                itemBuilder: (BuildContext context, int index) {
                  final password = passwords[index];
                  return buildPasswordTile(
                    context,
                    password,
                    db,
                  );
                },
              ),
            )
          : SingleChildScrollView(
              child: Container(
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
            )
    ],
  );
}

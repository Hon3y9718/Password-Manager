import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:passmanager/api/DatabaseFunc.dart';
import 'package:passmanager/model/passwordModel.dart';

Widget buildPasswordTile(
    BuildContext context, PasswordsModel passwordsModel, db) {
  final data = DateFormat.yMMMd().format(passwordsModel.createdDate);

  return Card(
    child: ExpansionTile(
        title: Text(passwordsModel.UserName),
        trailing: IconButton(
            splashRadius: 10,
            onPressed: () {
              Clipboard.setData(ClipboardData(text: passwordsModel.Password))
                  .then((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Copied!'),
                    duration: Duration(milliseconds: 500),
                  ),
                );
              });
            },
            icon: FaIcon(FontAwesomeIcons.copy)),
        leading: FaIcon(FontAwesomeIcons.google),
        subtitle: Text(passwordsModel.Password),
        children: [
          ListTile(
            title: Row(
              children: [
                Expanded(
                    child: IconButton(
                  onPressed: () {},
                  icon: FaIcon(FontAwesomeIcons.edit),
                  color: Colors.grey,
                )),
                Expanded(
                  child: IconButton(
                    onPressed: () {},
                    icon: FaIcon(FontAwesomeIcons.eyeSlash),
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                    child: IconButton(
                  onPressed: () {
                    db.deletePassword(passwordsModel);
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
                  return buildPasswordTile(context, password, db);
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
                      Text(
                        '🙁',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                ]),
              ),
            )
    ],
  );
}

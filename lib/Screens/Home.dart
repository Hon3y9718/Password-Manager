import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:passmanager/api/DatabaseFunc.dart';
import 'package:passmanager/boxes.dart';
import 'package:passmanager/colorPalletes/pallet.dart';
import 'package:passmanager/model/passwordModel.dart';
import 'package:passmanager/widgets/widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController clientName = TextEditingController();

  DatabaseFunc db = DatabaseFunc();

  openPopUp(context) {
    Alert(
        //#091921
        context: context,
        title: 'Add Password',
        style: AlertStyle(
            backgroundColor: Color(0xFF091921),
            titleStyle: TextStyle(color: Colors.white),
            isCloseButton: false),
        content: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: clientName,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          labelText: 'Client Name',
                          labelStyle: TextStyle(color: Colors.white),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Client Name is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: userName,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.white),
                          labelText: 'User Name',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'User Name  is required';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    child: TextFormField(
                      controller: password,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.white),
                          labelText: 'Password',
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green)),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.grey, width: 0.0),
                          ),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password  is required';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        buttons: [
          DialogButton(
            color: Colors.green,
            child: Text(
              'Add Password',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () async {
              await db.addPassword(
                  userName.text, password.text, clientName.text);
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Password Added')),
                );
              }
              password.text = '';
              userName.text = '';
              clientName.text = '';
              Navigator.pop(context);
            },
          )
        ]).show();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Color(0xffebf7ba),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ValueListenableBuilder<Box<PasswordsModel>>(
        valueListenable: Boxes.getPasswords().listenable(),
        builder: (context, box, _) {
          final password = box.values.toList().cast<PasswordsModel>();

          return buildContent(password, db);
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          openPopUp(context);
        },
        icon: Icon(Icons.add),
        label: Text('Add New'),
      ),
    );
  }
}

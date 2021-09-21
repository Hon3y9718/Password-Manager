import 'package:flutter/material.dart';
import 'package:passmanager/api/DatabaseFunc.dart';
import 'package:passmanager/colorPalletes/pallet.dart';
import 'package:passmanager/model/passwordModel.dart';

class EditPassword extends StatefulWidget {
  const EditPassword({Key? key, required this.passwordModel, required this.db})
      : super(key: key);
  final PasswordsModel passwordModel;
  final DatabaseFunc db;
  @override
  _EditPasswordState createState() => _EditPasswordState();
}

class _EditPasswordState extends State<EditPassword> {
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController clientName = TextEditingController();

  save() {
    widget.db.editPasswordLocal(
        widget.passwordModel, userName.text, password.text, clientName.text);
    widget.db.editPasswordRemote(
        widget.passwordModel, userName.text, password.text, clientName.text);

    Navigator.pop(context);
  }

  @override
  void initState() {
    userName.text = widget.passwordModel.UserName;
    password.text = widget.passwordModel.Password;
    clientName.text = widget.passwordModel.ClientName;
    super.initState();
  }

  @override
  void dispose() {
    userName.dispose();
    clientName.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Make Changes')),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(top: 40, left: 12, right: 12, bottom: 0),
          child: Column(
            children: [
              TextField(
                  controller: clientName,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.orange)),
                      labelText: 'Client Name',
                      hoverColor: Colors.deepOrange)),
              SizedBox(
                height: 20,
              ),
              TextField(
                controller: userName,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                        borderRadius: BorderRadius.circular(5)),
                    labelText: 'User Name',
                    hoverColor: Colors.deepOrange),
              ),
              SizedBox(
                height: 20,
              ),
              TextField(
                  controller: password,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide(color: Colors.orange)),
                      labelText: 'Password',
                      hoverColor: Colors.deepOrange)),
              Container(
                margin: EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.grey,
                          padding: EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15)),
                    ),
                    TextButton(
                        onPressed: save,
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                            backgroundColor: Pallete.pallet1,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15)))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

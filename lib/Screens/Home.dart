import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:passmanager/Screens/DrawerScreens/Connect.dart';
import 'package:passmanager/Screens/DrawerScreens/Profile.dart';
import 'package:passmanager/Screens/DrawerScreens/YourData.dart';
import 'package:passmanager/api/DatabaseFunc.dart';
import 'package:passmanager/api/uniqueIDGenrator.dart';
import 'package:passmanager/boxes.dart';
import 'package:passmanager/colorPalletes/pallet.dart';
import 'package:passmanager/model/passwordModel.dart';
import 'package:passmanager/widgets/widgets.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.auth}) : super(key: key);
  final auth;
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController clientName = TextEditingController();

  DatabaseFunc db = DatabaseFunc();
  Sync sync = Sync();

  final user = FirebaseAuth.instance.currentUser!;

  var isBackUpOn = true;
  var isDarkOn = true;
  var backupTitle = 'Backup Off';
  var backupTileColor = Colors.red;

  setSharedPreferenceBool(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  getSharedPreferenceBool(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  toggleBackup(bool value) async {
    if (isBackUpOn) {
      setSharedPreferenceBool('isBackUpOn', false);
      setState(() {
        isBackUpOn = false;
        backupTitle = 'Backup Off';
      });
    } else {
      setSharedPreferenceBool('isBackUpOn', true);
      setState(() {
        isBackUpOn = true;
        backupTitle = 'Backup On';
      });
    }
  }

  toggleTheme(bool value) async {
    if (isDarkOn) {
      await setSharedPreferenceBool('isDarkOn', false);
      setState(() {
        isDarkOn = false;
        EasyDynamicTheme.of(context).changeTheme(dark: isDarkOn);
      });
    } else {
      await setSharedPreferenceBool('isDarkOn', true);
      setState(() {
        isDarkOn = true;
        EasyDynamicTheme.of(context).changeTheme(dark: isDarkOn);
      });
    }
  }

  setVariablesAsSharedPreferences() async {
    var testDarkMode;
    var testBackupMode;
    try {
      testDarkMode = await getSharedPreferenceBool('isDarkOn');
      testBackupMode = await getSharedPreferenceBool('isBackUpOn');
      if (testDarkMode != null) {
        isDarkOn = testDarkMode;
        EasyDynamicTheme.of(context).changeTheme(dark: isDarkOn);
      } else {
        EasyDynamicTheme.of(context).changeTheme(dark: isDarkOn);
      }
      if (testBackupMode != null) {
        isBackUpOn = testBackupMode;
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    setVariablesAsSharedPreferences();
    super.initState();
  }

  @override
  void dispose() {
    Hive.close();
    super.dispose();
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      //backgroundColor: Color(0xffebf7ba),
      appBar: AppBar(
        title: Text(
          'Password Manager',
          style: TextStyle(fontFamily: 'Glory', fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
          icon: FaIcon(
            FontAwesomeIcons.arrowRight,
            size: 18,
          ),
        ),
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
        icon: FaIcon(
          FontAwesomeIcons.plus,
          size: 15,
        ),
        label: Text('Add New'),
      ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: DrawerHeader(
                    decoration: BoxDecoration(
                      color: Pallete.pallet1,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            'Hi,\n${user.displayName}',
                            style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Glory', fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                //Cloud
                ListTile(
                  title: Text(
                    'Your Data', style: TextStyle(fontWeight: FontWeight.bold)
                  ),
                  leading: FaIcon(
                    FontAwesomeIcons.cloud,
                    size: 22,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => YourData()));
                  },
                ),

                //Profile
                ListTile(
                  title: Text(
                    'Profile',

                  ),
                  leading: FaIcon(
                    FontAwesomeIcons.userAlt,
                    size: 22,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Profile(
                                  auth: widget.auth,
                                )));
                  },
                ),

                //Device ID
                //Connect
                ListTile(
                  title: Text(
                    'Connect',

                  ),
                  subtitle: Text('Connect with PC', ),
                  leading: FaIcon(
                    FontAwesomeIcons.plug,
                    size: 22,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Connect()));
                  },
                ),
              ],
            ),

            //Company Name
            Column(
              children: [
                ListTile(
                  onTap: () {
                    isDarkOn ? toggleTheme(false) : toggleTheme(true);
                  },
                  title: Text(
                    'Dark Mode',

                  ),
                  leading: FaIcon(
                    FontAwesomeIcons.moon,
                    size: 22,
                  ),
                  trailing: Switch(
                    onChanged: toggleTheme,
                    value: isDarkOn,
                  ),
                ),
                ListTile(
                  tileColor: isBackUpOn ? Colors.greenAccent : Colors.red,
                  onTap: () {
                    isBackUpOn ? toggleBackup(false) : toggleBackup(true);
                  },
                  title: Text(
                    backupTitle,

                  ),
                  leading: FaIcon(
                    FontAwesomeIcons.blog,
                    size: 22,
                  ),
                  trailing: Switch(
                    onChanged: toggleBackup,
                    value: isBackUpOn,
                    activeColor: Theme.of(context).primaryColor,
                    inactiveThumbColor: Theme.of(context).accentColor,
                    inactiveTrackColor: Colors.black26,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

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
              style: TextStyle(color: Colors.white, fontFamily: 'Glory'),
            ),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                if (isBackUpOn) {
                  PasswordsModel passwordModel = await db.addPasswordRemote(
                      userName.text, password.text, clientName.text);
                  await db.addPasswordLocal(passwordModel);
                } else {
                  var idGenerator = GenerateUUID();
                  var id = idGenerator.generateUniqueID();
                  PasswordsModel passwordsModel = PasswordsModel(
                      clientName.text,
                      password.text,
                      userName.text,
                      DateTime.now(),
                      false,
                      'null',
                      id);
                  await db.addPasswordLocal(passwordsModel);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Password Added', style: TextStyle(fontFamily: 'Glory'))),
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
}

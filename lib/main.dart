import 'package:flutter/material.dart';
import 'package:passmanager/Screens/bioLock.dart';
import 'package:passmanager/api/localAuthAPI.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:passmanager/model/passwordModel.dart';
import 'Screens/Home.dart';
import 'colorPalletes/pallet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PasswordsModelAdapter());
  await Hive.openBox<PasswordsModel>('passwords');
  LocalAuthApi auth = LocalAuthApi();
  runApp(MyApp(auth: auth));
}

class MyApp extends StatelessWidget {
  MyApp({this.auth});
  final auth;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Manager',
      theme: ThemeData(
          primarySwatch: Pallete.pallet1, accentColor: Pallete.pallet1),
      home: BioLock(
        authAPI: auth,
      ),
      //home: Home(title: 'Password Manager'),
    );
  }
}

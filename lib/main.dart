import 'package:easy_dynamic_theme/easy_dynamic_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:passmanager/Screens/Redirector.dart';
import 'package:passmanager/api/googleSignInProvider.dart';
import 'package:passmanager/api/localAuthAPI.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:passmanager/model/passwordModel.dart';
import 'package:provider/provider.dart';
import 'colorPalletes/pallet.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(PasswordsModelAdapter());
  await Hive.openBox<PasswordsModel>('passwords');
  LocalAuthApi auth = LocalAuthApi();
  await Firebase.initializeApp();
  runApp(EasyDynamicThemeWidget(
    child: MyApp(
      auth: auth,
    ),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({
    this.auth,
  });

  final auth;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        title: 'Password Manager',
        debugShowCheckedModeBanner: false,
        themeMode: EasyDynamicTheme.of(context).themeMode,
        darkTheme: ThemeData.dark(),
        theme: ThemeData(
            primarySwatch: Pallete.pallet1, accentColor: Pallete.pallet1),
        home: Redirector(auth: auth),
      ),
    );
  }
}

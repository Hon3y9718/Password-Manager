import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:passmanager/model/passwordModel.dart';

class Boxes {
  static Box<PasswordsModel> getPasswords() => Hive.box('passwords');
}

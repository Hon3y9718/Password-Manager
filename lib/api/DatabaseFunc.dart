import 'package:passmanager/boxes.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:passmanager/model/passwordModel.dart';

class DatabaseFunc {
//Add New Password
  Future addPassword(
      String UserName, String Password, String ClientName) async {
    final password =
        PasswordsModel(ClientName, Password, UserName, DateTime.now(), true);
    final box = Boxes.getPasswords();
    box.add(password);
  }

//Edit Old Password
  void editPassword(
    PasswordsModel passwordModel,
    String username,
    String password,
    String clientname,
    bool isUpdated,
  ) {
    passwordModel.UserName = username;
    passwordModel.ClientName = clientname;
    passwordModel.isUpdated = isUpdated;

    passwordModel.save();
  }

  void deletePassword(PasswordsModel password) {
    password.delete();
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:passmanager/api/uniqueIDGenrator.dart';
import 'package:passmanager/boxes.dart';
import 'package:passmanager/model/passwordModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseFunc {
  var firestoreDocId = 'null';
  final user = FirebaseAuth.instance.currentUser!;
  GenerateUUID idGenerator = GenerateUUID();

  //Add New Password
  Future addPasswordLocal(PasswordsModel password) async {
    // Add Password to Local DB
    final box = Boxes.getPasswords();
    box.add(password);
    firestoreDocId = 'null';
  }

  addPasswordRemote(String UserName, String Password, String ClientName) async {
    var id = idGenerator.generateUniqueID();
    final password = PasswordsModel(
        ClientName, Password, UserName, DateTime.now(), false, 'null', id);
    String firestoreId = 'null';
    var passModel;

    //Add Password to Firestore
    try {
      await FirebaseFirestore.instance
          .collection('user')
          .doc(user.email)
          .collection('passwords')
          .add(password.converter())
          .then((value) => {
                firestoreId = value.id,
                passModel = PasswordsModel(ClientName, Password, UserName,
                    DateTime.now(), true, firestoreId, id)
              });
      return passModel;
    } catch (error) {
      print(error);
      return PasswordsModel(
          ClientName, Password, UserName, DateTime.now(), false, 'null', id);
    }
  }

//Edit Old Password
  void editPasswordLocal(
    PasswordsModel passwordModel,
    String username,
    String password,
    String clientname,
  ) {
    passwordModel.UserName = username;
    passwordModel.ClientName = clientname;
    passwordModel.Password = password;

    passwordModel.save();
  }

  //Update Remote
  editPasswordRemote(
    PasswordsModel passwordModel,
    String username,
    String password,
    String clientname,
  ) {
    passwordModel.UserName = username;
    passwordModel.ClientName = clientname;
    passwordModel.Password = password;
    if (passwordModel.isUpdated) {
      try {
        FirebaseFirestore.instance
            .collection('user')
            .doc(user.email)
            .collection('passwords')
            .doc(passwordModel.firestoreDocID)
            .update(passwordModel.converter())
            .catchError((e) => print(e));
        return true;
      } on Exception catch (e) {
        return false;
      }
    } else {
      return false;
    }
  }

  void deletePasswordLocal(PasswordsModel password) {
    password.delete();
  }

  deletePasswordRemote(PasswordsModel passwordsModel) {
    if (passwordsModel.isUpdated) {
      print(passwordsModel.firestoreDocID);
      try {
        FirebaseFirestore.instance
            .collection('user')
            .doc(user.email)
            .collection('passwords')
            .doc(passwordsModel.firestoreDocID)
            .delete();
        return true;
      } on Exception catch (e) {
        print(e);
      }
    }
    return false;
  }

  //Send Password to PC / Other Accesible Location
  sendPassword(PasswordsModel passwordsModel) {
    bool createNew = false; //To create New Doc in Copied Password Branch
    var uniqueId = passwordsModel.ID;
    if (passwordsModel.isUpdated) {
      FirebaseFirestore.instance
          .collection('user')
          .doc(user.email)
          .collection('copiedPassword')
          .get()
          .then((snapshot) {
        if (snapshot.size > 0) {
          for (DocumentSnapshot doc in snapshot.docs) {
            if (uniqueId != doc.get('ref')) {
              doc.reference.delete();
              createNew = true;
            }
          }
        } else {
          createNew = true;
        }
      }).then((value) => {
                if (createNew)
                  {
                    FirebaseFirestore.instance
                        .collection('user')
                        .doc(user.email)
                        .collection('copiedPassword')
                        .add({'ref': uniqueId}),
                    createNew = false,
                    print(uniqueId)
                  }
              });
      return true;
    } else {
      return false;
    }
  }

  backupAllPasswords() async {
    final box = Boxes.getPasswords();
    List<PasswordsModel> listOfData = box.values.toList();

    try {
      listOfData.forEach((passwordModel) async {
        if (!passwordModel.isUpdated) {
          try {
            PasswordsModel updatedPasswordModel = await this.addPasswordRemote(
                passwordModel.UserName,
                passwordModel.Password,
                passwordModel.ClientName);

            //Updating Password Model Locally
            passwordModel.firestoreDocID = updatedPasswordModel.firestoreDocID;
            passwordModel.isUpdated = true;
            await passwordModel.save();
          } on Exception catch (e) {
            print(e);
          }
        }
      });
    } on Exception catch (e) {
      print(e);
      return false;
    }
    return true;
  }
}

class SharedPreferncesFunctions {
  /* ***************** Getters ******************* */

  getBool(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  getString(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  getInt(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }

  getDouble(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key);
  }

  getKeys(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getKeys();
  }

  /* ***************** Setters ******************* */

  setBool(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  setString(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  setInt(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  setDouble(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(key, value);
  }
}

class Sync {
  final user = FirebaseAuth.instance.currentUser!;
  final db = DatabaseFunc();
  final box = Boxes.getPasswords();
  syncFromFirestore() {
    var querySnapshot = FirebaseFirestore.instance
        .collection('user')
        .doc(user.email)
        .collection('passwords')
        .get();

    querySnapshot.then((snapshot) => {
          snapshot.docs.forEach((element) {
            var createdDate = DateTime.fromMicrosecondsSinceEpoch(
                element['createdDate'].microsecondsSinceEpoch);
            PasswordsModel model = PasswordsModel(
                element['clientName'],
                element['password'],
                element['username'],
                createdDate,
                true,
                element.id,
                element['ID']);
            var list = box.values.where((key) => key.ID == element['ID']);
            if (list.isEmpty) {
              db.addPasswordLocal(model);
            }
          })
        });
  }
}

class Account {
  final user = FirebaseAuth.instance.currentUser!;
  final db = DatabaseFunc();
  final box = Boxes.getPasswords();

  LogOut() {
    FirebaseAuth.instance.signOut();
  }
}

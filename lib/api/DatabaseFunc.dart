import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:passmanager/boxes.dart';
import 'package:passmanager/model/passwordModel.dart';

class DatabaseFunc {
  var firestoreDocId = 'null';
  final user = FirebaseAuth.instance.currentUser!;

//Add New Password
  Future addPasswordLocal(PasswordsModel password) async {
    // Add Password to Local DB
    final box = Boxes.getPasswords();
    box.add(password);
    firestoreDocId = 'null';
  }

  addPasswordRemote(String UserName, String Password, String ClientName) async {
    final password = PasswordsModel(
        ClientName, Password, UserName, DateTime.now(), false, 'null');
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
                    DateTime.now(), true, firestoreId)
              });
      return passModel;
    } catch (error) {
      print(error);
      return PasswordsModel(
          ClientName, Password, UserName, DateTime.now(), false, 'null');
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
    if (passwordModel.firestoreDocID != 'null') {
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
    deletePasswordRemote(password);
    password.delete();
  }

  deletePasswordRemote(PasswordsModel passwordsModel) {
    if (passwordsModel.firestoreDocID != 'null') {
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
  sendPassword(String firestoreDocId) {
    bool createNew = false;
    FirebaseFirestore.instance
        .collection('user')
        .doc(user.email)
        .collection('copiedPassword')
        .get()
        .then((snapshot) {
      if (snapshot.size > 0) {
        for (DocumentSnapshot doc in snapshot.docs) {
          if (firestoreDocId != doc.get('ref')) {
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
                      .add({'ref': firestoreDocId}),
                  createNew = false
                }
            });
  }
}

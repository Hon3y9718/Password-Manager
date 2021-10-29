import 'package:hive/hive.dart';

part 'passwordModel.g.dart';

@HiveType(typeId: 0)
class PasswordsModel extends HiveObject {
  @HiveField(0)
  late String ClientName;

  @HiveField(1)
  late DateTime createdDate;

  @HiveField(2)
  late bool isUpdated = true;

  @HiveField(3)
  late String UserName;

  @HiveField(4)
  late String Password;

  @HiveField(5)
  late String firestoreDocID;

  @HiveField(6)
  late String ID;

  PasswordsModel(this.ClientName, this.Password, this.UserName,
      this.createdDate, this.isUpdated, this.firestoreDocID, this.ID);

  converter() {
    return {
      'clientName': this.ClientName,
      'password': this.Password,
      'username': this.UserName,
      'createdDate': this.createdDate,
      'ID': this.ID
    };
  }
}

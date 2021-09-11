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

  PasswordsModel(this.ClientName, this.Password, this.UserName,
      this.createdDate, this.isUpdated);
}

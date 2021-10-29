import 'package:uuid/uuid.dart';

class GenerateUUID {
  var uuid = Uuid();

  generateUniqueID() {
    return uuid.v1();
  }
}

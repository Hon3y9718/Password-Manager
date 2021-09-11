// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'passwordModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PasswordsModelAdapter extends TypeAdapter<PasswordsModel> {
  @override
  final int typeId = 0;

  @override
  PasswordsModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PasswordsModel(
      fields[0] as String,
      fields[4] as String,
      fields[3] as String,
      fields[1] as DateTime,
      fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PasswordsModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.ClientName)
      ..writeByte(1)
      ..write(obj.createdDate)
      ..writeByte(2)
      ..write(obj.isUpdated)
      ..writeByte(3)
      ..write(obj.UserName)
      ..writeByte(4)
      ..write(obj.Password);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PasswordsModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

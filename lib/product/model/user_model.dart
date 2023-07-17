import 'package:hive_flutter/hive_flutter.dart';
@HiveType(typeId: 0)
class UserModel extends HiveObject {

  @HiveField(0)
  final String name;

  UserModel({
    required this.name,
  });
}


class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 0;

  @override
  UserModel read(BinaryReader reader) {
    return UserModel(
      name: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.writeString(obj.name);
  }
}

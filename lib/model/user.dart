import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1)
class User{

  @HiveField(0)
  String id;
  @HiveField(1)
  String username;
  @HiveField(2)
  String mail;

  User({required this.id, required this.username, required this.mail});

  static User getFromSnapShot(MapEntry mapEntry){
    return User(
      id: mapEntry.value["id"],
      username: mapEntry.value["username"],
      mail: mapEntry.value["mail"]
    );
  }
}
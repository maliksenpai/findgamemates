import 'package:hive/hive.dart';

part 'app_user.g.dart';

@HiveType(typeId: 1)
class AppUser{

  @HiveField(0)
  String? uid;
  @HiveField(1)
  String? displayName;
  @HiveField(2)
  String? email;

  AppUser({required this.uid, required this.displayName, required this.email});

  static AppUser getFromSnapShot(MapEntry mapEntry){
    return AppUser(
      uid: mapEntry.value["uid"],
      displayName: mapEntry.value["displayName"],
      email: mapEntry.value["email"]
    );
  }

  Map<String, dynamic> toJson() => {
    "uid" : uid,
    "displayName" : displayName,
    "email" : email
  };
}
import 'dart:convert';

import 'package:crypto/crypto.dart';

class LoginRequest{

  String mail;
  String passHash;

  get passwordHash{
    var key = utf8.encode(passHash);
    return sha1.convert(key);
  }

  LoginRequest({required this.mail, required this.passHash});

  Map<String, dynamic> toJson() =>{
    "mail" : mail,
    "passHash" : passHash
  };


}
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hailoga/models/users_model.dart';

class GetToken{
  static const _storage = FlutterSecureStorage();
  static String token;

  static getToken(){
    _storage.read(key: 'tok').then((value) => token=value);
  }
}

class GetName{
  static String name;
}

class APIAddress{
  static String api = 'http://192.168.44.254:8000';

  APIAddress();
}

class GetUser{
  static UsersModel userModel;
}

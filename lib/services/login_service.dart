import 'dart:convert';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/login_model.dart';
import 'package:hailoga/services/helpers.dart';
import 'package:http/http.dart' as http;


class LoginService{
  static String API = '${APIAddress.api}/api/v1/login/';
  
  Future<APIResponse<LoginModel>> login(username, password){
    var map = new Map<String, dynamic>();
    map['username'] = username;
    map['password'] = password;
    return http.post(API,body:map)
    .then((data) {
      if(data.statusCode == 200){
        final jsonData = json.decode(data.body);
        return APIResponse<LoginModel>(data: LoginModel(token: jsonData['token']));
      }
      final jsonData = json.decode(data.body);
      return APIResponse<LoginModel>(error:true,errorMessage:jsonData['non_field_errors'][0]);
    }).catchError((error)=>APIResponse<LoginModel>(error: true,errorMessage: '$error'));
  }
}
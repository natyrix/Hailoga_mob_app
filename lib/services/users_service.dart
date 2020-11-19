import 'dart:convert';
import 'dart:io';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/users_model.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/services/helpers.dart';
import 'package:http/http.dart' as http;

import 'helpers.dart';


class UsersService{
  static String API = '${APIAddress.api}/api/v1/users/';
  final String token = GetToken.token;
  Future<APIResponse<UsersModel>> getUsers(){
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      return http.get(API, headers: headers)
      .then((data) {
        if(data.statusCode == 200){
          final jsonData = json.decode(data.body);
          GetName.name = "${jsonData['first_name']} & ${jsonData['fiance_first_name']}";
          return APIResponse<UsersModel>(data: UsersModel(
            id: jsonData['id'],
            email: jsonData['email'],
            fianceEmail: jsonData['fiance_email'],
            firstName: jsonData['first_name'],
            lastName: jsonData['last_name'],
            fianceFirstName: jsonData['fiance_first_name'],
            fianceLastName: jsonData['fiance_last_name'],
            role: jsonData['role'],
            weddingDate: jsonData['wedding_date']
          ));
        }
        final jsonData = json.decode(data.body);
        return APIResponse<UsersModel>(error: true,errorMessage: jsonData['detail']);
      }).catchError((error)=>APIResponse<UsersModel>(error: true,errorMessage: '$error'));
    }
    print('null $token');
    return noToken();
    
  }
  Future<APIResponse<UsersModel>> noToken() async{
    return await APIResponse<UsersModel>(error: true,errorMessage: 'Unable to read provided token');
  }
  Future<APIResponse<List<ImageGallery>>> getImages(){
    String API = '${APIAddress.api}/api/v1/users/images/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      return http.get(API, headers: headers)
          .then((data) {
            if(data.statusCode == 200){
              final jsonData = json.decode(data.body);
              final images = <ImageGallery>[];
              for(var img in jsonData){
                images.add(ImageGallery.fromJson(img));
              }
              return APIResponse<List<ImageGallery>>(data: images);
            }
            final jsonData = json.decode(data.body);
            return APIResponse<List<ImageGallery>>(error: true, errorMessage: jsonData['message']);
      }).catchError((error)=>APIResponse<List<ImageGallery>>(error: true, errorMessage: '$error'));
    }
    return getImgNoToken();
  }
  Future<APIResponse<List<ImageGallery>>> getImgNoToken() async{
    return await APIResponse<List<ImageGallery>>(error: true,errorMessage: 'Unable to read provided token');
  }

  Future<APIResponse<List<VideoGallery>>> getVideos(){
    String API = '${APIAddress.api}/api/v1/users/videos/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      return http.get(API, headers: headers)
          .then((data) {
        if(data.statusCode == 200){
          final jsonData = json.decode(data.body);
          final videos = <VideoGallery>[];
          for(var vid in jsonData){
            videos.add(VideoGallery.fromJson(vid));
          }
          return APIResponse<List<VideoGallery>>(data: videos);
        }
        final jsonData = json.decode(data.body);
        return APIResponse<List<VideoGallery>>(error: true, errorMessage: jsonData['message']);
      }).catchError((error)=>APIResponse<List<VideoGallery>>(error: true, errorMessage: '$error'));
    }
    return getVidNoToken();
  }
  Future<APIResponse<List<VideoGallery>>> getVidNoToken() async{
    return await APIResponse<List<VideoGallery>>(error: true,errorMessage: 'Unable to read provided token');
  }

  Future<APIResponse<Message>> uploadImg(fileName,File file) async{
    String api = '${APIAddress.api}/api/v1/users/images/';
    if(token!=null){
      var headerss = Map<String, String>();
      headerss['Authorization'] = 'Token $token';
      var request = http.MultipartRequest("POST", Uri.parse(api));
      request.fields["name"] = fileName;
      request.headers.addAll(headerss);
      var pic = await  http.MultipartFile.fromPath("file_field", file.path);
      request.files.add(pic);
      return request.send()
          .then((data){
        if(data.statusCode == 200){
          return APIResponse<Message>(
              data: Message(
                  message: "uploaded successful, please wait for approval"
              )
          );
        }
        return APIResponse<Message>(error: true, errorMessage: "Error occurred can not be uploaded");
      })
          .catchError((error)=>APIResponse<Message>(error: true, errorMessage: '$error'));
    }
    return uploadImgNoToken();
  }
  Future<APIResponse<Message>> uploadImgNoToken() async{
    return await APIResponse<Message>(error: true, errorMessage: "Unable to read provided token, failed to load data");
  }

  Future<APIResponse<Message>> deleteImg(img_id){
    String api = '${APIAddress.api}/api/v1/users/images/$img_id/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      return http.delete(api, headers: headers)
          .then((data){
        if(data.statusCode == 200){
          final jsonData = json.decode(data.body);
          return APIResponse<Message>(
              data: Message(
                  message: jsonData['message']
              )
          );
        }
        final jsonData = json.decode(data.body);
        return APIResponse<Message>(error: true, errorMessage: jsonData['message']);
      })
          .catchError((error)=>APIResponse<Message>(error: true, errorMessage: '$error'));
    }
    return deleteImgNoToken();
  }
  Future<APIResponse<Message>> deleteImgNoToken() async{
    return await APIResponse<Message>(error: true, errorMessage: "Unable to read provided token, failed to load data");
  }

}
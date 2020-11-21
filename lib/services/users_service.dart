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
          GetUser.userModel = UsersModel(
              id: jsonData['id'],
              email: jsonData['email'],
              fianceEmail: jsonData['fiance_email'],
              firstName: jsonData['first_name'],
              lastName: jsonData['last_name'],
              fianceFirstName: jsonData['fiance_first_name'],
              fianceLastName: jsonData['fiance_last_name'],
              role: jsonData['role'],
              weddingDate: jsonData['wedding_date']
          );
          return APIResponse<UsersModel>(data: GetUser.userModel);
        }
        final jsonData = json.decode(data.body);
        return APIResponse<UsersModel>(error: true,errorMessage: jsonData['detail']);
      }).catchError((error)=>APIResponse<UsersModel>(error: true,errorMessage: '$error'));
    }
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

  Future<APIResponse<Message>> uploadVideo(fileName,File file) async{
    String api = '${APIAddress.api}/api/v1/users/videos/';
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
  Future<APIResponse<Message>> deleteVideo(vid_id){
    String api = '${APIAddress.api}/api/v1/users/videos/$vid_id/';
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

  Future<APIResponse<Message>> updateUsers(UsersModel usersModel){
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      var map = Map<String, dynamic>();
      map['first_name'] = usersModel.firstName;
      map['last_name'] = usersModel.lastName;
      map['email'] = usersModel.email;
      map['role'] = usersModel.role;
      map['wedding_date'] = usersModel.weddingDate;
      map['fiance_first_name'] = usersModel.fianceFirstName;
      map['fiance_last_name'] = usersModel.fianceLastName;
      map['fiance_email'] = usersModel.fianceEmail;
      return http.post(API, headers: headers, body: map)
          .then((data) {
        if(data.statusCode == 200){
          final jsonData = json.decode(data.body);
          return APIResponse<Message>(data: Message(
            message: jsonData['message']
          ));
        }
        final jsonData = json.decode(data.body);
        return APIResponse<Message>(error: true,errorMessage: jsonData['message']);
      }).catchError((error)=>APIResponse<Message>(error: true,errorMessage: '$error'));
    }
    return deleteImgNoToken();
  }
  Future<APIResponse<Message>> changePassword(oldPass, newPass, conPass){
    String api = '${APIAddress.api}/api/v1/users/change_password/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      var map = Map<String, dynamic>();
      map['old_pass'] = oldPass;
      map['new_pass'] = newPass;
      map['con_pass'] = conPass;

      return http.patch(api, headers: headers, body: map)
          .then((data) {
        if(data.statusCode == 200){
          final jsonData = json.decode(data.body);
          return APIResponse<Message>(data: Message(
              message: jsonData['message']
          ));
        }
        final jsonData = json.decode(data.body);
        print(jsonData);
        return APIResponse<Message>(error: true,errorMessage: jsonData['message']);
      }).catchError((error)=>APIResponse<Message>(error: true,errorMessage: '$error'));
    }
    return deleteImgNoToken();
  }

  Future<APIResponse<List<Notifications>>> getNotifications(){
    String API = '${APIAddress.api}/api/v1/users/notifications/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      return http.get(API, headers: headers)
          .then((data) {
        if(data.statusCode == 200){
          final jsonData = json.decode(data.body);
          final notifications = <Notifications>[];
          for(var ntf in jsonData){
            notifications.add(Notifications.fromJson(ntf));
          }
          return APIResponse<List<Notifications>>(data: notifications);
        }
        final jsonData = json.decode(data.body);
        return APIResponse<List<Notifications>>(error: true, errorMessage: jsonData['message']);
      }).catchError((error)=>APIResponse<List<Notifications>>(error: true, errorMessage: '$error'));
    }
    return getNotfNoToken();
  }
  Future<APIResponse<List<Notifications>>> getNotfNoToken() async{
    return await APIResponse<List<Notifications>>(error: true,errorMessage: 'Unable to read provided token');
  }

  Future<APIResponse<List<Appointments>>> getAppointments(){
    String API = '${APIAddress.api}/api/v1/users/appointments/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      return http.get(API, headers: headers)
          .then((data) {
        if(data.statusCode == 200){
          final jsonData = json.decode(data.body);
          final appts = <Appointments>[];
          for(var appt in jsonData){
            appts.add(Appointments.fromJson(appt));
          }
          return APIResponse<List<Appointments>>(data: appts);
        }
        final jsonData = json.decode(data.body);
        return APIResponse<List<Appointments>>(error: true, errorMessage: jsonData['message']);
      }).catchError((error)=>APIResponse<List<Appointments>>(error: true, errorMessage: '$error'));
    }
    return getApptsNoToken();
  }
  Future<APIResponse<List<Appointments>>> getApptsNoToken() async{
    return await APIResponse<List<Appointments>>(error: true,errorMessage: 'Unable to read provided token');
  }

  Future<APIResponse<List<Bookings>>> getBookings(){
    String API = '${APIAddress.api}/api/v1/users/bookings/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      return http.get(API, headers: headers)
          .then((data) {
        if(data.statusCode == 200){
          final jsonData = json.decode(data.body);
          final bkgs = <Bookings>[];
          for(var bkg in jsonData){
            bkgs.add(Bookings.fromJson(bkg));
          }
          return APIResponse<List<Bookings>>(data: bkgs);
        }
        final jsonData = json.decode(data.body);
        return APIResponse<List<Bookings>>(error: true, errorMessage: jsonData['message']);
      }).catchError((error)=>APIResponse<List<Bookings>>(error: true, errorMessage: '$error'));
    }
    return getBkgsNoToken();
  }
  Future<APIResponse<List<Bookings>>> getBkgsNoToken() async{
    return await APIResponse<List<Bookings>>(error: true,errorMessage: 'Unable to read provided token');
  }

  Future<APIResponse<Message>> cancelAppointment(apId){
    String api = '${APIAddress.api}/api/v1/users/appointments/cancel/$apId/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };

      return http.patch(api, headers: headers)
          .then((data) {
        if(data.statusCode == 200){
          final jsonData = json.decode(data.body);
          return APIResponse<Message>(data: Message(
              message: jsonData['message']
          ));
        }
        final jsonData = json.decode(data.body);
        print(jsonData);
        return APIResponse<Message>(error: true,errorMessage: jsonData['message']);
      }).catchError((error)=>APIResponse<Message>(error: true,errorMessage: '$error'));
    }
    return deleteImgNoToken();
  }
  Future<APIResponse<Message>> cancelBooking(bkgId){
    String api = '${APIAddress.api}/api/v1/users/bookings/cancel/$bkgId/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };

      return http.patch(api, headers: headers)
          .then((data) {
        if(data.statusCode == 200){
          final jsonData = json.decode(data.body);
          return APIResponse<Message>(data: Message(
              message: jsonData['message']
          ));
        }
        final jsonData = json.decode(data.body);
        print(jsonData);
        return APIResponse<Message>(error: true,errorMessage: jsonData['message']);
      }).catchError((error)=>APIResponse<Message>(error: true,errorMessage: '$error'));
    }
    return deleteImgNoToken();
  }

}















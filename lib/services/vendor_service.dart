import 'dart:convert';
import 'dart:ffi';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/services/helpers.dart';
import 'package:http/http.dart' as http;
import 'helpers.dart';

class VendorsService{
  static String API = '${APIAddress.api}/api/v1/vendors/';
  final String token = GetToken.token;
  Future<APIResponse<List<VendorsModel>>> getVendors(){
    if(token!=null) {
      var headers = {
        'Authorization': 'Token $token',
      };
      return http.get(API,headers: headers)
          .then((data) {
            if(data.statusCode == 200){
              final jsonData = json.decode(data.body);
              final vendors = <VendorsModel>[];
              for(var v in jsonData['data']){
                vendors.add(VendorsModel.fromJson(v));
              }
              Ratings.ratings = jsonData['ratings'];
              return APIResponse<List<VendorsModel>>(data: vendors);
            }
            final jsonData = json.decode(data.body);
            return APIResponse<List<VendorsModel>>(error: true,errorMessage: jsonData['detail']);
      }).catchError((error)=>APIResponse<List<VendorsModel>>(error: true, errorMessage: '$error'));
    }
    return getvNoToken();
  }
  Future<APIResponse<List<VendorsModel>>> getvNoToken() async{

    return await APIResponse<List<VendorsModel>>(error: true, errorMessage: "Unable to read provided token");
  }
  Future<APIResponse<List<VendorsModel>>> filterVendors(category){
    if(token!=null) {
      var headers = {
        'Authorization': 'Token $token',
      };
      var map = Map<String, dynamic>();
      map['category'] = category;
      return http.post(API,headers: headers, body: map)
          .then((data) {
        if(data.statusCode == 200){
          final jsonData = json.decode(data.body);
          final vendors = <VendorsModel>[];
          for(var v in jsonData['data']){
            vendors.add(VendorsModel.fromJson(v));
          }
          Ratings.ratings = jsonData['ratings'];
          return APIResponse<List<VendorsModel>>(data: vendors);
        }
        final jsonData = json.decode(data.body);
        return APIResponse<List<VendorsModel>>(error: true,errorMessage: jsonData['detail']);
      }).catchError((error)=>APIResponse<List<VendorsModel>>(error: true, errorMessage: '$error'));
    }
    return getvNoToken();
  }



  Future<APIResponse<Message>> sendMsg(msgContent, v_id){
    String api = '${APIAddress.api}/api/v1/vendors/send_msg/$v_id/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      var map = new Map<String, dynamic>();
      map['message'] = msgContent;
      return http.post(api, body: map, headers: headers)
        .then((data){
          if(data.statusCode == 200){
            final jsonData = json.decode(data.body);
            return APIResponse<Message>(data: Message(
              message: jsonData['message']
            ));
          }
          final jsonData = json.decode(data.body);
          return APIResponse<Message>(error: true, errorMessage: jsonData['message']);
      })
        .catchError((error)=>APIResponse<Message>(error: true, errorMessage: '$error'));
    }
    return getSmsgNoToken();
  }

  Future<APIResponse<Message>> getSmsgNoToken() async{
    return await APIResponse<Message>(error: true, errorMessage: "Unable to read provided token, failed to send");
  }

  Future<APIResponse<List<Pricing>>> getPricing(v_id){
    String api = '${APIAddress.api}/api/v1/vendors/pricings/$v_id/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      return http.get(api, headers: headers)
        .then((data) {
          if(data.statusCode == 200){
            final jsonData = json.decode(data.body);
            final prs = <Pricing>[];
            for(var p in jsonData){
              prs.add(Pricing.fromJson(p));
            }
            return APIResponse<List<Pricing>>(data: prs);
          }
          final jsonData = json.decode(data.body);
          return APIResponse<List<Pricing>>(error: true, errorMessage: jsonData['message']);
      }).catchError((error)=>APIResponse<List<Pricing>>(error: true, errorMessage: '$error'));
    }
    return getpriNoToken();
  }
  Future<APIResponse<List<Pricing>>> getpriNoToken() async{
    return await APIResponse<List<Pricing>>(error: true, errorMessage: "Unable to read provided token, failed to load data");
  }

  Future<APIResponse<List<Appointment>>> getAppts(v_id){
    String api = '${APIAddress.api}/api/v1/vendors/appts/$v_id/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      return http.get(api, headers: headers)
        .then((data) {
          if(data.statusCode == 200){
            final jsonData = json.decode(data.body);
            final appts = <Appointment>[];
            for(var appt in jsonData){
              appts.add(Appointment.fromJson(appt));
            }
            return APIResponse<List<Appointment>>(data: appts);
          }
          final jsonData = json.decode(data.body);
          return APIResponse<List<Appointment>>(error: true, errorMessage: jsonData['message']);
      }).catchError((error)=>APIResponse<List<Appointment>>(error: true, errorMessage: '$error'));
    }
    return getapptNoToken();
  }
  Future<APIResponse<List<Appointment>>> getapptNoToken() async{
    return await APIResponse<List<Appointment>>(error: true, errorMessage: "Unable to read provided token, failed to load data");
  }

  Future<APIResponse<List<Booking>>> getBkgs(v_id){
    String api = '${APIAddress.api}/api/v1/vendors/bookings/$v_id/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      return http.get(api, headers: headers)
          .then((data) {
        if(data.statusCode == 200){
          final jsonData = json.decode(data.body);
          final bkgs = <Booking>[];
          for(var bkg in jsonData){
            bkgs.add(Booking.fromJson(bkg));
          }
          return APIResponse<List<Booking>>(data: bkgs);
        }
        final jsonData = json.decode(data.body);
        return APIResponse<List<Booking>>(error: true, errorMessage: jsonData['message']);
      }).catchError((error)=>APIResponse<List<Booking>>(error: true, errorMessage: '$error'));
    }
    return getBkgNoToken();
  }
  Future<APIResponse<List<Booking>>> getBkgNoToken() async{
    return await APIResponse<List<Booking>>(error: true, errorMessage: "Unable to read provided token, failed to load data");
  }

  Future<APIResponse<List<Review>>> getReviews(v_id){
    String api = '${APIAddress.api}/api/v1/vendors/reviews/$v_id/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      return http.get(api, headers: headers)
          .then((data) {
        if(data.statusCode == 200){
          final jsonData = json.decode(data.body);
          final rvws = <Review>[];
          for(var rvw in jsonData){
            rvws.add(Review.fromJson(rvw));
          }
          return APIResponse<List<Review>>(data: rvws);
        }
        final jsonData = json.decode(data.body);
        return APIResponse<List<Review>>(error: true, errorMessage: jsonData['message']);
      }).catchError((error)=>APIResponse<List<Review>>(error: true, errorMessage: '$error'));
    }
    return getRvwNoToken();
  }
  Future<APIResponse<List<Review>>> getRvwNoToken() async{
    return await APIResponse<List<Review>>(error: true, errorMessage: "Unable to read provided token, failed to load data");
  }

  Future<APIResponse<List<VendorImage>>> getImages(v_id){
    String api = '${APIAddress.api}/api/v1/vendors/images/$v_id/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      return http.get(api, headers: headers)
          .then((data) {
        if(data.statusCode == 200){
          final jsonData = json.decode(data.body);
          final imgs = <VendorImage>[];
          for(var img in jsonData){
            imgs.add(VendorImage.fromJson(img));
          }
          return APIResponse<List<VendorImage>>(data: imgs);
        }
        final jsonData = json.decode(data.body);
        return APIResponse<List<VendorImage>>(error: true, errorMessage: jsonData['message']);
      }).catchError((error)=>APIResponse<List<VendorImage>>(error: true, errorMessage: '$error'));
    }
    return getVImgNoToken();
  }
  Future<APIResponse<List<VendorImage>>> getVImgNoToken() async{
    return await APIResponse<List<VendorImage>>(error: true, errorMessage: "Unable to read provided token, failed to load data");
  }

  Future<APIResponse<List<VendorChats>>> getVendorChats(v_id){
    String api = '${APIAddress.api}/api/v1/vendors/chats/$v_id/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      return http.get(api, headers: headers)
          .then((data) {
        if(data.statusCode == 200){
          final jsonData = json.decode(data.body);
          final chats = <VendorChats>[];
          for(var chat in jsonData){
            chats.add(VendorChats.fromJson(chat));
          }
          return APIResponse<List<VendorChats>>(data: chats);
        }
        final jsonData = json.decode(data.body);
        return APIResponse<List<VendorChats>>(error: true, errorMessage: jsonData['message']);
      }).catchError((error)=>APIResponse<List<VendorChats>>(error: true, errorMessage: '$error'));
    }
    return getVChtNoToken();
  }
  Future<APIResponse<List<VendorChats>>> getVChtNoToken() async{
    return await APIResponse<List<VendorChats>>(error: true, errorMessage: "Unable to read provided token, failed to load data");
  }

  Future<APIResponse<Rating>> getRate(v_id){
    String api = '${APIAddress.api}/api/v1/vendors/rate/$v_id/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      return http.get(api, headers: headers)
          .then((data) {
        if(data.statusCode == 200 ){
          final jsonData = json.decode(data.body);
          return APIResponse<Rating>(data: Rating(
            rateVal: jsonData['rate_value']
          ));
        }
        if(data.statusCode == 204){
          return APIResponse<Rating>(data: Rating(
            rateVal: 0
          ));
        }
        final jsonData = json.decode(data.body);
        return APIResponse<Rating>(error: true, errorMessage: jsonData['message']);
      }).catchError((error)=>APIResponse<Rating>(error: true, errorMessage: '$error'));
    }
    return getVRateNoToken();
  }
  Future<APIResponse<Rating>> getVRateNoToken() async{
    return await APIResponse<Rating>(error: true, errorMessage: "Unable to read provided token, failed to load data");
  }

  Future<APIResponse<Message>> rateVendor(rateVal, v_id){
    String api = '${APIAddress.api}/api/v1/vendors/rate/$v_id/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      var map = new Map<String, dynamic>();
      map['rate_val'] = rateVal.toString();
      return http.post(api, body: map, headers: headers)
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
    return rateVNoToken();
  }
  Future<APIResponse<Message>> rateVNoToken() async{
    return await APIResponse<Message>(error: true, errorMessage: "Unable to read provided token, failed to load data");
  }

  Future<APIResponse<UserReview>> getReview(v_id){
    String api = '${APIAddress.api}/api/v1/vendors/review/$v_id/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      return http.get(api, headers: headers)
          .then((data) {
        if(data.statusCode == 200 ){
          final jsonData = json.decode(data.body);
          return APIResponse<UserReview>(data: UserReview(
              review: jsonData['review']
          ));
        }
        if(data.statusCode == 204){
          return APIResponse<UserReview>(data: UserReview(
              review: ''
          ));
        }
        final jsonData = json.decode(data.body);
        return APIResponse<UserReview>(error: true, errorMessage: jsonData['message']);
      }).catchError((error)=>APIResponse<UserReview>(error: true, errorMessage: '$error'));
    }
    return getVReviewNoToken();
  }
  Future<APIResponse<UserReview>> getVReviewNoToken() async{
    return await APIResponse<UserReview>(error: true, errorMessage: "Unable to read provided token, failed to load data");
  }

  Future<APIResponse<Message>> reviewVendor(review, v_id){
    String api = '${APIAddress.api}/api/v1/vendors/review/$v_id/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      var map = new Map<String, dynamic>();
      map['review'] = review.toString();
      return http.post(api, body: map, headers: headers)
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
    return reviewVNoToken();
  }
  Future<APIResponse<Message>> reviewVNoToken() async{
    return await APIResponse<Message>(error: true, errorMessage: "Unable to read provided token, failed to load data");
  }

  Future<APIResponse<Message>> makeAppointment(apptDate, startTime, endTime, v_id){
    String api = '${APIAddress.api}/api/v1/vendors/appts/$v_id/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      var map = new Map<String, dynamic>();
      map['appt_date'] = apptDate.toString();
      map['start_time'] = startTime.toString();
      map['end_time'] = endTime.toString();
      return http.post(api, body: map, headers: headers)
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
    return reviewVNoToken();
  }

  Future<APIResponse<Message>> makeBooking(bkgDate, startTime, endTime, v_id){
    String api = '${APIAddress.api}/api/v1/vendors/bookings/$v_id/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      var map = new Map<String, dynamic>();
      map['bkg_date'] = bkgDate.toString();
      map['start_time'] = startTime.toString();
      map['end_time'] = endTime.toString();
      return http.post(api, body: map, headers: headers)
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
    return reviewVNoToken();
  }

  Future<APIResponse<List<CategoryModel>>> getCategories(){
    String api = '${APIAddress.api}/api/v1/vendors/categories/';
    if(token!=null){
      var headers = {
        'Authorization': 'Token $token',
      };
      return http.get(api, headers: headers)
          .then((data) {
        if(data.statusCode == 200){
          final jsonData = json.decode(data.body);
          final cats = <CategoryModel>[];
          for(var cat in jsonData){
            cats.add(CategoryModel.fromJson(cat));
          }
          return APIResponse<List<CategoryModel>>(data: cats);
        }
        final jsonData = json.decode(data.body);
        return APIResponse<List<CategoryModel>>(error: true, errorMessage: jsonData['message']);
      }).catchError((error)=>APIResponse<List<CategoryModel>>(error: true, errorMessage: '$error'));
    }
    return getCatNoToken();
  }
  Future<APIResponse<List<CategoryModel>>> getCatNoToken() async{
    return await APIResponse<List<CategoryModel>>(error: true, errorMessage: "Unable to read provided token, failed to load data");
  }

}
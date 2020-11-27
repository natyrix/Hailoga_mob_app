import 'package:hailoga/models/vendors_model.dart';

class UsersModel{
  int id;
  String firstName;
  String lastName; 
  String email;
  String role;
  String weddingDate;
  String fianceFirstName; 
  String fianceLastName; 
  String fianceEmail;

  UsersModel({
    this.id,
    this.email,
    this.fianceEmail,
    this.fianceLastName,
    this.fianceFirstName,
    this.firstName,
    this.lastName,
    this.role,
    this.weddingDate
  });
}

class ImageGallery{
  int id;
  String imageLocation;

  ImageGallery({
    this.id,
    this.imageLocation
});

  factory ImageGallery.fromJson(dynamic json){
    return ImageGallery(
      id: json['id'],
      imageLocation: json['image_location']
    );
  }
}

class VideoGallery{
  int id;
  String videoLocation;

  VideoGallery({
    this.id,
    this.videoLocation
});

  factory VideoGallery.fromJson(dynamic json){
    return VideoGallery(
      id: json['id'],
      videoLocation: json['video_location']
    );
  }
}

class Notifications{
  int id;
  String title;
  String notificationDate;
  bool readStatus;

  Notifications({
    this.id,
    this.title,
    this.readStatus,
    this.notificationDate
});

  factory Notifications.fromJson(dynamic json){
    return Notifications(
      id: json['id'],
      title: json['title'],
      notificationDate: json['notification_date'],
      readStatus: json['read_status']
    );
  }
}


class Appointments{
  int id;
  String startTime;
  String date;
  String endTime;
  bool status;
  bool declined;
  bool canceled;
  bool expired;
  String vendorName;

  Appointments({
   this.id,
   this.expired,
   this.status,
   this.declined,
   this.endTime,
   this.startTime,
   this.date,
   this.canceled,
   this.vendorName
});

  factory Appointments.fromJson(dynamic json){
    return Appointments(
      id: json['id'],
      date: json['date'],
      status: json['status'],
      declined: json['declined'],
      canceled: json['canceled'],
      expired: json['expired'],
      endTime: json['end_time'],
      startTime: json['start_time'],
      vendorName: json['vendor_name']
    );
  }
}

class Bookings{
  int id;
  String startTime;
  String date;
  String endTime;
  bool status;
  bool declined;
  bool canceled;
  bool expired;
  String vendorName;

  Bookings({
    this.id,
    this.expired,
    this.status,
    this.declined,
    this.endTime,
    this.startTime,
    this.date,
    this.canceled,
    this.vendorName
  });

  factory Bookings.fromJson(dynamic json){
    return Bookings(
        id: json['id'],
        date: json['date'],
        status: json['status'],
        declined: json['declined'],
        canceled: json['canceled'],
        expired: json['expired'],
        endTime: json['end_time'],
        startTime: json['start_time'],
        vendorName: json['vendor_name']
    );
  }
}

class CheckList{
  int id;
  int orderNumber;
  String content;
  String dateAndTime;
  bool status;
  bool isPassed;

  CheckList({
    this.id,
    this.status,
    this.content,
    this.dateAndTime,
    this.isPassed,
    this.orderNumber,
});

  factory CheckList.fromJson(dynamic json){
    return CheckList(
      id: json['id'],
      orderNumber: json['order_number'],
      dateAndTime: json['date_and_time'],
      status: json['status'],
      isPassed: json['is_passed'],
      content: json['content']
    );
  }
}

class Chats{
  int id;
  String sentTime;
  String message;
  String sender;
  bool readStatus;
  VendorsModel vendor;

  Chats({
   this.id,
   this.vendor,
   this.message,
   this.readStatus,
   this.sentTime,
   this.sender,
});

  factory Chats.fromJson(dynamic json){
    return Chats(
      id: json['id'],
      sender: json['sender'],
      sentTime: json['sent_time'],
      message: json['message'],
      readStatus: json['read_status'],
      vendor: VendorsModel.fromJson(json['vendor'])
    );
  }
}

class Budget{
  int id;
  double amount;
  List pricings = <BudgetPricing>[];

  Budget({
    this.id,
    this.amount,
    this.pricings
});

  factory Budget.fromJson(dynamic json){
    return Budget(
      id: json['id'],
      amount: json['amount']
    );
  }
}

class BudgetPricing{
  int id;
  String title;
  String detail;
  double value;
  VendorsModel vendor;

  BudgetPricing({
    this.id,
    this.vendor,
    this.value,
    this.title,
    this.detail
});

  factory BudgetPricing.fromJson(dynamic json){
    return BudgetPricing(
      id: json['id'],
      vendor: VendorsModel.fromJson(json['vendor']),
      title: json['title'],
      value: json['value'],
      detail: json['detail']
    );
  }
}

class Counts{
  int chatCunt;
  int notCount;
  VendorsModel randVendor;
  double ratingCount;

  Counts({
    this.chatCunt,
    this.notCount,
    this.randVendor,
    this.ratingCount
});

  factory Counts.fromJson(dynamic json){
    return Counts(
      chatCunt: json['chat_count'],
      notCount: json['not_count'],
      randVendor: VendorsModel.fromJson(json['ran_vendor']),
    );
  }

}

class VendorsModel{
  int id;
  String name;
  String logo;
  String phoneNumber;
  String email;
  String address;
  CategoryModel category;
  VendorsModel({
    this.email,
    this.address,
    this.category,
    this.id,
    this.logo,
    this.name,
    this.phoneNumber
  });

  factory VendorsModel.fromJson(dynamic json){
    return VendorsModel(
      name: json['name'] as String,
      id: json['id'] as int,
      email: json['email'] as String,
      phoneNumber: json['phonenumber'] as String,
      address: json['address'] as String,
      logo: json['logo'] as String,
      category: CategoryModel.fromJson(json['category'])
    );
  }
}

class CategoryModel{
  int id;
  String name;

  CategoryModel({
    this.name,
    this.id
  });
  factory CategoryModel.fromJson(dynamic json){
    return CategoryModel(
      name: json['category_name'] as String,
      id: json['id'] as int
    );
  }
}
class Ratings{
  static List ratings = [];
  Ratings();
}

class Message{
  String message;
  Message({
    this.message
  });
}

class Pricing{
  String title;
  int id;
  String detail;
  double value;
  Pricing({
    this.id,
    this.value,
    this.title,
    this.detail
  });
  factory Pricing.fromJson(dynamic json){
    return Pricing(
      id: json['id'] as int,
      title: json['title'] as String,
      value: json['value'] as double,
      detail: json['detail'] as String
    );
  }
}
class Appointment{
  int id;
  String startTime;
  String date;
  String endTime;
  bool status;
  bool declined;
  bool canceled;
  bool expired;

  Appointment({
    this.date,
    this.id,
    this.canceled,
    this.declined,
    this.endTime,
    this.expired,
    this.startTime,
    this.status
  });
  factory Appointment.fromJson(dynamic json){
    return Appointment(
      id: json['id'] as int,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      expired: json['expired'] as bool,
      canceled: json['canceled'] as bool,
      declined: json['declined'] as bool,
      status: json['status'] as bool,
      date: json['date'] as String
    );
  }
}
class Booking{
  int id;
  String startTime;
  String date;
  String endTime;
  bool status;
  bool declined;
  bool canceled;
  bool expired;

  Booking({
    this.date,
    this.id,
    this.canceled,
    this.declined,
    this.endTime,
    this.expired,
    this.startTime,
    this.status
  });
  factory Booking.fromJson(dynamic json){
    return Booking(
        id: json['id'] as int,
        startTime: json['start_time'] as String,
        endTime: json['end_time'] as String,
        expired: json['expired'] as bool,
        canceled: json['canceled'] as bool,
        declined: json['declined'] as bool,
        status: json['status'] as bool,
        date: json['date'] as String
    );
  }
}

class Review{
  int id;
  String review;
  String guestName;
  String userName;

  Review({
    this.id,
    this.guestName,
    this.userName,
    this.review
});
  factory Review.fromJson(dynamic json){
    return Review(
      id: json['id'] as int,
      review: json['review'] as String,
      guestName: json['guest_name'] as String,
      userName: json['user_name'] as String
    );
  }
}

class VendorImage{
  int id;
  String imgLocation;

  VendorImage({
   this.id,
   this.imgLocation
});

  factory VendorImage.fromJson(dynamic json){
    return VendorImage(
      id: json['id'],
      imgLocation: json['image_location']
    );
  }
}

class VendorChats{
  int id;
  String sentTime;
  String message;
  String sender;
  bool readStatus;

  VendorChats({
   this.id,
    this.message,
    this.readStatus,
    this.sender,
    this.sentTime
});

  factory VendorChats.fromJson(dynamic json){
    return VendorChats(
      id: json['id'],
      message: json['message'],
      sender: json['sender'],
      readStatus: json['read_status'],
      sentTime: json['sent_time'],
    );
  }
}

class Rating{
  int rateVal;
  Rating({
   this.rateVal
});
}
class UserReview{
  String review;
  UserReview({
    this.review
});
}


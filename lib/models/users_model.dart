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


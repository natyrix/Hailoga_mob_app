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




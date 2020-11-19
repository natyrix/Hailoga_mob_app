import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/services/users_service.dart';
class DeleteImage extends StatefulWidget {
  final int imgId;

  const DeleteImage({Key key, this.imgId}) : super(key: key);
  @override
  _DeleteImageState createState() => _DeleteImageState();
}

class _DeleteImageState extends State<DeleteImage> {
  UsersService get service => GetIt.I<UsersService>();
  APIResponse<Message> _apiResponse;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 4,
      title: Text("Are you sure to delete this image?"),
      titleTextStyle: TextStyle(
        color: Colors.redAccent
      ),
      content: Builder(
        builder: (_){
          if(_isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          if(_apiResponse!=null){
            if(_apiResponse.error){
              return Center(child: Text(_apiResponse.errorMessage),);
            }
            return Center(child: Text(_apiResponse.data.message),);
          }
          return Container(
            child: Text(""),
          );
        },
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("No"),
        ),
        FlatButton(
          onPressed: () {

          },
          child: Text("Yes"),
        ),
      ],
    );
  }
}

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

  delImage() async{
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.deleteImg(widget.imgId);
    setState(() {
      _isLoading = false;
    });
    if(_apiResponse!=null){
      if(!_apiResponse.error){
        Future.delayed(Duration(milliseconds: 300),popDialog);
      }
    }
  }
  void popDialog(){
    Navigator.pop(context,1);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 4,
      title: Text("Are you sure to delete this image?"),
      titleTextStyle: TextStyle(
        color: Colors.redAccent,
        fontSize: 17,
        fontWeight: FontWeight.w600
      ),
      content: Container(
        child: Builder(
          builder: (_){
            if(_isLoading){
              return SizedBox(height:100,child: Center(child: CircularProgressIndicator()));
            }
            if(_apiResponse!=null){
              if(_apiResponse.error){
                return Text(_apiResponse.errorMessage);
              }
              return Text(_apiResponse.data.message);
            }
            return Text("");
          },
        ),
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
            delImage();
          },
          child: Text("Yes"),
        ),
      ],
    );
  }
}

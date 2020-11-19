import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/services/users_service.dart';
import 'package:image_picker/image_picker.dart';

class AddImage extends StatefulWidget {
  @override
  _AddImageState createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  int _refreshStat = 0;
  UsersService get service => GetIt.I<UsersService>();
  APIResponse<Message> _apiResponse;
  bool _isLoading = false;
  Future<File> file;
  String _status = '';
  String base64Image;
  File tmpFile;
  String errMessage = 'Error uploading image';

  chooseImage() {
    setState(() {
      file = ImagePicker.pickImage(
          source: ImageSource.gallery
      );
    });

  }

  Widget showImage(){
    return FutureBuilder(
      future: file,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot){
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          tmpFile = snapshot.data;
          base64Image = base64Encode(snapshot.data.readAsBytesSync());
          return Flexible(child: Image.file(snapshot.data, fit: BoxFit.fill,));
        }
        else if(snapshot.error != null){
          return const Text(
            "Error picking image",
            textAlign: TextAlign.center,
          );
        }
        else{
          return const Text(
            "No image selected"
          );
        }
      },
    );
  }

  startUpload() {
    if(tmpFile==null){
      setState(() {
        _status = "Please select an image";
      });
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    uploadImage(fileName);
  }
  uploadImage(fileName) async{
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.uploadImg(fileName, tmpFile);
    setState(() {
      _isLoading = false;
    });
    if(_apiResponse!=null){
      if(!_apiResponse.error){
        _refreshStat = 1;
        Future.delayed(Duration(seconds: 2), popDialog);
//        Navigator.pop(context,_refreshStat);
      }
    }
  }
  void popDialog(){
    Navigator.pop(
        context, _refreshStat
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 4,
      title: Text("upload an image"),
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
            padding: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OutlineButton(
                  onPressed: chooseImage,
                  child: Text("Choose Image"),
                ),
                SizedBox(height: 10,),
                showImage(),
                SizedBox(height: 20,),
                Text(
                  _status,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 16
                  ),
                )
              ],
            ),
          );
        },
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
        FlatButton(
          onPressed: () {
            startUpload();
          },
          child: Text("Upload"),
        ),
      ],
    );
  }
}
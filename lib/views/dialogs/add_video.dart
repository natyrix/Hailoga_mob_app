import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/services/users_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';


class AddVideo extends StatefulWidget {
  @override
  _AddVideoState createState() => _AddVideoState();
}

class _AddVideoState extends State<AddVideo> {

  UsersService get service => GetIt.I<UsersService>();
  APIResponse<Message> _apiResponse;
  bool _isLoading = false;
  Future<File> file;
  String _status = '';
  String base64Video;
  File tmpFile;
  String errMessage = 'Error uploading image';
  PickedFile _pickedFile;
  dynamic _pickedFileError;
  VideoPlayerController _controller;
  VideoPlayerController _toBeDisposed;
  String _retrieveDataError;
  final ImagePicker _picker = ImagePicker();

  Future<void> _disposeVideoController() async{
    if(_toBeDisposed != null){
      await _toBeDisposed.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }
  @override
  void dispose() {
    _disposeVideoController();
    super.dispose();
  }

  Future<void> _playVideo(PickedFile file) async{
    if(file!=null && mounted){
      await _disposeVideoController();
      _controller = VideoPlayerController.file(File(file.path));
      await _controller.setVolume(1.0);
      await _controller.initialize();
      await _controller.setLooping(false);
      await _controller.play();
      setState(() {});
    }
    else{
      setState(() {
        _status = "Please choose video";
      });
    }
  }


  Widget _previewVideo(){
    if(_controller == null){
      return const Text("You have not picked a video",textAlign: TextAlign.center,);
    }
    return Padding(
      padding: const EdgeInsets.all(10),
      child: AspectRatioVideo(_controller),
    );
  }

  void _chooseVideo(ImageSource source, {BuildContext context}) async{
    if(_controller != null){
      await _controller.setVolume(0.0);
    }
    final PickedFile file = await _picker.getVideo(
      source: source,
      maxDuration: const Duration(seconds: 10)
    );
    await _playVideo(file);
  }

  chooseVid() {
    setState(() {
      file = ImagePicker.pickVideo(
          source: ImageSource.gallery
      );
    });
  }

  Future<void> retirieveLostData() async{
    final LostData response = await _picker.getLostData();
    if(response.isEmpty){
      return;
    }
    if(response.file != null){
      if(response.type == RetrieveType.video){
        await _playVideo(response.file);
      }
      else{
        setState(() {
          _status = "Invalid video type";
        });
      }
    }
    else{
      _retrieveDataError = response.exception.code;
    }
  }

  Widget showVideo(){
    return FutureBuilder(
      future: retirieveLostData(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot){
        if(snapshot.connectionState == ConnectionState.done && snapshot.hasData){
          return _previewVideo();
        }
        else if(snapshot.error != null){
          return const Text(
            "Error picking image",
            textAlign: TextAlign.center,
          );
        }
        else{
          return const Text(
              "No video selected"
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 4,
      title: Text("upload a video, max size 50MB"),
      content: Builder(
        builder: (_){
          if(_isLoading){
            return SizedBox(height:100,child: Center(child: CircularProgressIndicator()));
          }
          if(_apiResponse!=null){
            if(_apiResponse.error){
              return SizedBox(child: Center(child: Text(_apiResponse.errorMessage),));
            }
            return SizedBox(child: Center(child: Text(_apiResponse.data.message),));
          }
          return Container(
            padding: EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                OutlineButton(
                  onPressed: (){
                    _chooseVideo(ImageSource.gallery);
                  },
                  child: Text("Choose Video"),
                ),
                SizedBox(height: 10,),
                showVideo(),
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

          },
          child: Text("Upload"),
        ),
      ],
    );
  }
}

class AspectRatioVideo extends StatefulWidget {
  AspectRatioVideo(this.controller);

  final VideoPlayerController controller;

  @override
  AspectRatioVideoState createState() => AspectRatioVideoState();
}

class AspectRatioVideoState extends State<AspectRatioVideo> {
  VideoPlayerController get controller => widget.controller;
  bool initialized = false;

  void _onVideoControllerUpdate() {
    if (!mounted) {
      return;
    }
    if (initialized != controller.value.initialized) {
      initialized = controller.value.initialized;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(_onVideoControllerUpdate);
  }

  @override
  void dispose() {
    controller.removeListener(_onVideoControllerUpdate);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (initialized) {
      return Center(
        child: AspectRatio(
          aspectRatio: controller.value?.aspectRatio,
          child: VideoPlayer(controller),
        ),
      );
    } else {
      return Container();
    }
  }
}

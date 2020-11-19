import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/users_model.dart';
import 'package:hailoga/services/helpers.dart';
import 'package:hailoga/services/users_service.dart';
import 'package:video_player/video_player.dart';

class UserVideos extends StatefulWidget {
  @override
  _UserVideosState createState() => _UserVideosState();
}

class _UserVideosState extends State<UserVideos> {
  UsersService get service => GetIt.I<UsersService>();
  APIResponse<List<VideoGallery>> _apiResponse;
  bool _isLoading = false;
  List _controllers = <VideoPlayerController>[];
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;
  List _initializeVideoPlayerFutures = <Future<void>>[];

  @override
  void initState() {
    super.initState();
    _fetchVds();

  }
  @override
  void dispose(){
    for(var v in _controllers){
      v.dispose();
    }
//    _controllers.dispose();
    super.dispose();
  }

  _fetchVds() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getVideos();
    setState(() {
      _isLoading = false;
    });
    if(_apiResponse!=null){
      if(!_apiResponse.error){
        for(var vidlcn in _apiResponse.data){
          _controller = VideoPlayerController.network("${APIAddress.api}${vidlcn.videoLocation}");
          _initializeVideoPlayerFuture = _controller.initialize();
          _controller.setLooping(false);
          _controller.setVolume(1.0);
          _controllers.add(_controller);
          _initializeVideoPlayerFutures.add(_initializeVideoPlayerFuture);
        }
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (_){
          if(_isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          if(_apiResponse.error){
            return Center(child: Text(_apiResponse.errorMessage),);
          }
          return ListView.separated(
              itemBuilder: (_, index){
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.all(10),

                  child: Column(
                    children:[
                      FutureBuilder(
                        future: _initializeVideoPlayerFutures[index],
                        builder: (context, snapshot){
                          if(snapshot.connectionState == ConnectionState.done){
                            return Center(
                              child: AspectRatio(
                                aspectRatio: _controllers[index].value.aspectRatio,
                                child: VideoPlayer(_controllers[index]),
                              ),
                            );
                          }
                          else{
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                      Align(
                        alignment: Alignment(0,-0.9),
                        child: FloatingActionButton(
                          onPressed: () {
                            setState(() {
                              if (_controllers[index].value.isPlaying) {
                                _controllers[index].pause();
                              } else {
                                _controllers[index].play();
                              }
                            });
                          },
                          child:
                          Icon(_controllers[index].value.isPlaying ? Icons.pause : Icons.play_arrow),
                        ),
                      )
                    ]
                  ),
                );
              },
              separatorBuilder: (_,__)=>Divider(height: 2,color: Colors.transparent,),
              itemCount: _apiResponse.data.length);
        },
      )
    );
  }
}

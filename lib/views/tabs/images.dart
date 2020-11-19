import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/users_model.dart';
import 'package:hailoga/services/helpers.dart';
import 'package:hailoga/services/users_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hailoga/views/dialogs/add_image.dart';


class UserImages extends StatefulWidget {
  @override
  _UserImagesState createState() => _UserImagesState();
}

class _UserImagesState extends State<UserImages> {
  UsersService get service => GetIt.I<UsersService>();
  APIResponse<List<ImageGallery>> _apiResponse;
  bool _isLoading = false;
  Future<bool> _willPopCallBack() async{
    return Future.value(true);
  }

  _displayAddImageDialog(BuildContext context) async{
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context){
          return WillPopScope(
            child: AddImage(),
            onWillPop: _willPopCallBack,
          );
        }
    );
//    if(data==1){
//      _fetchImgs();
//    }
  }


  @override
  void initState() {
    super.initState();
    _fetchImgs();
  }

  _fetchImgs() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getImages();
    setState(() {
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
                return GestureDetector(
                  onLongPress: (){
                    print("Long pressed");
                  },
                  child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Card(
                    elevation: 8,
                    child: Container(
                      width: screenWidth-2,
                      height: 300,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.contain,
                              image: CachedNetworkImageProvider("${APIAddress.api}${_apiResponse.data[index].imageLocation}")
                          )
                      ),
                    ),
                  ),
                ),
                );
              },
              separatorBuilder: (_,__)=>Divider(height: 2,color: Colors.transparent,),
              itemCount: _apiResponse.data.length);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: (){
          _displayAddImageDialog(context);
      },),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/users_model.dart';
import 'package:hailoga/navigation_bloc/navigation_bloc.dart';
import 'package:hailoga/services/helpers.dart';
import 'package:hailoga/services/users_service.dart';
import 'package:hailoga/views/pages/vendor_user_chat.dart';
class UsersChats extends StatefulWidget with NavigationStates{
  @override
  _UsersChatsState createState() => _UsersChatsState();
}

class _UsersChatsState extends State<UsersChats> {

  UsersService get service => GetIt.I<UsersService>();
  APIResponse<List<Chats>> _apiResponse;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchChts();
  }

  _fetchChts() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getChats();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Chats"),),
        actions: [
          IconButton(
            icon: Icon(Icons.redo),
            onPressed: (){
              _fetchChts();
            },
          ),
        ],
      ),
      body: Builder(
        builder: (_){
          if(_isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          if(_apiResponse.error){
            return Center(child: Text(_apiResponse.errorMessage),);
          }
          return ListView.separated(
              padding: const EdgeInsets.only(top: 35,left: 3),
              itemBuilder: (_, index){
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=>UsersVendorChat(vendor: _apiResponse.data[index].vendor,))
                      );
                    },
                    child: Card(
                      elevation: 3,
                      color: (_apiResponse.data[index].sender == "Vendor")?(!_apiResponse.data[index].readStatus)?const Color.fromRGBO(225, 227, 226, 0)
                          :Colors.white
                          :Colors.white,
                      child: Row(
//                      crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 30.0,
                            backgroundImage: CachedNetworkImageProvider("${APIAddress.api}${_apiResponse.data[index].vendor.logo}"),
                          ),
                          SizedBox(width: 10,),
                          Flexible(
                            child: SizedBox(
                              height: 70,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    '${_apiResponse.data[index].vendor.name}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 22
                                    ),
                                  ),
                                  Text(
                                    '${_apiResponse.data[index].message}',
                                    style: TextStyle(
                                        color: Colors.blueGrey,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15
                                    ),
                                  ),
                                  (_apiResponse.data[index].sender=="Users")?
                                    (_apiResponse.data[index].readStatus)?
                                      Align(
                                        alignment: Alignment(-0.9, 0),
                                        child: Icon(Icons.done_all,size: 14,color: Colors.grey,),
                                      ):
                                      Align(
                                        alignment: Alignment(-0.9, 0),
                                        child: Icon(Icons.done,size: 14,color: Colors.grey,),
                                      )
                                    :
                                    Text("")
                                ],
                              ),
                            ),
                          ),
                          Text(
                            '${humanizedDate(DateTime.parse(_apiResponse.data[index].sentTime))}',
                            style: TextStyle(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w500,
                                fontSize: 15
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              separatorBuilder: (_,__)=>Divider(height: 3,color: Colors.transparent,),
              itemCount: _apiResponse.data.length);
        },
      ),
    );
  }
  String humanizedDate(DateTime str){
    return formatDate(str, [M, ',', dd, ' ', yyyy, ' at ', hh, ':', mm]);
  }
}

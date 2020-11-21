import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/users_model.dart';
import 'package:hailoga/navigation_bloc/navigation_bloc.dart';
import 'package:hailoga/services/users_service.dart';

class UserNotifications extends StatefulWidget with NavigationStates{
  @override
  _UserNotificationsState createState() => _UserNotificationsState();
}

class _UserNotificationsState extends State<UserNotifications> {

  UsersService get service => GetIt.I<UsersService>();
  APIResponse<List<Notifications>> _apiResponse;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchNtfs();
  }

  _fetchNtfs() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getNotifications();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Notifications"),),
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
            padding: const EdgeInsets.only(top: 10),
            itemBuilder: (_, index){
              return Padding(
                padding: const EdgeInsets.all(6),
                child: Card(
                  elevation: 2,
                  color: _apiResponse.data[index].readStatus?Colors.white:const Color.fromRGBO(225, 227, 226, 0),
                  child: Column(
                    children: [
                      ListTile(
//                        tileColor: _apiResponse.data[index].readStatus?Colors.white:const Color.fromRGBO(2, 222, 22, 0),
                        title: Text('${_apiResponse.data[index].title}'),
                        subtitle: Text('${humanizedDate(DateTime.parse(_apiResponse.data[index].notificationDate))}'),
                      )
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_,__)=>Divider(height: 2,color: Colors.transparent,),
            itemCount: _apiResponse.data.length);
        },
      ),
    );
  }
  String humanizedDate(DateTime str){
    return formatDate(str, [M, ',', dd, ' ', yyyy]);
  }
}

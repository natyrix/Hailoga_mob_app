import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/users_model.dart';
import 'package:hailoga/services/users_service.dart';
import 'package:hailoga/views/sidebar/side_bar_layout.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UsersService get service => GetIt.I<UsersService>();
  APIResponse<UsersModel> _apiResponse;
  bool _isLoading = false;

  @override
  void initState(){
    _fetchUserData();
    super.initState();
  }

  _fetchUserData() async{
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getUsers();
    Navigator.removeRouteBelow(context, ModalRoute.of(context));
    Navigator.removeRouteBelow(context, ModalRoute.of(context));

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (_){
          if(_isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          if(_apiResponse!= null){
            if(_apiResponse.error){
              return Container(child: Center(
                child: Text(_apiResponse.errorMessage,
                  style: TextStyle(color: Colors.red),),),);
            }
            return SideBarLayOut(users: _apiResponse.data,);
          }
          return Container(
            child: Text('Something went wrong'),
          );

        },
      ),
    );
  }
}
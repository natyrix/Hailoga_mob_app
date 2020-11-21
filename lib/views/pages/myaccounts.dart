import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/users_model.dart';
import 'package:hailoga/navigation_bloc/navigation_bloc.dart';
import 'package:hailoga/services/users_service.dart';
import 'package:hailoga/views/tabs/account_info.dart';
import 'package:hailoga/views/tabs/login_info.dart';

class MyAccountsPage extends StatefulWidget with NavigationStates{
  @override
  _MyAccountsPageState createState() => _MyAccountsPageState();
}

class _MyAccountsPageState extends State<MyAccountsPage> {
  int _currentIndex = 0;

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
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("My Account"),),
      ),
      body: Builder(
        builder: (_){
          if(_isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          if(_apiResponse!=null){
            if(_apiResponse.error){
              return Container(child: Center(
                child: Text(_apiResponse.errorMessage,
                  style: TextStyle(color: Colors.red),),),);
            }
            else{
              return SafeArea(
                top: false,
                child: IndexedStack(
                  index: _currentIndex,
                  children: [
                    AccountInfo(userModel: _apiResponse.data,),
                    LoginInfo()
                  ],
                ),
              );
            }
          }
          return Center(child: Text("Something went wrong, please try again"));
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
//        fixedColor: Colors.grey,
        unselectedItemColor: Colors.blueGrey,
        selectedItemColor: Colors.white,
        backgroundColor: Color(0xFF262AAA),
        onTap: (int index){
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.image),
              label: "Profile Info",
              backgroundColor: Color(0xFF262AAA)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_collection),
              label: "Login Info",
              backgroundColor: Color(0xFF262AAA)
          ),
        ],
      ),
    );
  }
}
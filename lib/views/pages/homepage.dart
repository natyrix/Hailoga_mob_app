import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/users_model.dart';
import 'package:hailoga/navigation_bloc/navigation_bloc.dart';
import 'package:hailoga/services/helpers.dart';
import 'package:hailoga/services/users_service.dart';
import 'package:hailoga/views/pages/chats.dart';
import 'package:hailoga/views/pages/notifications.dart';
import 'package:hailoga/views/pages/vendor_card.dart';

class HomePage extends StatefulWidget with NavigationStates{
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UsersService get service => GetIt.I<UsersService>();
  APIResponse<Counts> _apiResponse;
  bool _isLoading = false;
  String _timeUntilWedding;

  Timer _timer;

  _startTimer(){
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _timeUntilWedding = _timeLeft(DateTime.parse(GetUser.userModel.weddingDate));
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _home();
    _startTimer();
  }
  @override
  void dispose(){
    _timer.cancel();
    super.dispose();
  }

  _home() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.home();
    setState(() {
      _isLoading = false;
    });
  }

  String _timeLeft(DateTime endTime){
    Duration _timeUntil = endTime.difference(DateTime.now());
    int _daysUntil = _timeUntil.inDays;
    int _hoursUntil = _timeUntil.inHours - (_daysUntil*24);
    int _minUntil = _timeUntil.inMinutes - (_daysUntil*24*60)-(_hoursUntil*60);
    int _secUntil = _timeUntil.inSeconds - (_daysUntil*24*60*60)-(_hoursUntil*60*60)-(_minUntil*60);
    if(_daysUntil>0){
      return "$_daysUntil days\n $_hoursUntil hours\n $_minUntil mins\n $_secUntil secs";
    }
    else if(_hoursUntil>0){
      return "$_hoursUntil hours\n $_minUntil minus\n $_secUntil secs";
    }
    else if(_minUntil>0){
      return "$_minUntil mins\n $_secUntil secs";
    }
    else if(_secUntil>0){
      return "$_secUntil secs";
    }
    else{
      return "error while calculating count down";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Home")),
        actions: [
          IconButton(
            icon: (_apiResponse!=null)?
            (!_apiResponse.error)?
            (_apiResponse.data.chatCunt>0)?
            Icon(Icons.chat_bubble,color: Colors.red,)
                :Icon(Icons.chat_bubble)
                :Icon(Icons.chat_bubble)
                :Icon(Icons.chat_bubble),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context)=>UsersChats()),
              );
            },
          ),
          IconButton(
            icon: (_apiResponse!=null)?
            (!_apiResponse.error)?
            (_apiResponse.data.notCount>0)?
            Icon(Icons.notifications,color: Colors.red,)
                :Icon(Icons.notifications)
                :Icon(Icons.notifications)
                :Icon(Icons.notifications),
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context)=>UserNotifications()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.redo),
            onPressed: (){
              _home();
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
          return ListView(
            children: [
              Column(
                children: [
                  Text(
                    _timeUntilWedding??"Loading...",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Center(
                child: Text("Random Vendor",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black
                  ),
                ),
              ),
              VendorCard(vendor: _apiResponse.data.randVendor,ratingVal: _apiResponse.data.ratingCount,)
            ],
          );
        },
      ),
    );
  }
}
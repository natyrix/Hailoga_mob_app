import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/services/login_service.dart';
import 'package:hailoga/services/users_service.dart';
import 'package:hailoga/services/vendor_service.dart';
import 'package:hailoga/views/home.dart';
import 'package:hailoga/views/loader.dart';

void setupLocator(){
  GetIt.I.registerLazySingleton(()=>LoginService());
  GetIt.I.registerLazySingleton(()=>UsersService());
  GetIt.I.registerLazySingleton(()=>VendorsService());
}

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
//        primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Loader(),
      routes: {
        "/home":(_)=> Home(),
      },
    );
  }
}


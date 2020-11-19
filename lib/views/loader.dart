import 'package:flutter/material.dart';
import 'package:hailoga/views/login.dart';
import 'package:hailoga/views/register.dart';
class Loader extends StatefulWidget {
  @override
  _LoaderState createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hailoga'),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Container(
            
        )
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Login'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Register'
          )
        ],
        backgroundColor: Colors.lightBlueAccent,
        selectedItemColor: Colors.orange,
        onTap: (index)=>{
          if(index==0){
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context)=>Login()
              )
            )
          }
          else{
            Navigator.push(
              context, 
              MaterialPageRoute(
                builder: (context)=>Register()
              )
            )
          }
        },
      )
    );
  }
}
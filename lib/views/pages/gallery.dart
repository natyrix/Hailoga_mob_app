import 'package:flutter/material.dart';
import 'package:hailoga/navigation_bloc/navigation_bloc.dart';
import 'package:hailoga/views/tabs/images.dart';
import 'package:hailoga/views/tabs/videos.dart';

class Gallery extends StatefulWidget with NavigationStates{
  @override
  _GalleryState createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {

  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Gallery")),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: (){
              Scaffold.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.white,
                content: Text("Double tap on video or image to delete", style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),),
              ));
            },
          )
        ],
      ),
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _currentIndex,
          children: [
            UserImages(),
            UserVideos()
          ],
        ),
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
              label: "Images",
              backgroundColor: Color(0xFF262AAA)
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.video_collection),
              label: "Videos",
              backgroundColor: Color(0xFF262AAA)
          ),
        ],
      ),
    );
  }
}

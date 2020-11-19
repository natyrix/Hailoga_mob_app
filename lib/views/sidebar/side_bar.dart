import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hailoga/models/users_model.dart';
import 'package:hailoga/navigation_bloc/navigation_bloc.dart';
import 'package:hailoga/views//sidebar/menu_item.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter/material.dart';

class SideBar extends StatefulWidget {
  final UsersModel users;

  const SideBar({Key key, this.users}) : super(key: key);
  
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> with SingleTickerProviderStateMixin<SideBar>{
  AnimationController _animationController;
  StreamController<bool> isSideBarOpenedSideBarController;
  Stream<bool> isSideBarOpenedStream;
  StreamSink<bool> isSideBarOpenedSink;
  final _animationDuration = const Duration(milliseconds: 500);


  void onIconPressed(){
    final animationStatus = _animationController.status;
    final isAnimationCompleted = animationStatus == AnimationStatus.completed;

    if(isAnimationCompleted){
      isSideBarOpenedSink.add(false);
      _animationController.reverse();
    }
    else{
      isSideBarOpenedSink.add(true);
      _animationController.forward();
    }
  }

  @override
  void initState(){
    super.initState();
    _animationController = AnimationController(vsync: this,duration: _animationDuration);
    isSideBarOpenedSideBarController = PublishSubject<bool>();
    isSideBarOpenedStream = isSideBarOpenedSideBarController.stream;
    isSideBarOpenedSink = isSideBarOpenedSideBarController.sink;
  }

  @override
  void dispose(){
    _animationController.dispose();
    isSideBarOpenedSideBarController.close();
    isSideBarOpenedSink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return StreamBuilder<bool>(
      initialData: false,
      stream: isSideBarOpenedStream,
      builder: (context, isSideBarOpenedAsync){
        return AnimatedPositioned(
          duration: _animationDuration,
          top:0,
          bottom: 0,
          left: isSideBarOpenedAsync.data ? 0 : -screenWidth,
          right: isSideBarOpenedAsync.data ?0:(screenWidth-45),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Container(
//                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: const Color(0xFF262AAA),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 60,
                         ),
                        ListTile(
                          title: Text("${widget.users.firstName} & ${widget.users.fianceFirstName}", style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w800),),
                          subtitle: Text(
                            widget.users.email,
                            style: TextStyle(
                                color: Color(0xFF18B5FD), fontSize: 15
                            ),
                          ),
                          leading: CircleAvatar(
                            child: Icon(
                              Icons.perm_identity,
                              color: Colors.white,
                            ),
                            radius: 40,
                          ),
                        ),
                        Divider(
                          height: 60,
                          thickness: 0.5,
                          color: Colors.white,
                          indent: 16,
                          endIndent: 16,
                        ),
                        MenuItem(
                          icon: Icons.horizontal_split,
                          title: "Vendors",
                          onTap: (){
                            onIconPressed();
                            BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.VendorsClickedEvent);
                          },
                        ),
                        MenuItem(
                          icon: Icons.image,
                          title: "Gallery",
                          onTap: (){
                            onIconPressed();
                            BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.GalleryClickedEvent);
                          },
                        ),
                        MenuItem(
                          icon: Icons.person,
                          title: "My Account",
                          onTap: (){
                            onIconPressed();
                            BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.MyAccountClickedEvent);
                          },
                        ),
                        MenuItem(
                          icon: Icons.shopping_basket,
                          title: "My Orders",
                          onTap: (){
                            onIconPressed();
                            BlocProvider.of<NavigationBloc>(context).add(NavigationEvents.MyOrdersClickedEvent);
                          },
                        ),
                        MenuItem(
                          icon: Icons.card_giftcard,
                          title: "Wishlist",
                        ),
                        Divider(
                          height: 64,
                          thickness: 0.5,
                          color: Colors.white,
                          indent: 16,
                          endIndent: 16,
                        ),
                        MenuItem(
                          icon: Icons.settings,
                          title: "Settings",
                        ),
                        MenuItem(
                          icon: Icons.exit_to_app,
                          title: "Logout",
                        ),
                      ],
                    ),
                  )
              ),
              Align(
                alignment: Alignment(0,-0.9 ),
                child: GestureDetector(
                  onTap: ()=>{
                    onIconPressed()
                  },
                  child: ClipPath(
                    clipper: CustomMenuClipper(),
                    child: Container(
                      width: 35,
                      height: 110,
                      color: Color(0xFF262AAA),
                      alignment: Alignment.centerLeft,
                      child: AnimatedIcon(
                        progress: _animationController.view,
                        icon: AnimatedIcons.menu_close,
                        color: Color(0xFF18B5FD),
                        size: 25,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CustomMenuClipper extends CustomClipper<Path>{
  @override
  Path getClip(Size size) {
    Paint paint = Paint();
    paint.color = Colors.white;
    final width = size.width;
    final height = size.height;
    Path path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(0, 8, 10, 16);
    path.quadraticBezierTo(width-1, height/2-20, width, height/2);
    path.quadraticBezierTo(width+1, height/2+20, 10, height-16);
    path.quadraticBezierTo(0, height-8, 0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }

}
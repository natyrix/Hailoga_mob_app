import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hailoga/models/users_model.dart';
import 'package:hailoga/navigation_bloc/navigation_bloc.dart';
import 'side_bar.dart';

class SideBarLayOut extends StatelessWidget {
  final UsersModel users;

  const SideBarLayOut({Key key, this.users}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<NavigationBloc>(
        create: (context)=>NavigationBloc(),
        child: Stack(
          children: <Widget>[
            BlocBuilder<NavigationBloc, NavigationStates>(
              builder: (context, navigationState){
                return navigationState as Widget;
              },
            ),
            SideBar(users: users,)
          ],
        ),
      ),
    );
  }
}
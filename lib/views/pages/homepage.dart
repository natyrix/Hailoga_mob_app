import 'package:flutter/material.dart';
import 'package:hailoga/navigation_bloc/navigation_bloc.dart';

class HomePage extends StatelessWidget with NavigationStates{
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('HomePage', style: TextStyle(fontWeight: FontWeight.w900,fontSize: 28),),
    );
  }
}
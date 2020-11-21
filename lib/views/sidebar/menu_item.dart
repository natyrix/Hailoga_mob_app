import 'package:flutter/material.dart';
class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final Function onTap;

  const MenuItem({Key key, this.icon, this.title, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: Colors.cyan,
            ),
            SizedBox(width: 5,),
            Text(title,style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 20,
              color: Colors.white
            ),)
          ],
        ),
      ),
    );
  }
}

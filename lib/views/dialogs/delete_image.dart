import 'package:flutter/material.dart';
class DeleteImage extends StatefulWidget {
  @override
  _DeleteImageState createState() => _DeleteImageState();
}

class _DeleteImageState extends State<DeleteImage> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 4,
      title: Text("Are you sure to delete this image?"),
      titleTextStyle: TextStyle(
        color: Colors.redAccent
      ),
      content: Container(
        child: Text(""),
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("No"),
        ),
        FlatButton(
          onPressed: () {

          },
          child: Text("Yes"),
        ),
      ],
    );
  }
}

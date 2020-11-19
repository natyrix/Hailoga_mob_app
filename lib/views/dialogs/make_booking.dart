import 'package:flutter/material.dart';
import 'package:hailoga/models/vendors_model.dart';

class MakeBooking extends StatefulWidget {
  final VendorsModel vendor;

  const MakeBooking({Key key, this.vendor}) : super(key: key);
  @override
  _MakeBookingState createState() => _MakeBookingState();
}

class _MakeBookingState extends State<MakeBooking> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 4,
      title: Text("Make booking with ${widget.vendor.name}"),
    );
  }
}

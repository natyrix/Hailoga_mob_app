import 'package:flutter/material.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/views/dialogs/make_appointment.dart';
import 'package:hailoga/views/dialogs/make_booking.dart';
import 'package:hailoga/views/dialogs/rate_vendor.dart';
import 'package:hailoga/views/dialogs/review_vendor.dart';
import 'package:hailoga/views/tabs/vendor_appt.dart';
import 'package:hailoga/views/tabs/vendor_booking.dart';
import 'package:hailoga/views/tabs/vendor_chats.dart';
import 'package:hailoga/views/tabs/vendor_gallery.dart';
import 'package:hailoga/views/tabs/vendor_home.dart';
import 'package:hailoga/views/tabs/vendor_pricing.dart';
import 'package:hailoga/views/tabs/vendor_reviews.dart';

class Vendor extends StatefulWidget {
  final VendorsModel vendor;
  final double ratingVal;

  const Vendor({Key key, this.vendor, this.ratingVal}) : super(key: key);
  @override
  _VendorState createState() => _VendorState();
}

class _VendorState extends State<Vendor> {
  int _currentIndex = 0;
  Future<bool> _willPopCallBack() async{
    return Future.value(true);
  }
  _displayRateDialog(BuildContext context, index) async{
    List dialogs = <Widget>[
      RateVendor(vendor: widget.vendor,),
      ReviewVendor(vendor: widget.vendor,),
      MakeAppointment(vendor: widget.vendor,),
      MakeBooking(vendor: widget.vendor,)
    ];
    return showDialog(
//      barrierColor: Colors.white.withOpacity(0),
      barrierDismissible: false,
      context: context,
      builder: (context){
        return WillPopScope(
          // ignore: missing_return
          onWillPop: _willPopCallBack,
          child: dialogs[index]
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vendor.name),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: GestureDetector(
              onTap: (){
//                Navigator.of(context).push(
//                  PageRouteBuilder(
//                    pageBuilder: (context, _, __)=>RateVendor(vendor: widget.vendor,),
//                    opaque: false
//                  ),
//                );
              },
              child: Icon(
                Icons.message,
                size: 26,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: PopupMenuButton<Choices>(
              onSelected: (Choices value){
                _displayRateDialog(context, value.index);
              },
              itemBuilder: (BuildContext context){
                return choices.map((Choices ch){
                  return PopupMenuItem<Choices>(
                    value: ch,
                    child: Text(ch.title),
                  );
                }).toList();
              },
            )
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: _currentIndex,
          children: [
            VendorHome(vendor: widget.vendor,ratingVal: widget.ratingVal,),
            VendorPricing(vendor: widget.vendor,),
            VendorAppt(vendor: widget.vendor,),
            VendorBooking(vendor: widget.vendor,),
            VendorReviews(vendor: widget.vendor,),
            VendorGallery(vendor: widget.vendor,),
            VendorChat(vendor: widget.vendor,),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        fixedColor: Colors.grey,
        backgroundColor: Color(0xFF262AAA),
        onTap: (int index){
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: Color(0xFF262AAA)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money),
            label: "Pricing",
            backgroundColor: Color(0xFF262AAA)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.meeting_room),
            label: "Appointments",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.meeting_room_outlined),
            label: "Bookings",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.comment),
            label: "Reviews",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.image),
            label: "Gallery",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Messages",
          ),
        ],
      ),
    );
  }
}
class Choices {
  final String title;
  final IconData icon;
  final int index;

  const Choices({
    this.title,
    this.icon,
    this.index
  });
}

const List<Choices> choices = const <Choices>[
  const Choices(title:"Rate", icon: Icons.star, index: 0),
  const Choices(title:"Review", icon: Icons.comment, index: 1),
  const Choices(title:"Make Appointment", icon: Icons.meeting_room_outlined, index: 2),
  const Choices(title:"Make Booking", icon: Icons.meeting_room, index: 3),
];

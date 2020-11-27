import 'package:flutter/material.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hailoga/services/helpers.dart';


class VendorHome extends StatefulWidget {
  final VendorsModel vendor;
  final double ratingVal;

  const VendorHome({Key key, this.vendor, this.ratingVal}) : super(key: key);
  @override
  _VendorState createState() => _VendorState();
}

class _VendorState extends State<VendorHome> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: screenWidth,
              height: 300,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage("${APIAddress.api}"+widget.vendor.logo)
                  )
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.mail,size: 17,),
                      Text("Email: "+widget.vendor.email)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.phone,size: 17,),
                      Text("Phone Number: "+widget.vendor.phoneNumber)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.category,size: 17,),
                      Text("Category: "+widget.vendor.category.name)
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.place,size: 17,),
                      Text("Location: "+widget.vendor.address)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      RatingBarIndicator(
                        rating: widget.ratingVal,
                        itemBuilder: (context, index) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemCount: 5,
                        itemSize: 35.0,
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      );
//    );
  }
}



import 'package:flutter/material.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hailoga/services/helpers.dart';
import 'package:hailoga/views/vendor.dart';

class VendorCard extends StatelessWidget {
  final VendorsModel vendor;
  final double ratingVal;

  const VendorCard({Key key, this.vendor, this.ratingVal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context)=> Vendor(ratingVal: ratingVal,vendor: vendor,)
          )
        );
      },
      child: Card(
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.all(6),
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.arrow_drop_down_circle),
                title: Text(vendor.name),
                subtitle: Text(
                  vendor.email,
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
                child: Row(
                  children: [
                    SizedBox(
                      child: Image.network("${APIAddress.api}"+vendor.logo),
                      height: 300,
                      width: 250,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10,5,0,0),
                child: Row(
                  children: [
                    Text("Category: "+vendor.category.name),],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10,5,0,0),
                child: Row(
                  children: [
                    Text("Address: "+vendor.address),],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10,5,0,0),
                child: Row(
                  children: [
                    Text("Phone number: "+vendor.phoneNumber),],
                ),
              ),
              ratingVal != null?
              RatingBarIndicator(
                rating: ratingVal,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 35.0,
              ):
              RatingBarIndicator(
                rating:0,
                itemBuilder: (context, index) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                itemCount: 5,
                itemSize: 35.0,
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context)=> Vendor(ratingVal: ratingVal,vendor: vendor,)
                          )
                      );
                    },
                    child: const Text('More Info'),
                  )
                ],
              ),
//            Image.asset('assets/card-sample-image.jpg'),
            ],
          ),
        ),
      ),
    );
  }
}

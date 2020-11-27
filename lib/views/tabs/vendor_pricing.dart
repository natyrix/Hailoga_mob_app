import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/services/vendor_service.dart';
import 'package:humanize/humanize.dart' as humanize;

class VendorPricing extends StatefulWidget{
  final VendorsModel vendor;

  const VendorPricing({Key key, this.vendor}) : super(key: key);

  @override
  _VendorPricingState createState() => _VendorPricingState();
}

class _VendorPricingState extends State<VendorPricing> {
  VendorsService get service => GetIt.I<VendorsService>();
  APIResponse<List<Pricing>> _apiResponse;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPricing();
  }

  _fetchPricing() async{
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getPricing(widget.vendor.id);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (_){
          if(_isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          if(_apiResponse.error){
            return Center(child: Text(_apiResponse.errorMessage),);
          }
          return ListView.separated(
            itemBuilder: (_, index){
              return Card(
                elevation: 8,
                child: Column(
                  children: [
                    ListTile(
                      title: Text("Price: ${humanize.intComma(_apiResponse.data[index].value.toInt())} ETB"),
                    ),
                    ListTile(
                      title: Text("Title: "+_apiResponse.data[index].title),
                      subtitle: Text(_apiResponse.data[index].detail),

                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (_,__)=>Divider(height: 7,color: Colors.white70,),
            itemCount: _apiResponse.data.length);
        },
      )
    );
  }
}

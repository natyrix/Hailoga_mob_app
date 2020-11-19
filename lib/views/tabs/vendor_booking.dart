import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/services/vendor_service.dart';
import 'package:date_format/date_format.dart';

class VendorBooking extends StatefulWidget {
  final VendorsModel vendor;

  const VendorBooking({Key key, this.vendor}) : super(key: key);
  @override
  _VendorBookingState createState() => _VendorBookingState();
}

class _VendorBookingState extends State<VendorBooking> {
  VendorsService get service => GetIt.I<VendorsService>();
  APIResponse<List<Booking>> _apiResponse;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchBkgs();
  }

  _fetchBkgs() async{
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getBkgs(widget.vendor.id);
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
                        tileColor: Color(0xFFcbd4c9),
                        title: Text("Booking Date: "
                            "${humanizedDate(DateTime.parse(_apiResponse.data[index].date))}"),
                      ),
                      ListTile(
                        title: Text("From ${_apiResponse.data[index].startTime} to ${_apiResponse.data[index].endTime}"),
                        subtitle: _apiResponse.data[index].expired?Text("Expired",style: TextStyle(color: Colors.red)): _apiResponse.data[index].declined?
                        Text("Declined",style: TextStyle(color: Colors.red),):_apiResponse.data[index].status?
                        Text("Approved", style: TextStyle(color: Colors.green),):Text("Not Approved Yet", style: TextStyle(color: Colors.red),),

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
  String humanizedDate(DateTime str){
    return formatDate(str, [M, ',', dd, ' ', yyyy]);
  }
}

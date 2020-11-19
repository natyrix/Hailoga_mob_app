import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/services/helpers.dart';
import 'package:hailoga/services/vendor_service.dart';
class VendorReviews extends StatefulWidget {
  final VendorsModel vendor;

  const VendorReviews({Key key, this.vendor}) : super(key: key);
  @override
  _VendorReviews createState() => _VendorReviews();
}

class _VendorReviews extends State<VendorReviews> {
  VendorsService get service => GetIt.I<VendorsService>();
  APIResponse<List<Review>> _apiResponse;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchRvws();
  }

  _fetchRvws() async{
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getReviews(widget.vendor.id);
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
                        contentPadding: EdgeInsets.all(10),
//                        tileColor: Color(0xFFcbd4c9),
                        title: Text("Reviewed By: ${_apiResponse.data[index].guestName == null?
                        (_apiResponse.data[index].userName == GetName.name? 'You.':_apiResponse.data[index].userName)
                            :_apiResponse.data[index].guestName}"),
                        subtitle: Text(_apiResponse.data[index].review),
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

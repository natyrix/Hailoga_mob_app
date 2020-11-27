import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/services/vendor_service.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';


class RateVendor extends StatefulWidget {
  final VendorsModel vendor;

  const RateVendor({Key key, this.vendor}) : super(key: key);
  @override
  _RateVendorState createState() => _RateVendorState();
}

class _RateVendorState extends State<RateVendor> {
  VendorsService get service => GetIt.I<VendorsService>();
  APIResponse<Rating> _apiResponse;
  APIResponse<Message> _rateResponse;
  bool _isLoading = false;
  double _rateVal = 0;
  String _message = '';

  @override
  void initState(){
    super.initState();
    _fetchRating();
  }
  _fetchRating() async{
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getRate(widget.vendor.id);
    setState(() {
      _isLoading = false;
    });
  }

  _submitRating() async{
    if(_rateVal!=0 && _rateVal!=_apiResponse.data.rateVal){
      setState(() {
        _isLoading = true;
      });
      _rateResponse = await service.rateVendor(_rateVal, widget.vendor.id);
      setState(() {
        _isLoading = false;
      });
      if(_rateResponse!=null){
        if(_rateResponse.error){
          setState(() {
            _message = _rateResponse.errorMessage;
          });
        }
        else{
          setState(() {
            _message = _rateResponse.data.message;
          });
          Future.delayed(Duration(seconds: 1), Navigator.of(context).pop);
//          Navigator.of(context).pop();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 4,
      title: Text("Rate ${widget.vendor.name}"),
      content: Builder(
        builder: (_){
          if(_isLoading){
            return SizedBox(height:100,child: Center(child: CircularProgressIndicator()));
          }
          if(_apiResponse.error){
            return Text(_apiResponse.errorMessage);
          }
          if(_message.length!=0){
            return Text(_message);
          }
          return RatingBar(
                initialRating: _apiResponse.data.rateVal.toDouble(),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                itemBuilder: (context, _)=>Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating){
                  setState(() {
                    _rateVal = rating;
                  });
                },
              );
        },
      ),
      actions: [
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),
        FlatButton(
          onPressed: () {
//            Navigator.of(context).pop();
          _submitRating();
          },
          child: _apiResponse!=null?_apiResponse.data.rateVal==0?Text("Ok"):Text("Update"):Text("Ok"),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/services/vendor_service.dart';
class ReviewVendor extends StatefulWidget {
  final VendorsModel vendor;

  const ReviewVendor({Key key, this.vendor}) : super(key: key);
  @override
  _ReviewVendorState createState() => _ReviewVendorState();
}

class _ReviewVendorState extends State<ReviewVendor> {
  VendorsService get service => GetIt.I<VendorsService>();
  TextEditingController reviewController = TextEditingController();
  APIResponse<UserReview> _apiResponse;
  APIResponse<Message> _reviewResponse;
  bool _isLoading = false;
  bool iserr = false;
  String _message = '';

  @override
  void initState(){
    super.initState();
    _fetchReview();
  }
  _fetchReview() async{
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getReview(widget.vendor.id);
    if(_apiResponse!=null){
      if(!_apiResponse.error){
        reviewController.text = _apiResponse.data.review;
      }
    }
    setState(() {
      _isLoading = false;
    });
  }
  _submitReview() async{
    setState(() {
      _isLoading = true;
    });
    _reviewResponse = await service.reviewVendor(reviewController.text, widget.vendor.id);
    setState(() {
      _isLoading = false;
    });
    if(_reviewResponse!=null){
      if(_reviewResponse.error){
        setState(() {
          _message = _reviewResponse.errorMessage;
        });
      }
      else{
        setState(() {
          _message = _reviewResponse.data.message;
        });
        Future.delayed(Duration(seconds: 1), Navigator.of(context).pop);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 4,
      title: Text("Review ${widget.vendor.name}"),
      content: Builder(
        builder: (_){
          if(_isLoading){
            return Center(child: CircularProgressIndicator());
          }
          if(_apiResponse.error){
            return Text(_apiResponse.errorMessage);
          }
          if(_message.length!=0){
            return Text(_message);
          }
          return TextField(
            maxLines: 8,
            keyboardType: TextInputType.multiline,
            controller: reviewController,
            decoration: InputDecoration(
              focusedBorder: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue)
              ),
              border: UnderlineInputBorder(
                borderRadius: BorderRadius.circular(12)
              ),
              labelText: 'Put your review here',
              errorText: iserr?"Required":null,
            ),
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
            if(reviewController.text.isEmpty){
              setState(() {
                iserr=true;
              });
            }
            else{
              _submitReview();
            }
          },
          child: _apiResponse!=null?(_apiResponse.data.review.length==0?Text("Ok"):Text("Update")):Text("Ok"),
        ),
      ],
    );
  }
}

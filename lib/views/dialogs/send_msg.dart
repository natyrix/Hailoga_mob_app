import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/services/vendor_service.dart';

class SendMessage extends StatefulWidget {
  final VendorsModel vendor;

  const SendMessage({Key key, this.vendor}) : super(key: key);
  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
  TextEditingController msgContent = TextEditingController();
  VendorsService get service => GetIt.I<VendorsService>();
  bool _isLoading = false;
  APIResponse<Message> _apiResponse;
  bool iserr = false;

  _send_msg() async{
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.sendMsg(msgContent.text, widget.vendor.id);
    setState(() {
      _isLoading = false;
    });

    if(_apiResponse!=null){
      if(!_apiResponse.error){
        Future.delayed(Duration(seconds: 1), Navigator.of(context).pop);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Send message to ${widget.vendor.name}"),
      content: Builder(
        builder: (_){
          if(_apiResponse!=null){
            if(!_apiResponse.error){
              return SizedBox(height: 100, child: Center(child: Text(_apiResponse.data.message),));
            }
            else{
              return SizedBox(height: 100, child: Center(child: Text(_apiResponse.errorMessage),));
            }
          }
          return Container(
            padding: EdgeInsets.all(10),
            child: Theme(
              data: ThemeData(
                  primaryColor: Colors.blue
              ),
              child: TextField(
                maxLines: 8,
                keyboardType: TextInputType.multiline,
                controller: msgContent,
                decoration: InputDecoration(
                    focusedBorder: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue)),
                    border: UnderlineInputBorder(
                        borderRadius: BorderRadius.circular(12)
                    ),
                    labelText: 'Content',
                    errorText: iserr?"Required":null
                ),
              ),
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
            if(msgContent.text.isEmpty){
              setState(() {
                iserr = true;
              });
            }
            else{
              _send_msg();
            }
          },
          child: Text(
            _isLoading?"Sending...":"Send"
          ),
        ),
      ],
    );
  }
}

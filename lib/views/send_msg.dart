import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/services/vendor_service.dart';
class SendMsg extends StatefulWidget {
  final VendorsModel vendor;

  const SendMsg({Key key, this.vendor}) : super(key: key);
  @override
  _SendMsgState createState() => _SendMsgState();
}

class _SendMsgState extends State<SendMsg> {
  TextEditingController msgContent = TextEditingController();
  VendorsService get service => GetIt.I<VendorsService>();
  bool _isLoading = false;
  bool iserr = false;
  bool _sentStatus = false;
  APIResponse<Message> _apiResponse;

  send_msg() async{
    if(msgContent.text.isNotEmpty){
      setState(() {
        _isLoading = true;
      });
      _apiResponse = await service.sendMsg(msgContent.text, widget.vendor.id);
      if(_apiResponse!=null){
        if(!_apiResponse.error){
          setState(() {
            _sentStatus=true;
          });
        }
      }
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    if(_sentStatus){
      Navigator.pop(context);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Send message to "+ widget.vendor.name),
        actions: [
          Builder(
            builder: (BuildContext context){
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  icon: Icon(Icons.send, size: 35),
                  onPressed: (){
                    if(msgContent.text.isEmpty){
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('Message content can not be empty'),
                        duration: Duration(seconds: 5),
                      ));
                    }
                    else{
                      if(_sentStatus){
                        Navigator.pop(context);
                      }
                      send_msg();
                      if(_isLoading){
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('sending'),
                          duration: Duration(seconds: 5),
                        ));
                      }
                      if(_apiResponse != null){
                        if(_apiResponse.error){
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(_apiResponse.errorMessage),
                            duration: Duration(seconds: 5),
                          ));
                        }
                        else{
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content: Text(_apiResponse.data.message),
                            duration: Duration(seconds: 3),
                          ));
                        }
                      }
                    }
                  },
                  tooltip: "send",
                ),
              );
            },
          )
        ],
      ),
      body: Container(
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
      ),

    );
  }
}

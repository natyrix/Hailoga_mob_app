import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/services/vendor_service.dart';
import 'package:date_format/date_format.dart';

class VendorChat extends StatefulWidget {
  final VendorsModel vendor;

  const VendorChat({Key key, this.vendor}) : super(key: key);
  @override
  _VendorChat createState() => _VendorChat();
}

class _VendorChat extends State<VendorChat> {
  TextEditingController msgContent = TextEditingController();
  VendorsService get service => GetIt.I<VendorsService>();
  APIResponse<List<VendorChats>> _apiResponse;
  bool _isLoading = false;

  ScrollController _controller = ScrollController();


  @override
  void initState() {
    super.initState();
    _fetchChats();
  }

  _fetchChats() async{
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getVendorChats(widget.vendor.id);
    setState(() {
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    Timer(Duration(milliseconds: 500), () => _controller.jumpTo(_controller.position.maxScrollExtent));
    return Scaffold(
      body: Builder(
        builder: (_){
          if(_isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          if(_apiResponse.error){
            return Center(child: Text(_apiResponse.errorMessage),);
          }
          return ListView.builder(
            controller: _controller,
            itemBuilder: (context, index){
              return MessageTile(
                message: _apiResponse.data[index],
                sendByMe: _apiResponse.data[index].sender == 'Users'
              );
            },
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: _apiResponse.data.length,
          );
        },
      )
    );
  }
}


class MessageTile extends StatelessWidget {
  final VendorChats message;
  final bool sendByMe;

  MessageTile({@required this.message, @required this.sendByMe});


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: sendByMe ? 0 : 24,
          right: sendByMe ? 24 : 0),
      alignment: sendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: sendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: sendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: sendByMe ? [
                Colors.grey,
                Colors.grey,
//                const Color(0x1A0fffaf)
              ]
                  : [
                const Color(0x1A000fb3),
                const Color(0x1A000fb3)
              ],
            )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.message,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'OverpassRegular',
                fontWeight: FontWeight.w500)
            ),
            Text("${humanizedDate(DateTime.parse(message.sentTime))}",
                textAlign: TextAlign.end,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 13,
                    fontFamily: 'OverpassRegular',
                    fontWeight: FontWeight.w300)
            ),
            (message.sender=="Users")?
            (message.readStatus)?Icon(Icons.done_all,color: Colors.white,size: 10,)
                :Icon(Icons.done,color: Colors.white,size: 10,)
                :Text("")
          ],
        ),
      ),
    );
  }
  String humanizedDate(DateTime str){
    return formatDate(str, [M, ',', dd, ' ', yyyy, ' at ', HH, ':', nn]);
  }
}
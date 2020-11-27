import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/services/helpers.dart';
import 'package:hailoga/services/vendor_service.dart';
import 'package:hailoga/views/tabs/vendor_chats.dart';
class UsersVendorChat extends StatefulWidget {
  final VendorsModel vendor;

  const UsersVendorChat({Key key, this.vendor}) : super(key: key);
  @override
  _UsersVendorChatState createState() => _UsersVendorChatState();
}

class _UsersVendorChatState extends State<UsersVendorChat> {
  TextEditingController msgContent = TextEditingController();
  VendorsService get service => GetIt.I<VendorsService>();
  APIResponse<List<VendorChats>> _apiResponse;
  APIResponse<Message> _sendResponse;
  bool _isLoading = false;
  bool _sendLoading = false;
  ScrollController _controller = ScrollController();
  bool iserr = false;


  _send_msg() async{
    setState(() {
      _sendLoading = true;
    });
    _sendResponse = await service.sendMsg(msgContent.text, widget.vendor.id);
    setState(() {
      _sendLoading = false;
    });

    if(_sendResponse!=null){
      if(!_sendResponse.error){
        VendorChats ch = VendorChats(
          message: msgContent.text,
          readStatus: false,
          sentTime: DateTime.now().toString(),
          sender: "Users"
        );
        setState(() {
          _apiResponse.data.add(ch);
        });
        msgContent.text='';
      }
    }
  }

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
      appBar: AppBar(
        title: Row(
//          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 25.0,
              backgroundImage: CachedNetworkImageProvider("${APIAddress.api}${widget.vendor.logo}"),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              '${widget.vendor.name}',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.redo),
            onPressed: (){
              _fetchChats();
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context){
          if(_isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          if(_apiResponse.error){
            return Center(child: Text(_apiResponse.errorMessage),);
          }
          return Column(
            children: [
              Flexible(
                child: ListView.builder(
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
                ),
              ),
              Container(
                alignment: FractionalOffset.bottomCenter,
                padding: EdgeInsets.only(left: 12),
                child: Row(
                  children: [
                    Theme(
                      data: ThemeData(
                          primaryColor: Colors.blue
                      ),
                      child: Expanded(
                        child: TextField(
                          maxLines: 2,
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
                    IconButton(
                      icon: _sendLoading?Icon(Icons.report_gmailerrorred_rounded):Icon(Icons.send),
                      onPressed: (){
                        if(msgContent.text.isEmpty){
//                          setState(() {
//                            iserr = true;
//                          });
                        }
                        else{
                          _send_msg();
                          if(_sendResponse!=null){
                            if(_sendResponse.error){
                              Scaffold.of(context).showSnackBar(
                                  SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    backgroundColor: Colors.white,
                                    content: Text(
                                      _sendResponse.errorMessage,
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w700
                                      ),
                                    ),
                                  )
                              );
                            }
                          }
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/users_model.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/services/users_service.dart';

class AddCheckList extends StatefulWidget {
  @override
  _AddCheckListState createState() => _AddCheckListState();
}

class _AddCheckListState extends State<AddCheckList> {
  UsersService get service => GetIt.I<UsersService>();
  APIResponse<Message> _apiResponse;
  bool _isLoading = false;

  ScrollController _controller = ScrollController();

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);
  TextEditingController contentController = TextEditingController();
  TextEditingController orderNumberController = TextEditingController();
  String timeHr, timeMin = '';
  String _errs = 'CheckList date can not be set to today';
  bool _dateValid = true;
  bool isorderr = false;
  bool isconerr = false;

  Future<Null> _selectDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked!=null){
      if(picked.compareTo(DateTime.now())>0){
        setState(() {
          _errs = '';
          _dateValid = true;
          selectedDate = picked;
        });
      }
      else{
        setState(() {
          _dateValid = false;
          _errs = 'CheckList date can not be set to today';
        });
      }

    }
  }
  Future<Null> _selectStartTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if(picked!=null){
      setState(() {
        selectedTime = picked;
        timeHr = selectedTime.hour<10?"0${selectedTime.hour}":"${selectedTime.hour}";
        timeMin = selectedTime.minute<10?"0${selectedTime.minute}":"${selectedTime.minute}";
      });
    }
  }

  _addCheckList() async{
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.addChk(int.parse(orderNumberController.text), contentController.text, '${selectedDate.toString().split(' ')[0]} ${selectedTime.hour}:${selectedTime.minute}:00.0');
    setState(() {
      _isLoading = false;
    });

    if(_apiResponse!=null){
      if(_apiResponse.error){
        setState(() {
          _dateValid = false;
          _errs = _apiResponse.errorMessage;
        });
        Timer(Duration(milliseconds: 500), () => _controller.jumpTo(_controller.position.maxScrollExtent));
      }
      else{
        Future.delayed(Duration(seconds: 1),popDialog);
      }
    }
  }
  void popDialog(){
    Navigator.pop(context,1);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 4,
      title: Text("Add CheckList"),
      content: Builder(
        builder: (_){
          if(_isLoading){
            return SizedBox(height:100,child: Center(child: CircularProgressIndicator()));
          }
          if(_apiResponse!=null){
            if(!_apiResponse.error){
              return Text(_apiResponse.data.message);
            }
          }

          return Container(
            height: 250,
            child: ListView(
              controller: _controller,
              children: [
                Text(
                  "Choose Date: ",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5
                  ),
                ),
                SizedBox(height: 12,),
                InkWell(
                  onTap: (){
                    _selectDate(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: Text(
                      selectedDate.toString().split(' ')[0],
                    ),
                  ),
                ),
                SizedBox(height: 12,),
                Text(
                  "Choose Time: ",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5
                  ),
                ),
                SizedBox(height: 12,),
                InkWell(
                  onTap: (){
                    _selectStartTime(context);
                  },
                  child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      child: timeHr==null?Text("Select time"):Text("$timeHr:$timeMin")
                  ),
                ),
                SizedBox(height: 12,),
                Theme(
                  data: ThemeData(
                      primaryColor: Colors.blue
                  ),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: orderNumberController,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue)),
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(12)
                        ),
                        labelText: 'Order number',
                        errorText: isorderr?"Required":null
                    ),
                  ),
                ),
                SizedBox(height: 12,),

                Theme(
                  data: ThemeData(
                      primaryColor: Colors.blue
                  ),
                  child: TextField(
                    maxLines: 8,
                    keyboardType: TextInputType.multiline,
                    controller: contentController,
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.blue)),
                        border: UnderlineInputBorder(
                            borderRadius: BorderRadius.circular(12)
                        ),
                        labelText: 'Content',
                        errorText: isconerr?"Required":null
                    ),
                  ),
                ),
                SizedBox(height: 12,),
                Center(
                  child: Text(
                    _dateValid?'':_errs,
                    style: TextStyle(
                        color: Colors.redAccent
                    ),
                  ),
                )
              ],
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
            setState(() {
              contentController.text.isEmpty?isconerr=true:isconerr=false;
              orderNumberController.text.isEmpty?isorderr=true:isorderr=false;
            });
            if(selectedDate.compareTo(DateTime.now())>0 && !isconerr && !isorderr){
              _addCheckList();
            }
            else if(!(selectedDate.compareTo(DateTime.now())>0)){
              setState(() {
                _dateValid = false;
              });
            }
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}

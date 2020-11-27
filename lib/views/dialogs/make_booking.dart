import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/services/vendor_service.dart';

class MakeBooking extends StatefulWidget {
  final VendorsModel vendor;

  const MakeBooking({Key key, this.vendor}) : super(key: key);
  @override
  _MakeBookingState createState() => _MakeBookingState();
}

class _MakeBookingState extends State<MakeBooking> {
  VendorsService get service => GetIt.I<VendorsService>();
  APIResponse<Message> _apiResponse;
  bool _isLoading = false;

  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedEndTime = TimeOfDay(hour: 01, minute: 00);
  String startHr, startMin = '';
  String endHr, endMin = '';
  String _errs = 'Booking date can not be set to today';
  bool _dateValid = true;

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
          _errs = 'Booking date can not be set to today';
        });
      }

    }
  }
  Future<Null> _selectStartTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );
    if(picked!=null){
      setState(() {
        selectedStartTime = picked;
        startHr = selectedStartTime.hour<10?"0${selectedStartTime.hour}":"${selectedStartTime.hour}";
        startMin = selectedStartTime.minute<10?"0${selectedStartTime.minute}":"${selectedStartTime.minute}";
      });
    }
  }
  Future<Null> _selectEndTime(BuildContext context) async{
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedStartTime,
    );
    if(picked!=null){
      setState(() {
        selectedEndTime = picked;
        endHr = selectedEndTime.hour<10?"0${selectedEndTime.hour}":"${selectedEndTime.hour}";
        endMin = selectedEndTime.minute<10?"0${selectedEndTime.minute}":"${selectedEndTime.minute}";
      });
    }
  }

  _makeBkg() async{
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.makeBooking(selectedDate, selectedStartTime, selectedEndTime, widget.vendor.id);

    setState(() {
      _isLoading = false;
    });

    if(_apiResponse!=null){
      if(_apiResponse.error){
        setState(() {
          _dateValid = false;
          _errs = _apiResponse.errorMessage;
        });
      }
      else{
        Future.delayed(Duration(seconds: 2), Navigator.of(context).pop);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 4,
      title: Text("Make booking with ${widget.vendor.name}"),
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
              children: [
                Text(
                  "Choose Booking Date: ",
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
                  "Choose Booking Start Time: ",
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
                      child: startHr==null?Text("Select time"):Text("$startHr:$startMin")
                  ),
                ),
                SizedBox(height: 12,),
                Text(
                  "Choose Booking End Time: ",
                  style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5
                  ),
                ),
                SizedBox(height: 12,),
                InkWell(
                  onTap: (){
                    _selectEndTime(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.grey[200]),
                    child: endHr==null?Text("Select time"):Text("$endHr:$endMin"),
                  ),
                ),
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
            if(selectedDate.compareTo(DateTime.now())>0){
              if(selectedStartTime.hour<selectedEndTime.hour){
                _makeBkg();
              }
              else{
                setState(() {
                  _dateValid = false;
                  _errs = "There has to be at least an hour gap between start and end time";
                });
              }
            }
            else{
              setState(() {
                _dateValid = false;
              });
            }
          },
          child: Text("Save"),
        ),
      ],
    );
  }
}

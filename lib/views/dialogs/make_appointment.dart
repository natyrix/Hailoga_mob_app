import 'package:flutter/material.dart';
import 'package:hailoga/models/vendors_model.dart';

class MakeAppointment extends StatefulWidget {
  final VendorsModel vendor;

  const MakeAppointment({Key key, this.vendor}) : super(key: key);
  @override
  _MakeAppointmentState createState() => _MakeAppointmentState();
}

class _MakeAppointmentState extends State<MakeAppointment> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedStartTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay selectedEndTime = TimeOfDay(hour: 00, minute: 00);
  String startHr, startMin = '';
  String endHr, endMin = '';

  Future<Null> _selectDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (picked!=null){
      setState(() {
        selectedDate = picked;
      });
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 4,
      title: Text("Make appointment with ${widget.vendor.name}"),
      content: Container(
        height: 250,
        child: Column(
          children: [
            Text(
              "Choose Appointment Date: ",
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
              "Choose Appointment Start Time: ",
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
              "Choose Appointment End Time: ",
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
          ],
        ),
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
          },
          child: Text("Save"),
        ),
      ],
    );
  }
}

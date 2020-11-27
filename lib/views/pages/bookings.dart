import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/users_model.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/navigation_bloc/navigation_bloc.dart';
import 'package:hailoga/services/users_service.dart';

class UsersBookings extends StatefulWidget with NavigationStates{
  @override
  _UsersBookingsState createState() => _UsersBookingsState();
}

class _UsersBookingsState extends State<UsersBookings> {

  UsersService get service => GetIt.I<UsersService>();
  APIResponse<List<Bookings>> _apiResponse;
  APIResponse<Message> _cancelResponse;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchBkgs();
  }

  _fetchBkgs() async{
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getBookings();
    setState(() {
      _isLoading = false;
    });
  }

  _cancelBooking(pk) async{
    setState(() {
      _isLoading = true;
    });
    _cancelResponse = await service.cancelBooking(pk);
    setState(() {
      _isLoading = false;
    });
    if(_cancelResponse!=null){
      if(!_cancelResponse.error){
        Scaffold.of(context).showSnackBar(
            SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.white,
                content: Text(
                    _cancelResponse.data.message,
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700)
                )
            ));
        _fetchBkgs();
      }
      else{
        Scaffold.of(context).showSnackBar(
            SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.white,
                content: Text(
                    _cancelResponse.errorMessage,
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)
                )
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Bookings"),),
        actions: [
          IconButton(
            icon: Icon(Icons.redo),
            onPressed: (){
              _fetchBkgs();
            },
          ),
        ],
      ),
      body: Builder(
        builder: (_){
          if(_isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          if(_apiResponse.error){
            return Center(child: Text(_apiResponse.errorMessage),);
          }
          return ListView.separated(
              padding: EdgeInsets.only(top: 10),
              itemBuilder: (_, index){
                return Card(
                  elevation: 28,
                  child: Column(
                    children: [
                      ListTile(
//                      tileColor: Color(0xFFcbd4c9),
                        title: Text("With vendor: ${_apiResponse.data[index].vendorName}"),
                        subtitle: Text("Booking Date: "
                            "${humanizedDate(DateTime.parse(_apiResponse.data[index].date))}"),
                      ),
                      ListTile(
                        title: Text("From ${_apiResponse.data[index].startTime} to ${_apiResponse.data[index].endTime}"),
                        subtitle: _apiResponse.data[index].expired?Text("Expired",style: TextStyle(color: Colors.red)): _apiResponse.data[index].declined?
                        Text("Declined",style: TextStyle(color: Colors.red),):_apiResponse.data[index].status?
                        Text("Approved", style: TextStyle(color: Colors.green),):Text("Not Approved Yet", style: TextStyle(color: Colors.red),),
                      ),
                      (!_apiResponse.data[index].canceled&&!_apiResponse.data[index].expired&&!_apiResponse.data[index].declined)?
                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: [
                          RaisedButton(
                            onPressed: (){
                              _cancelBooking(_apiResponse.data[index].id);
                            },
                            child: Text("Cancel"),
                          )
                        ],
                      )
                          :
                      Container()
                    ],
                  ),
                );
              },
              separatorBuilder: (_,__)=>Divider(height: 7,color: Colors.white,),
              itemCount: _apiResponse.data.length);
        },
      ),
    );
  }
  String humanizedDate(DateTime str){
    return formatDate(str, [M, ',', dd, ' ', yyyy]);
  }
}

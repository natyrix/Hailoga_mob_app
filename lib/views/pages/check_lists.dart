import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/users_model.dart';
import 'package:hailoga/navigation_bloc/navigation_bloc.dart';
import 'package:hailoga/services/users_service.dart';
import 'package:hailoga/views/dialogs/add_checklist.dart';
import 'package:hailoga/views/dialogs/edit_checklist.dart';

class CheckLists extends StatefulWidget with NavigationStates{
  @override
  _CheckListsState createState() => _CheckListsState();
}

class _CheckListsState extends State<CheckLists> {
  UsersService get service => GetIt.I<UsersService>();
  APIResponse<List<CheckList>> _apiResponse;
  bool _isLoading = false;
  Future<bool> _willPopCallBack() async{
    return Future.value(true);
  }

  _displayEditDialog(BuildContext context, CheckList checkList) async{
    var data = await showDialog(
        context: context,
        builder: (context){
          return WillPopScope(
              onWillPop: _willPopCallBack,
              child: EditCheckList(checkList: checkList,)
          );
        }
    );
    if(data==1){
      _fetchChkLists();
    }
  }
  _displayAddDialog(BuildContext context) async{
    var data = await showDialog(
        context: context,
        builder: (context){
          return WillPopScope(
              onWillPop: _willPopCallBack,
              child: AddCheckList()
          );
        }
    );
    if(data==1){
      _fetchChkLists();
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchChkLists();
  }

  _fetchChkLists() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getCheckLists();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("CheckLists")),
        actions: [
          IconButton(
            icon: Icon(Icons.redo),
            onPressed: (){
              _fetchChkLists();
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
              padding: const EdgeInsets.only(top: 10),
              itemBuilder: (_, index){
                return Padding(
                  padding: const EdgeInsets.all(6),
                  child: Card(
                    elevation: 2,
                    color: Colors.white,
                    child: Column(
                      children: [
                        Text(
                          "Order number: ${_apiResponse.data[index].orderNumber}",
                          style: TextStyle(
                            color: Colors.deepOrange,
                            fontWeight: FontWeight.w800,
                            fontSize: 14
                          ),
                        ),
                        ListTile(
//                        tileColor: _apiResponse.data[index].readStatus?Colors.white:const Color.fromRGBO(2, 222, 22, 0),
                          title: Text('${_apiResponse.data[index].content}'),
                          subtitle: Text('On date: ${humanizedDate(DateTime.parse(_apiResponse.data[index].dateAndTime))}'),
                        ),
                        ListTile(
//                        tileColor: _apiResponse.data[index].readStatus?Colors.white:const Color.fromRGBO(2, 222, 22, 0),
                          title: (_apiResponse.data[index].isPassed && _apiResponse.data[index].status)?Text("Expired", style: TextStyle(color: Colors.redAccent))
                              :_apiResponse.data[index].status?Text("Done", style: TextStyle(color: Colors.green),)
                              :_apiResponse.data[index].isPassed?Text("Expired", style: TextStyle(color: Colors.redAccent)):Text(""),
                          subtitle: (_apiResponse.data[index].isPassed || _apiResponse.data[index].status)?Text(""):Center(
                            child: FlatButton(
                              onPressed: (){
                                _displayEditDialog(context, _apiResponse.data[index]);
                              },
                              child: Text("Edit", style: TextStyle(color: Colors.blue, fontSize: 16, fontWeight: FontWeight.w800),),
                            ),
                          )
                        )
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_,__)=>Divider(height: 2,color: Colors.transparent,),
              itemCount: _apiResponse.data.length);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.deepOrangeAccent,
        onPressed: (){
          _displayAddDialog(context);
        },),
    );
  }
  String humanizedDate(DateTime str){
    return formatDate(str, [M, ',', dd, ' ', yyyy, ' at ', hh, ':', mm]);
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/users_model.dart';
import 'package:hailoga/navigation_bloc/navigation_bloc.dart';
import 'package:hailoga/services/users_service.dart';
import 'package:hailoga/views/screens/budget_detail.dart';
import 'package:hailoga/views/screens/new_budget_plan.dart';
import 'package:humanize/humanize.dart' as humanize;


class UsersBudgets extends StatefulWidget with NavigationStates{
  @override
  _UsersBudgetsState createState() => _UsersBudgetsState();
}

class _UsersBudgetsState extends State<UsersBudgets> {
  UsersService get service => GetIt.I<UsersService>();
  APIResponse<List<Budget>> _apiResponse;
  bool _isLoading = false;
  List priceTotal = <double>[];

  @override
  void initState() {
    super.initState();
    _fetchBdgts();
  }

  _fetchBdgts() async {
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getBudgets();
    setState(() {
      _isLoading = false;
    });

    if(_apiResponse!=null){
      double sum =0;
      if(!_apiResponse.error){
        for(var bdg in _apiResponse.data){
          sum = 0;
          for(var price in bdg.pricings){
            sum+=price.value;
          }
          priceTotal.add(sum);
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Budgets"),),
        actions: [
          IconButton(
            icon: Icon(Icons.redo),
            onPressed: (){
              _fetchBdgts();
            },
          ),
        ],      ),
      body: Builder(
        builder: (context){
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
                    child: Column(
                      children: [
                        ListTile(
                          title: Text('Budget Amount: ${humanize.intComma(_apiResponse.data[index].amount.toInt())} ETB'),
                          subtitle: Text('Total price in this budget: ${humanize.intComma(priceTotal[index].toInt())} ETB'),
                        ),
                        ListTile(
                          subtitle: Text('Remaining amount: ${humanize.intComma(_apiResponse.data[index].amount.toInt()-priceTotal[index].toInt())} ETB'),
                        ),
                        FlatButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context)=>BudgetDetail(budget: _apiResponse.data[index],priceTotal: priceTotal[index],))
                            );
                          },
                          child: Text("More Info", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w800),),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_,__)=>Divider(height: 2,color: Colors.transparent,),
              itemCount: _apiResponse.data.length);
        },
      ),
//      floatingActionButton: FloatingActionButton(
//        child: Icon(Icons.add),
//        backgroundColor: Colors.deepOrangeAccent,
//        onPressed: (){
//          Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context)=>AddNewBudgetPlan()),
//          );
//        },),
    );
  }
}

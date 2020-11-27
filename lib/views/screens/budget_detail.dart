import 'package:flutter/material.dart';
import 'package:hailoga/models/users_model.dart';
import 'package:humanize/humanize.dart' as humanize;


class BudgetDetail extends StatefulWidget {
  final Budget budget;
  final double priceTotal;

  const BudgetDetail({Key key, this.budget, this.priceTotal}) : super(key: key);
  @override
  _BudgetDetailState createState() => _BudgetDetailState();
}



class _BudgetDetailState extends State<BudgetDetail> {

  Future<bool> _willPopCallBack() async{
    return Future.value(true);
  }
  _displayDetailDialog(BuildContext context, BudgetPricing pricing) async{
    return showDialog(
      context: context,
      builder: (context){
        return WillPopScope(
          child: AlertDialog(
            title: Text("Price detail"),
            content: Container(
              height: 350,
              child: ListView(
                children: [
                  ListTile(
                    title: Text("Vendor Name: ${pricing.vendor.name}"),
                    subtitle: Text("Vendor Category: ${pricing.vendor.category.name}"),
                  ),
                  ListTile(
                    title: Text("Price Title: ${pricing.title}"),
                    subtitle: Text("Price Detail: ${pricing.detail}"),
                  ),
                  ListTile(
                    subtitle: Text("Price Amount: ${humanize.intComma(pricing.value.toInt())} ETB"),
                  ),
                ],
              ),
            ),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          ),
          onWillPop: _willPopCallBack,);
      }
    );
  }

  List<DataRow> _createRow(){
    List rows = <DataRow>[];
    for(var price in widget.budget.pricings){
      rows.add(
        DataRow(
          cells: [
            DataCell(Text("${price.vendor.name}")),
            DataCell(Text("${price.title}")),
            DataCell(Text("${humanize.intComma(price.value.toInt())} ETB")),
            DataCell(
              FlatButton(
                onPressed: (){
                  _displayDetailDialog(context, price);
                },
                child: Text("Detail", style: TextStyle(
                  color: Colors.blue
                ),),
              )
            ),
         ])
      );
    }
    return rows;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Budget Detail'),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
            Card(
              elevation: 4,
              child: Column(
              children: [
                ListTile(
                  title: Text('Budget Amount: ${humanize.intComma(widget.budget.amount.toInt())} ETB'),
                  subtitle: Text('Total price in this budget: ${humanize.intComma(widget.priceTotal.toInt())} ETB'),
                ),
                ListTile(
                  subtitle: Text('Remaining amount: ${humanize.intComma(widget.budget.amount.toInt()-widget.priceTotal.toInt())} ETB'),
                ),
                Text("Price Details", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),),
                DataTable(
                  columnSpacing: 7,
                  columns: [
                    DataColumn(
                      label: Text("Name")
                    ),
                    DataColumn(
                        label: Text("Title")
                    ),
                    DataColumn(
                        label: Text("Amount")
                    ),
                    DataColumn(
                        label: Text("View Detail")
                    ),
                  ],
                  rows: _createRow()
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}

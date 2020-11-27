import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/navigation_bloc/navigation_bloc.dart';
import 'package:hailoga/services/vendor_service.dart';
import 'package:hailoga/views/pages/vendor_card.dart';
import 'package:get_it/get_it.dart';

class Vendors extends StatefulWidget with NavigationStates{
  @override
  _VendorsState createState() => _VendorsState();
}

class _VendorsState extends State<Vendors> {
  VendorsService get service => GetIt.I<VendorsService>();
  APIResponse<List<VendorsModel>> _apiResponse;
  bool _isLoading = false;
  String _curCat = 'All';

  void changedDropDownItem(String selectedCat) async{
    if(_curCat !=selectedCat){
      setState(() {
        _curCat = selectedCat;
      });
      setState(() {
        _isLoading = true;
      });
      _apiResponse = await service.filterVendors(selectedCat);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState(){
    _fetchVendors();
    super.initState();
  }
  _fetchVendors()async{
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getVendors();

    setState(() {
      _isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Vendors')),
        actions: [
          IconButton(
            icon: Icon(Icons.redo),
            onPressed: (){
              _fetchVendors();
            },
          ),
          PopupMenuButton<Choices>(
            onSelected: (Choices value){
              changedDropDownItem(value.title);
            },
            itemBuilder: (BuildContext context){
              return choices.map((Choices ch){
                return PopupMenuItem<Choices>(
                  value: ch,
                  child: Text(ch.title),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Builder(
        builder: (_){
          if(_isLoading){
            return Center(child: CircularProgressIndicator());
          }
          if(_apiResponse.error){
            return Center(child: Text(_apiResponse.errorMessage),);
          }
          return ListView.separated(
            shrinkWrap: true,
            itemBuilder: (_, index){
              return VendorCard(
                key:ValueKey(_apiResponse.data[index].id),
                vendor: _apiResponse.data[index],
                ratingVal: Ratings.ratings[index],
              );
            },
            separatorBuilder: (_,__)=>Divider(height: 5,color: Colors.white70,),
            itemCount: _apiResponse.data.length)
          ;
        },
      )
    );
  }
}

class Choices {
  final String title;
  final int index;

  const Choices({
    this.title,
    this.index
  });
}

const List<Choices> choices = const <Choices>[
  const Choices(title:"All", index: 0),
  const Choices(title:"Hair and Makeup", index: 1),
  const Choices(title:"Venue", index: 2),
  const Choices(title:"Invitation Card", index: 3),
  const Choices(title:"Decor", index: 3),
  const Choices(title:"Catering", index: 3),
  const Choices(title:"Wedding Cake", index: 3),
];


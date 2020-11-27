import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/services/vendor_service.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';

class AddNewBudgetPlan extends StatefulWidget {
  @override
  _AddNewBudgetPlanState createState() => _AddNewBudgetPlanState();
}

class _AddNewBudgetPlanState extends State<AddNewBudgetPlan> {
  VendorsService get service => GetIt.I<VendorsService>();
  APIResponse<List<CategoryModel>> _apiResponse;
  final formKey = new GlobalKey<FormState>();
  bool _isLoading = false;
  List _selectedCats;
  String _selectedOnes='No selected';

  @override
  void initState() {
    super.initState();
    _fetchCats();
    _selectedCats = [];
//    _selectedOnes = '';
  }

  _fetchCats() async{
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.getCategories();
    setState(() {
      _isLoading = false;
    });
  }

  _saveForm() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _selectedOnes = _selectedCats.toString();
      });
    }
  }
  List<Map<String,String>> _getCats(){
    List<Map<String,String>> cats = [];
    if(_apiResponse!=null){
      if(!_apiResponse.error){
        for(var cat in _apiResponse.data){
          cats.add({
            "display": cat.name,
            "value": cat.id.toString(),
          });
        }
      }
    }
    print(cats);
    return cats;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new budget plan"),
      ),
      body: Builder(
        builder: (context){
          if(_isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          if(_apiResponse.error){
            return Center(child: Text(_apiResponse.errorMessage),);
          }
          return Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(16),
                    child: MultiSelectFormField(
                      autovalidate: false,
                      title: Text('My workouts'),
                      // ignore: missing_return
                      validator: (value) {
                        if (value == null || value.length == 0) {
                          return 'Please select one or more options';
                        }
                      },
                      dataSource: _getCats(),
                      textField: 'display',
                      valueField: 'value',
                      okButtonLabel: 'OK',
                      cancelButtonLabel: 'CANCEL',
                      // required: true,
                      hintWidget: Text('Please choose one or more'),
                      initialValue: _selectedCats,
                      onSaved: (value) {
                        if (value == null) return;
                        setState(() {
                          _selectedCats = value;
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(8),
                    child: RaisedButton(
                      child: Text('Save'),
                      onPressed: _saveForm,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Text(_selectedOnes!=null?_selectedOnes:''),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

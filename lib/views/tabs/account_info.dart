import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/users_model.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/services/helpers.dart';
import 'package:email_validator/email_validator.dart';
import 'package:hailoga/services/users_service.dart';


class AccountInfo extends StatefulWidget {
  final UsersModel userModel;

  const AccountInfo({Key key, this.userModel}) : super(key: key);
  @override
  _AccountInfoState createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  UsersService get service => GetIt.I<UsersService>();
  APIResponse<Message> _apiResponse;
  bool _isLoading = false;


  TextEditingController emailController = TextEditingController();
  TextEditingController fianceEmailController = TextEditingController();
  TextEditingController fNameController = TextEditingController();
  TextEditingController fiancefNameController = TextEditingController();
  TextEditingController fiancelNameController = TextEditingController();
  TextEditingController lNameController = TextEditingController();
  List _role = ["Bride", "Groom"];
  DateTime weddingDate ;
  List<DropdownMenuItem<String>> _items = new List();
  String _curRole;

  String _errTxt = '';
  String _valErrTxt = 'Required';
  String _emailErr = '';
  String _pwdErr = '';
  bool _isEmValid = false;
  bool _isFEmValid = false;
  bool _isFnameValid = false;
  bool _isLnameValid = false;
  bool _isFiFnameValid = false;
  bool _isFiLnameValid = false;
  bool isDateValid = true;
  String dateErrTxt = '';

  _updateUsers() async{
    setState(() {
      _isLoading = true;
    });
    UsersModel usersModel = UsersModel(
      email: emailController.text,
      firstName: fNameController.text,
      lastName: lNameController.text,
      role: _curRole,
      weddingDate: weddingDate.toString(),
      fianceFirstName: fiancefNameController.text,
      fianceLastName: fiancelNameController.text,
      fianceEmail: fianceEmailController.text
    );
    _apiResponse = await service.updateUsers(usersModel);
    setState(() {
      _isLoading = false;
    });
    if(_apiResponse!=null){
      if(!_apiResponse.error){
        Scaffold.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.white,
              content: Text(
                _apiResponse.data.message,
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700)
              )
        ));
      }
      else{
        Scaffold.of(context).showSnackBar(
            SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.white,
                content: Text(
                    _apiResponse.errorMessage,
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.w700)
                )
            ));
      }
    }
  }



  void changedDropDownItem(String selectedRole){
    setState(() {
      _curRole = selectedRole;
    });
  }

  _selectDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: weddingDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if(picked!=null && picked!=weddingDate){
      if(picked.compareTo(DateTime.now())>0){
        setState(() {
          isDateValid = true;
          weddingDate = picked;
        });
      }
      else{
        setState(() {
          isDateValid = false;
          dateErrTxt = 'Wedding date can not be set to a past date';
        });
      }

    }
  }

  List<DropdownMenuItem<String>> getDropDownMenuItems(){
    List<DropdownMenuItem<String>> items = List();
    for(String r in _role){
      items.add(DropdownMenuItem(
          value: r,
          child: new Text(r)
      ));
    }
    return items;
  }

  @override
  void initState() {
    emailController.text = widget.userModel.email;
    fianceEmailController.text = widget.userModel.fianceEmail;
    fNameController.text = widget.userModel.firstName;
    fiancefNameController.text = widget.userModel.fianceFirstName;
    fiancelNameController.text = widget.userModel.fianceLastName;
    lNameController.text = widget.userModel.lastName;
    _items = getDropDownMenuItems();
    _curRole = widget.userModel.role;
    weddingDate = DateTime.parse(widget.userModel.weddingDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (_){
          if(_isLoading){
            return Center(child: CircularProgressIndicator(),);
          }
          return ListView(
            padding: EdgeInsets.only(top: 10),
            children: [
              Card(
                elevation: 10,
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Theme(
                          data: ThemeData(
                              primaryColor: Colors.blue
                          ),
                          child: TextField(
                            controller: fNameController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.blue)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                labelText: 'First Name',
                                errorText: _isFnameValid?_valErrTxt:null
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Theme(
                          data: ThemeData(
                              primaryColor: Colors.blue
                          ),
                          child: TextField(
                            controller: lNameController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.blue)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                labelText: 'Last Name',
                                errorText: _isLnameValid?_valErrTxt:null
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Theme(
                          data: ThemeData(
                              primaryColor: Colors.blue
                          ),
                          child: TextField(
                            controller: fiancefNameController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.blue)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                labelText: 'Fiance First Name',
                                errorText: _isFiFnameValid?_valErrTxt:null
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Theme(
                          data: ThemeData(
                              primaryColor: Colors.blue
                          ),
                          child: TextField(
                            controller: fiancelNameController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.blue)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                labelText: 'Fiance Last Name',
                                errorText: _isFiLnameValid?_valErrTxt:null
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Theme(
                          data: ThemeData(
                              primaryColor: Colors.blue
                          ),
                          child: TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.blue)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                labelText: 'Email',
                                errorText: _isEmValid?_emailErr:null
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Theme(
                          data: ThemeData(
                              primaryColor: Colors.blue
                          ),
                          child: TextField(
                            controller: fianceEmailController,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.blue)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                labelText: 'Fiance Email',
                                errorText: _isFEmValid?_emailErr:null
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          children: <Widget>[
                            Text("Please choose role"),
                            SizedBox(width: 10,),
                            DropdownButton(
                              value: _curRole,
                              items: _items,
                              onChanged: changedDropDownItem,
                            )
                          ],
                        ),
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                child: Center(
                                  child: Text(
                                    isDateValid?weddingDate.toString().split(' ')[0]:dateErrTxt,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: isDateValid?Colors.black:Colors.red
                                    ),
                                  ),
                                ),
                              ),
                              RaisedButton(
                                onPressed: ()=>_selectDate(context),
                                child: Text("Select wedding date",
                                  style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          )
                      ),
                      Container(
                        height: 60,
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            // side: BorderSide(color: Colors.white)
                          ),
                          textColor: Colors.white,
                          color: Colors.blue,
                          child: Text('Update'),
                          onPressed: (){
                            setState(() {
                              fNameController.text.isEmpty?_isFnameValid=true:_isFnameValid=false;
                              lNameController.text.isEmpty?_isLnameValid=true:_isLnameValid=false;
                              fiancefNameController.text.isEmpty?_isFiFnameValid=true:_isFiFnameValid=false;
                              fiancelNameController.text.isEmpty?_isFiLnameValid=true:_isFiLnameValid=false;
                              fianceEmailController.text.isEmpty?_isFEmValid=true:_isFEmValid=false;
                              fianceEmailController.text.isEmpty?_emailErr='Email required':_emailErr='';
                              emailController.text.isEmpty?_isEmValid=true:_isEmValid=false;
                              emailController.text.isEmpty?_emailErr='Email required':_emailErr='';
                            });
                            if(!_isEmValid && !_isFnameValid && !_isLnameValid && !_isFiFnameValid && !_isFiLnameValid && !_isFEmValid && isDateValid){
                              if(EmailValidator.validate(emailController.text) && EmailValidator.validate(fianceEmailController.text)){
                                _updateUsers();
                              }
                              else{
                                if(!EmailValidator.validate(emailController.text)){
                                  setState(() {
                                    _isEmValid = true;
                                    _emailErr = 'Invalid email address';
                                  });
                                }
                                else{
                                  setState(() {
                                    _isFEmValid = true;
                                    _emailErr = 'Invalid email address';
                                  });
                                }
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

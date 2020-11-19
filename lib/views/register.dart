import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController emailContorller = TextEditingController();
  TextEditingController fianceEmailContorller = TextEditingController();
  TextEditingController fNameContorller = TextEditingController();
  TextEditingController fiancefNameContorller = TextEditingController();
  TextEditingController fiancelNameContorller = TextEditingController();
  TextEditingController lNameContorller = TextEditingController();
  // TextEditingController roleContorller = 
  TextEditingController passwordContorller = TextEditingController();
  TextEditingController conPasswordContorller = TextEditingController();
  List _role = ["Bride", "Groom"];
  DateTime weddingDate = DateTime.now();
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
  bool _isPwdValid = false; 
  bool _isConPwdValid = false; 


  handleLogin(){
    if(EmailValidator.validate(emailContorller.text)){
      setState(() {
        _errTxt = '';
      });
    }
    else{
      setState(() {
        _isEmValid=true;
        _emailErr='Invalid email';
      });
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
      lastDate: DateTime(2030)
    );
    if(picked!=null && picked!=weddingDate){
      setState(() {
        weddingDate = picked;
      });
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
  void initState(){
    _items = getDropDownMenuItems();
    _curRole = _items[0].value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Register"),
        ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Text(
                'Hailoga',
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 30
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: Text(
                'Register',
                style: TextStyle(
                  fontSize: 20
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: fNameContorller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  labelText: 'First Name',
                  errorText: _isFnameValid?_valErrTxt:null
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: lNameContorller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  labelText: 'Last Name',
                  errorText: _isLnameValid?_valErrTxt:null
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: fiancefNameContorller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  labelText: 'Fiance First Name',
                  errorText: _isFiFnameValid?_valErrTxt:null
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: fiancelNameContorller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  labelText: 'Fiance Last Name',
                  errorText: _isFiLnameValid?_valErrTxt:null
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: emailContorller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  labelText: 'Email',
                  errorText: _isEmValid?_emailErr:null
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: fianceEmailContorller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  labelText: 'Fiance Email',
                  errorText: _isFEmValid?_emailErr:null
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
              child: RaisedButton(
                    onPressed: ()=>_selectDate(context),
                    child: Text("Select wedding date",
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                  )
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextField(
                obscureText: true,
                controller: passwordContorller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  labelText: 'Password',
                  errorText: _isPwdValid?_pwdErr:null
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: TextField(
                obscureText: true,
                controller: conPasswordContorller,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  labelText: 'Confirm Password',
                  errorText: _isConPwdValid?_pwdErr:null
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Text(
                _errTxt,
                style: TextStyle(
                  color: Colors.red
                ),
              ),
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
                child: Text('Login'),
                onPressed: (){
                  setState(() {
                    fNameContorller.text.isEmpty?_isFnameValid=true:_isFnameValid=false;
                    lNameContorller.text.isEmpty?_isLnameValid=true:_isLnameValid=false;
                    fiancefNameContorller.text.isEmpty?_isFiFnameValid=true:_isFiFnameValid=false;
                    fiancelNameContorller.text.isEmpty?_isFiLnameValid=true:_isFiLnameValid=false;
                    fianceEmailContorller.text.isEmpty?_isFEmValid=true:_isFEmValid=false;
                    fianceEmailContorller.text.isEmpty?_emailErr='Email required':_emailErr='';
                    emailContorller.text.isEmpty?_isEmValid=true:_isEmValid=false;
                    emailContorller.text.isEmpty?_emailErr='Email required':_emailErr='';
                    passwordContorller.text.isEmpty?_isPwdValid=true:_isPwdValid=false;
                    passwordContorller.text.isEmpty?_pwdErr='Password required':_pwdErr='';
                    conPasswordContorller.text.isEmpty?_isConPwdValid=true:_isConPwdValid=false;
                    conPasswordContorller.text.isEmpty?_pwdErr='Password required':_pwdErr='';

                  });
                  if(!_isEmValid && !_isPwdValid){
                    handleLogin();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
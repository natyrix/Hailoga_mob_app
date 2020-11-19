import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/login_model.dart';
import 'package:hailoga/services/helpers.dart';
import 'package:hailoga/services/login_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hailoga/views/home.dart';
import 'package:get/get.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailContorller = TextEditingController();
  TextEditingController passwordContorller = TextEditingController();
  String _errTxt = '';
  String _emailErr = '';
  bool _isEmValid = false;
  bool _login = false;
  bool _isPwdValid = false;

  LoginService get service => GetIt.I<LoginService>();
  APIResponse<LoginModel> _apiresponse;
  bool _isLoading = false;
  final _storage = FlutterSecureStorage();

  handleLogin() async{
    if(EmailValidator.validate(emailContorller.text)){
      setState(() {
        _errTxt = '';
        _isLoading = true;
      });
      _apiresponse = await service.login(emailContorller.text.split("@")[0],passwordContorller.text);
      if(_apiresponse!=null) {
        if (!_apiresponse.error) {
          _addToken(_apiresponse.data.token);
          setState(() {
            _login = true;
          });
        }
      }
      setState(() {
        _isLoading=false;
      });
    }
    else{
      setState(() {
        _isEmValid=true;
        _emailErr='Invalid email';
      });
    }
  }

  _addToken(token) async{
    final String key = 'tok';
    final String value = token;
    await _storage.write(key: key, value: value);
    GetToken.token = token;
  }

  @override
  Widget build(BuildContext context) {
//    if(_login){
//      Navigator.pop(context);
//      Navigator.push(
//          context,
//          MaterialPageRoute(
//            builder: (context)=>Home(),
//          )
//      );
//    }
    return Scaffold(
      appBar: AppBar(
          title: Text('Login', style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        ),
      body: Builder(
        builder:(BuildContext context){
          if(_isLoading){
            return Container(child: Center(child: CircularProgressIndicator()));
          }
          return Padding(
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
                    'Sign in',
                    style: TextStyle(
                      fontSize: 20
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
                      controller: emailContorller,
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
                Theme(
                  data: ThemeData(
                    primaryColor: Colors.blue
                  ),
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: TextField(
                      obscureText: true,
                      controller: passwordContorller,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.blue)),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        labelText: 'Password',
                        errorText: _isPwdValid?'Password required':null
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Text(
                    _apiresponse==null?_errTxt:_apiresponse.error?_apiresponse.errorMessage:'',
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
                        emailContorller.text.isEmpty?_isEmValid=true:_isEmValid=false;
                        emailContorller.text.isEmpty?_emailErr='Email required':_emailErr='';
                        passwordContorller.text.isEmpty?_isPwdValid=true:_isPwdValid=false;
                      });
                      if(!_isEmValid && !_isPwdValid){
                        handleLogin();
                        if(_apiresponse!=null){
                          if(!_apiresponse.error){
                             Navigator.push(
                               context,
                               MaterialPageRoute(
                                 builder: (context)=>Home(),
                               )
                             );
                          }
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
        );
        }),
      );
  }
}
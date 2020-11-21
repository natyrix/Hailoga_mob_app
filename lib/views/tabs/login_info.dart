import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hailoga/models/api_response.dart';
import 'package:hailoga/models/vendors_model.dart';
import 'package:hailoga/services/users_service.dart';

class LoginInfo extends StatefulWidget {
  @override
  _LoginInfoState createState() => _LoginInfoState();
}

class _LoginInfoState extends State<LoginInfo> {
  UsersService get service => GetIt.I<UsersService>();
  bool _isLoading = false;
  APIResponse<Message> _apiResponse;

  TextEditingController pwdController = TextEditingController();
  TextEditingController oldPwdController = TextEditingController();
  TextEditingController conPwdController = TextEditingController();
  bool _isPwdValid = true;
  bool _isConPwdValid = true;
  bool _isOldPwdValid = true;

  String _oldPwdError = 'Required';
  String _pwdError = 'Required';
  String _conPwdError = 'Required';

  _updatePass() async{
    setState(() {
      _isLoading = true;
    });
    _apiResponse = await service.changePassword(oldPwdController.text, pwdController.text, conPwdController.text);
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
        if(_apiResponse.errorMessage=='Invalid old password'){
          setState(() {
            _oldPwdError = 'Invalid old password';
            _isOldPwdValid = false;
          });
        }
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
                            controller: oldPwdController,
                            obscureText: true,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.blue)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                labelText: 'Old Password',
                                errorText: _isOldPwdValid?null:_oldPwdError
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
                            controller: pwdController,
                            obscureText: true,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.blue)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                labelText: 'New Password',
                                errorText: _isPwdValid?null:_pwdError
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
                            controller: conPwdController,
                            obscureText: true,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.blue)),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                labelText: 'Confirm New Password',
                                errorText: _isConPwdValid?null:_conPwdError
                            ),
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
                          child: Text('Change Password'),
                          onPressed: (){
                            setState(() {
                              oldPwdController.text.isEmpty?_isOldPwdValid=false:_isOldPwdValid=true;
                              pwdController.text.isEmpty?_isPwdValid=false:_isPwdValid=true;
                              conPwdController.text.isEmpty?_isConPwdValid=false:_isConPwdValid=true;
                            });
                            if(_isOldPwdValid&&_isConPwdValid&&_isPwdValid){
                              if(pwdController.text==conPwdController.text && pwdController.text != oldPwdController.text){
                                _updatePass();
                              }
                              else{
                                if(pwdController.text==oldPwdController.text){
                                  setState(() {
                                    _oldPwdError = 'Old password is the same as new password';
                                    _pwdError = 'Old password is the same as new password';
                                    _isPwdValid=false;
                                    _isOldPwdValid=false;
                                  });
                                }
                                else{
                                  setState(() {
                                    _conPwdError = 'Passwords does not match';
                                    _pwdError = 'Passwords does not match';
                                    _isPwdValid=false;
                                    _isConPwdValid=false;
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
              )
            ],
          );
        },
      ),
    );
  }
}

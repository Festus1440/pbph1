import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:flutterapp/ShelterDrawer/loading.dart';
//import 'forgotPass.dart';
import 'forgotPass.dart';
import 'main.dart';
import 'register.dart';
//import 'ClientRestaurantMain.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscure = true;
  bool loginVisible = false;
  bool loading = false;
  String _email, _password;
  bool errorVisible = false;
  String loginError = "";
  void showError(error, show) {
    setState(() {
      loginError = error;
      errorVisible = show;
    });
  }
  _save(data, uid)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(uid, jsonEncode(data)).then((value) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DetermineUser()),
            (Route<dynamic> route) => false,
      );
    });
  }
  void _login()async{
    if (_email == null || _email == "") {
      showError("Email can't be empty", true);
    } else if (_password == null || _password == "") {
      showError("Password can't be empty", true);
    } else {
      showError("", false);
      setState(() {
        loading = true;
      });
      FirebaseAuth.instance.signInWithEmailAndPassword(email: _email.trim(), password: _password.trim()).then((value) {
        Map userD = {"role": "null", "uid": value.user.uid};
        _save(userD, value.user.uid);
      }).catchError((error) {
        setState(() {
          loading = false;
        });
        showError(error.message, true);
        print("Error: " + error.message);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        elevation: 10.0,
        color: Colors.green,
        child: Padding(
          padding: EdgeInsets.all(20),
        ),
      ),
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 10.0,
        title: Text("Log in"),
        backgroundColor: Colors.green,
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 40,bottom: 40,right: 100,left: 100),
              child: Image(
                image: AssetImage('assets/PB2.jpg'),
                width: 190.0,
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.email,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          autocorrect: false,
                          //autofocus: true,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          onSubmitted: (_) =>
                              FocusScope.of(context).nextFocus(),
                          enabled: !loginVisible,
                          decoration: InputDecoration(
                            labelText: "Email",
                          ),
                          onChanged: (value) {
                            this.setState(() {
                              _email = value;
                              if (_email == "") {
                                showError("Email can't be empty", true);
                              } else {
                                showError("", false);
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.lock,
                        color: Colors.green,
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: TextField(
                          autocorrect: false,
                          enabled: !loginVisible,
                          decoration: InputDecoration(
                            labelText: "Password",
                            suffixIcon: IconButton(
                              icon: Icon(Icons.remove_red_eye),
                              onPressed: (){
                                setState(() {
                                  _obscure = !_obscure;
                                });
                              },
                            ),
                          ),
                          obscureText: _obscure,
                          onChanged: (value) {
                            this.setState(() {
                              _password = value;
                              if (_password == "") {
                                showError("Password can't be empty", true);
                              } else {
                                showError("", false);
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Visibility(
                    visible: errorVisible,
                    child: Container(
                      margin: EdgeInsets.only(top: 10.0,left: 45),
                      alignment: Alignment(-1.0, 0.0),
                      child: Text(loginError),
                    ),
                  ),
                  Container(
                    alignment: Alignment(1.0, 0.0),
                    padding: EdgeInsets.only(top: 15.0),
                    child: InkWell(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PassRecover(),
                                fullscreenDialog: true),
                          );
                        },
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.0),
                  MaterialButton(
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    elevation: 1,
                    color: Colors.green,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.white,
                    minWidth: MediaQuery.of(context).size.width * 0.9,
                    height: 50.0,
                    child: Text("Login"),
                    onPressed: loading ? null : () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      _login();
                    },
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: Text("OR"),
                  ),
                  MaterialButton(
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    color: Colors.green,
                    disabledColor: Colors.grey,
                    elevation: 1,
                    textColor: Colors.white,
                    disabledTextColor: Colors.white,
                    minWidth: MediaQuery.of(context).size.width * 0.9,
                    height: 50.0,
                    child: Text("Create account"),
                    onPressed: () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
                    },
                  ),
                ],
              ),
            ),
            Container(
              //color: Colors.blue,
              height: MediaQuery.of(context).viewInsets.bottom,
            ),
          ],
        ),
      ),
    );
  }

}

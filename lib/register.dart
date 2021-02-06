import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';
//import 'package:provider/provider.dart';
//import 'ShelterDrawer/loading.dart';

//import 'ClientRestaurantMain.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class Register extends StatefulWidget {
  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register> {
  bool _loading = false;
  Color _mainColor = Colors.green;
  String checkBoxLabelText = "Restaurant/Organization Name";
  bool _isRestaurant = true;
  bool _isShelter = false;
  String _name, _email, _password;
  String role = "Restaurant";
  bool errorVisible = false;
  String loginError = "";
  void _showError(error, show) {
    setState(() {
      loginError = error;
      errorVisible = show;
    });
  }
  void _register()async{
    //error checking first
    if (_email == null || _email == "") {
      _showError("Email can't be empty", true);
    } else if (_password == null || _password == "") {
      _showError("Password can't be empty", true);
    } else if (_name == null || _name == "") {
      _showError("Name can't be empty", true);
    } else {
      _showError("Please wait ...", true);
      setState(() => _loading = true);
      FirebaseAuth _auth = FirebaseAuth.instance;
      try {
        await _auth.createUserWithEmailAndPassword(
          email: _email.trim(),
          password: _password.trim(),
        ).then((userCre) {
          FirebaseFirestore.instance
              .collection("users")
              .doc(userCre.user.uid)
              .set({
            'displayName': _name,
            'email': _email.trim(),
            'role': "client",
            'lat': 0.0,
            'long': 0.0,
            'uid': userCre.user.uid,
          }).then((onValue) {
            Map userD = {"role": role, "uid": userCre.user.uid};
            _save(userD, userCre.user.uid);
            //Navigator.pop(context, userID);
          });
        });
      } catch (e) {
        setState(() => _loading = false);
        _showError(e.message, true);
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomAppBar(
        elevation: 10.0,
        color: _mainColor,
        child: Padding(
          padding: EdgeInsets.all(20),
        ),
      ),
      appBar: AppBar(
        elevation: 10.0,
        title: Text("Register"),
        backgroundColor: _mainColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 0.0, 0.0, 0.0),
                    child: Image(
                      image: AssetImage('assets/PB.jpg'),
                      width: 190.0,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  Container(
                    //margin: EdgeInsets.all(10),
                    //color: Colors.lightBlue,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.account_box,
                              color: _mainColor,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.text,
                                textCapitalization: TextCapitalization.words,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (_) => FocusScope.of(context).nextFocus(),
                                decoration: InputDecoration(
                                  labelText: "Name",
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: _mainColor),
                                  ),
                                ),
                                onChanged: (value) {
                                  this.setState(() {
                                    _name = value;
                                    if (_name == "") {
                                      _showError("Name can't be empty", true);
                                      _loading = false;
                                    } else {
                                      _showError("", false);
                                    }
                                  });
                                }
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.email,
                              color: _mainColor,
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: TextField(
                                autocorrect: false,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                decoration: InputDecoration(
                                  labelText: "Email",
                                ),
                                onChanged: (value) {
                                  this.setState(() {
                                    _email = value;
                                    if (_email == "") {
                                      _showError("Email can't be empty", true);
                                      _loading = false;
                                    } else {
                                      _showError("", false);
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.lock,
                              color: _mainColor,
                            ),
                            SizedBox(width: 20),
                            Expanded(
                              child: TextField(
                                keyboardType: TextInputType.visiblePassword,
                                autocorrect: false,
                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                ),
                                onChanged: (value) {
                                  this.setState(() {
                                    _password = value;
                                    if (_password == "") {
                                      _showError("Password can't be empty", true);
                                      _loading = false;
                                    } else {
                                      _showError("", false);
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: errorVisible,
                    child: Container(
                      margin: EdgeInsets.only(top: 10.0),
                      alignment: Alignment(-1.0, 0.0),
                      child: Text(
                        loginError,
                        style: TextStyle(
                          color: _mainColor,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 25.0),
                  MaterialButton(
                    shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    elevation: 1,
                    color: _mainColor,
                    textColor: Colors.white,
                    disabledColor: Colors.grey,
                    disabledTextColor: Colors.white,
                    minWidth: MediaQuery.of(context).size.width * 0.9,
                    height: 50.0,
                    child: Text("Register"),
                    onPressed: _loading ? null : () {
                      FocusScope.of(context).requestFocus(new FocusNode());
                      _register();
                    },
                  ),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
}
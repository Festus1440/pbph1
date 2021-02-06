import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';

class PassRecover extends StatefulWidget {

  @override
  _PassRecoverState createState() => _PassRecoverState();
}

class _PassRecoverState extends State<PassRecover> {
  String _email, warning = "";
  bool viewVisible = false;
  bool errorVisible = false;

  void showError(error, show) {
    setState(() {
      warning = error;
      errorVisible = show;
    });
  }

  void showWidget() {
    setState(() {
      viewVisible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey,
        child: Padding(
          padding: EdgeInsets.all(20),
        ),
      ),
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Account Recovery"),
        backgroundColor: Colors.black38,
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
              padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  TextField(
                    onChanged: (value) {
                      this.setState(() {
                        _email = value;
                        if (_email == "" || _email == null) {
                          print("Empty");
                          showError("Email can't be empty", true);
                        } else {
                          showError("", false);
                        }
                      });
                    },
                    decoration: InputDecoration(
                        labelText: 'Enter email or Phone No',
                        labelStyle: TextStyle(
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                  ),
                  Visibility(
                    visible: errorVisible,
                    child: Container(
                      margin: EdgeInsets.only(top: 10.0),
                      alignment: Alignment(-1.0, 0.0),
                      child: Text(warning),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  Container(
                    child: Builder(
                      builder: (context) =>
                          FlatButton(
                            color: Colors.black38,
                            textColor: Colors.white,
                            disabledColor: Colors.grey,
                            disabledTextColor: Colors.black,
                            //splashColor: Colors.blueAccent,
                            onPressed: () {
                              setState(() {});
                              if (_email == "" || _email == null) {
                                showError("Email can't be empty", true);
                              } else {
                                showError("", false);
                                FirebaseAuth.instance.sendPasswordResetEmail(email: _email).then((value) {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('Password reset email sent successful'),
                                    duration: Duration(seconds: 3),
                                  ));
                                }).catchError((error) {
                                  showError(error.message, true);
                                  print("Error: " + error.message);
                                });
                              }
                              //showWidget();
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 50.0,
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

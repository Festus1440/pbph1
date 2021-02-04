import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'BottomBar/ShelterRestaurantMain.dart';
import 'login.dart';
import 'register.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(Main());
class Main extends StatefulWidget {
  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(fontFamily: 'SF'),
        debugShowCheckedModeBanner: false,
        title: "Plate Beacon",
        home: DetermineUser()
    );
  }
}

_goToPage(BuildContext context, String page) async {
  //this function is not being used ignore
  var user;
  if(page == "login"){
    final role = await Navigator.push(context,
      MaterialPageRoute(
          builder: (context) => LoginPage(), fullscreenDialog: true),
    );
    if (role != null) {
      print(role);
      user = role;
    }
  }
  else{
    final role = await Navigator.push(context,
      MaterialPageRoute(
          builder: (context) => RegisterPage(), fullscreenDialog: true),
    );
    if (role != null) {
      print(role);
      user = role;
    }
  }
  return user;
}

class DetermineUser extends StatefulWidget {

  @override
  _DetermineUserState createState() => _DetermineUserState();
}

class _DetermineUserState extends State<DetermineUser> {
  @override
  void initState() {
    super.initState();
  }

  Future<void> initializeDefault() async {
    //this function has to initialize before anthing firebase related happens
    FirebaseApp app = await Firebase.initializeApp();
    assert(app != null);
    //print('Initialized default app $app');
  }

  Future<Map> userLoggedIn() async{
    //this function decides the role of the user
    SharedPreferences prefs = await SharedPreferences.getInstance();
    User user = FirebaseAuth.instance.currentUser;
    String role;
    Map data = {};
    if(user != null){
      String uid = user.uid;
      print("user is not null ");
      await FirebaseFirestore.instance.collection("users").doc(uid).get().then((doc) {
        if(doc.exists){
          data["role"] = doc.data()["role"] ??= "null";
          data["uid"] = uid;
          data["name"] = doc.data()["displayName"] ??= "null";
          role = doc.data()["role"] ??= "null";
          print("doc exist");
        }
        else {
          print("doc doesn't exist users/$uid");
        }
      });
      //Map userD = jsonDecode(prefs.getString(uid));
      //role = userD["uid"];
    }
    else{
      print("user is null because $user");
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeDefault(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Scaffold(body: Center(child: Text("error ${snapshot.error}")),
            ),);
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return FutureBuilder(
                future: userLoggedIn(),
                builder: (context, snapshot){
                  if(snapshot.hasError){
                    return Scaffold(body: Center(child: Text("error ${snapshot.error}")));
                  }
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return Scaffold(body: Center(child: CupertinoActivityIndicator()));
                  }
                  if(snapshot.connectionState == ConnectionState.done){
                    if(snapshot.hasData){
                      print("has data ${snapshot.data.toString()}");
                      if(snapshot.data["role"] == "Shelter" || snapshot.data["role"] == "Restaurant"){
                        return ShelterRestaurantMain(snapshot.data);
                      }
                      else {
                        return NotLoggedInPage();
                      }
                    }
                    else if(snapshot.hasData != true){
                      //print("has no data");
                      return NotLoggedInPage();
                    }
                  }
                  return Scaffold(body: Center(child: CupertinoActivityIndicator()));
                }
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Scaffold(body: Center(child: CircularProgressIndicator()),
            ));
          }
          // Otherwise, show something whilst waiting for initialization to complete
          return Scaffold(body: Center(
            child: CircularProgressIndicator(),
          ));
        }
    );
  }
}


class NotLoggedInPage extends StatefulWidget {
  @override
  _NotLoggedInPageState createState() => _NotLoggedInPageState();
}

class _NotLoggedInPageState extends State<NotLoggedInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 120,
            right: 60,
            left: 60,
            child: Container(
              //padding: EdgeInsets.fromLTRB(15.0, 100.0, 0.0, 0.0),
              child: Image(
                image: AssetImage('assets/PB.jpg'),
                //width: 190.0,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: Container(
              padding: EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
              child: Column(
                children: <Widget>[
                  SizedBox(height: 80.0),
                  Container(
                    child: FlatButton(
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      color: Colors.green,
                      textColor: Colors.white,
                      disabledTextColor: Colors.black,
                      //splashColor: Colors.blueAccent,
                      onPressed: () async {
                        //_goToPage(context, "login");
                        var role;
                        Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => LoginPage()),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Text(
                          "Log in",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 15.0),

                  Container(
                    child: OutlineButton(
                      shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      //color: Colors.green,
                      //textColor: Colors.white,
                      borderSide: BorderSide(
                        color: Colors.green,
                        style: BorderStyle.solid,
                        width: 0.8,
                      ),

                      disabledTextColor: Colors.black,
                      //splashColor: Colors.blueAccent,
                      onPressed: () async {
                        //var role;
                        Navigator.push(context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 50.0,
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
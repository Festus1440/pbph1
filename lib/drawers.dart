import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pb_ph1/Drawer/Events.dart';
import 'package:pb_ph1/Drawer/Help.dart';
import 'package:pb_ph1/Drawer/Stories.dart';

import 'Analytics/Shelter/ShelterMainAnalytics.dart';
import 'Drawer/Settings.dart';
import 'main.dart';

class Drawers extends StatelessWidget {
  final Color _mainColor;
  final String _name;
  final String _state;
  final String _city;
  final Map data;
  Drawers(this._mainColor, this._name, this._state, this._city, this.data);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20.0),
            color: _mainColor,
            child: SafeArea(
              child: Center(
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      margin: EdgeInsets.only(top: 0.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage('assets/PB.jpg'),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            _name,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 15.0,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            _city + ", " + _state,
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: 13.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          data["role"] == "Client" ? Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                children: <Widget>[
                  Container(),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    leading: Icon(Icons.restaurant),
                    title: Text("Restaurant Details"),
                  ),
                  ListTile(
                    //Creates the link to the analytics page.
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ShelterMainAnalytics()));
                    },
                    leading: Icon(Icons.insert_chart),
                    title: Text("My Analytics"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Stories(_mainColor, data)));
                    },
                    leading: Icon(Icons.library_books),
                    title: Text("Stories"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => Events(_mainColor, data)));
                    },
                    leading: Icon(Icons.event),
                    title: Text("Events"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Help(_mainColor, data), fullscreenDialog: true));
                    },
                    leading: Icon(Icons.help),
                    title: Text("Help"),
                  ),
                  ListTile(
                    onTap: () {
                      // flutter defined function
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            //shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
                            backgroundColor: Colors.white,
                            title: new Text("Favorites coming soon!"),
                            content: new Text("Soon you will be able to favorite Shelters you work with"
                                " closely and view them all in one place!"),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("Sounds good!"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    leading: Container(
                      //margin: EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.favorite)),
                    title: Text("Favorites"),

                  ),

                  Divider(
                    height: 15.0,
                    thickness: 0.5,
                    color: _mainColor,
                    indent: 20.0,
                    endIndent: 20.0,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Setting(_mainColor, data)));
                    },
                    leading: Icon(Icons.settings),
                    title: Text("Settings"),
                  ),
                  ListTile(
                    onTap: () {
                      FirebaseAuth.instance.signOut().then((value) {
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Main()),
                              (Route<dynamic> route) => false,
                        );
                      });
                    },
                    leading: Icon(Icons.arrow_back),
                    title: Text("Log out"),
                  ),
                ],
              ),
            ),
          )
          :Expanded(
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView(
                children: <Widget>[
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    leading: Icon(Icons.home),
                    title: Text("Shelter Details"),
                  ),
                  ListTile(
                    //Creates the Analytics section.
                    onTap: () {
                      Navigator.of(context).pop();
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantMainAnalytics()));
                    },
                    leading: Icon(Icons.insert_chart),
                    title: Text("Analytics"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => Stories(_mainColor, data)));
                    },
                    leading: Icon(Icons.library_books),
                    title: Text("Stories"),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Help(_mainColor, data),
                              fullscreenDialog: true));
                    },
                    leading: Container(child: Icon(Icons.help)),
                    title: Text("Help"),
                  ),
                  ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15)),
                            backgroundColor: Colors.white,
                            title: new Text("Favorites coming soon!"),
                            content: new Text(
                                "Soon you will be able to favorite Shelters you work with"
                                    " closely and view them all in one place!"),
                            actions: <Widget>[
                              new FlatButton(
                                child: new Text("Sounds good!"),
                                textColor: Colors.green,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    leading: Container(
                      //margin: EdgeInsets.only(left: 10.0),
                        child: Icon(Icons.favorite)),
                    title: Text("Favorites"),
                  ),
                  Divider(
                    height: 15.0,
                    thickness: 0.5,
                    color: Colors.green,
                    indent: 20.0,
                    endIndent: 20.0,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Setting(_mainColor, data)));
                    },
                    leading: Icon(Icons.settings),
                    title: Text("Settings"),
                  ),
                  ListTile(
                    onTap: () {
                      FirebaseAuth.instance.signOut().then((value) {
                        Navigator.pop(context);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Main()),
                              (Route<dynamic> route) => false,
                        );
                      });
                    },
                    leading: Icon(Icons.arrow_back),
                    title: Text("Log out"),
                  ),
                  ListTile(
                    onTap: () {

                    },
                    title: Text("Debug"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pb_ph1/restaurantBottomBar/restaurantAccount.dart';
import 'package:pb_ph1/accountsettings.dart';
import '../Notifications.dart';

class Setting extends StatefulWidget {
  final Color _mainColor;
  final Map _data;

  Setting(this._mainColor, this._data);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  void initState() {
    // this function is called when the page starts
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Settings"),
        backgroundColor: widget._mainColor,
      ),
      bottomNavigationBar: BottomAppBar(
        color: widget._mainColor,
        child: Padding(
          padding: EdgeInsets.all(20),
        ),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            //contentPadding: EdgeInsets.only(left: 20.0, right: 30.0),
            title: Text(
              "Edit Profile",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text("Edit profile name, address and profile photo."),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EditAccountDetails(widget._data, widget._mainColor)));
            },
          ),
          ListTile(
            //contentPadding: EdgeInsets.only(left: 20.0, right: 30.0),
            title: Text(
              "Account Settings",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text("Change your email or delete your account."),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AccountSettingsDetails("Shelter")));
            },
          ),
          ListTile(
            //contentPadding: EdgeInsets.only(left: 20.0, right: 30.0),
            title: Text(
              "Notifications",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text("Define what alerts and notifications you want to see"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Notifications("Shelter")));
            },
          ),
          ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // return object of type Dialog
                  return AlertDialog(
                    //shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
                    backgroundColor: Colors.white,
                    title: new Text("About"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Developers"),
                        SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text("randomText"),
                                Text("randomText"),
                                Text("randomText"),
                                Text("randomText"),

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      new FlatButton(
                        child: new Text("Close"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );},

            title: Text(
              "About",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text("Find out what's new about us here."),

          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/material.dart';

class Stories extends StatefulWidget{
  final Color _mainColor;
  final Map _data;
  Stories(this._mainColor,this._data);

  @override
  StoriesState createState() => StoriesState();
}

class StoriesState extends State<Stories> {

  @override
  void initState() {
    super.initState();
  }
  void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
          backgroundColor: Colors.white,
          title: new Text("Stories coming soon!"),
          content: new Text("Soon you'll be able to share your experiences using Plate Beacon to all your fans!"
              " Be proud of the contributions you've made to help those in need! We Applaud you!"),
          actions: <Widget>[
            new FlatButton(
              child: new
              Text("Sounds good!") ,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stories"),
        backgroundColor: widget._mainColor,
      ),
      bottomNavigationBar: BottomAppBar(
        color: widget._mainColor,
        child: Padding(
          padding: EdgeInsets.all(20),
        ),
      ),
      body: Column (
        children: <Widget>[
          Center(
              child: Container (
                height: 200,
                decoration: BoxDecoration (
                    image: DecorationImage (
                      fit: BoxFit.cover,
                      image: AssetImage('assets/Stories.jpg'),
                    )
                ),
              )
          ),
          Divider(
            height: 10,
            thickness: 5,
            color: widget._mainColor,
            indent: 0.0,
            endIndent: 0.0,
          ),
          Container(
            child: Column (
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
                      alignment: Alignment.topCenter,
                      child: Text(
                        "Share Story",
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight:FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],

            ),

          ),
          Divider(
            height: 40.0,
            thickness: 5,
            color: widget._mainColor,
            indent: 0.0,
            endIndent: 0.0,
          ),
          ListTile(
            onTap: (){
              print("press");
            },
            contentPadding: EdgeInsets.only(left: 20, right: 20),
            leading: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration (
                image: DecorationImage (
                  fit: BoxFit.cover,
                  image: AssetImage('assets/facebook1.png'),
                ),
              ),
            ),
           title: Text("Facebook"),
            trailing: Icon(Icons.more_vert),
          ),

          ListTile(
            onTap: (){
              print("press to instagram");
            },
            contentPadding: EdgeInsets.only(left: 20, right: 20),
            leading: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration (
                image: DecorationImage (
                  fit: BoxFit.cover,
                  image: AssetImage('assets/instagram1.png'),
                ),
              ),
            ),
            title: Text("Instagram"),
            trailing: Icon(Icons.more_vert),
          ),

        ],
      ),
    );
  }
}


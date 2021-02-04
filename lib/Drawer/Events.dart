import 'dart:async';
import 'package:flutter/material.dart';

class Events extends StatefulWidget{
  final Color _mainColor;
  final Map _data;
  Events(this._mainColor,this._data);

  @override
  EventsState createState() => EventsState();
}

class EventsState extends State<Events> {

  @override
  void initState() {
    super.initState();
    //Timer.run(() => _showDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Events"),
        backgroundColor: widget._mainColor,
      ),
      bottomNavigationBar: BottomAppBar(
        color: widget._mainColor,
        child: Padding(
          padding: EdgeInsets.all(20),
        ),
      ),
      body: Column(
        children: <Widget>[
          Center(
              child: Container(
                height: 300,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/shelter.jpg'),
                    )
                ),
              )
          ),

          Container(
            child: Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(top: 30.0, left: 20.0, right: 20.0),
                    alignment: Alignment.topCenter,
                    child: FlatButton(
                      color: Colors.blue,
                      textColor: Colors.white,
                      disabledColor: Colors.grey,
                      disabledTextColor: Colors.black,
                      //shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
                      padding: EdgeInsets.all(10),
                      splashColor: Colors.blueAccent,
                      onPressed: () {
                        showAlertDialog("Schedule for Volunteers", "Details of your event will be posted here and sent out!");
                      },
                      child: Text(
                        "Schedule Volunteer Event",
                        style: TextStyle(fontSize: 20.0),

                      ),
                    )
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20.0),
            alignment: Alignment.topCenter,
            child: FlatButton(
              color: Colors.blue,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              //shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
              padding: EdgeInsets.all(10),
              splashColor: Colors.blueAccent,
              onPressed: () {
                showAlertDialog("Fundraising", "Let's get more awareness of any fundraisers going on too!");
              },
              child: Text(
                "Fundraising",
                style: TextStyle(fontSize: 20.0),
              ),
            )
          )
        ],

      ),
    );
  }

  void showAlertDialog(title, content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          //shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
          backgroundColor: Colors.white,
          title: new Text("${title}"),
          content: new Text("${content}"),
          actions: <Widget>[
            new FlatButton(
              child: new
              Text("Sounds Good"),
              textColor: Colors.blue,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}


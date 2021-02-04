import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditAccountDetails extends StatefulWidget {
  final Map data;
  final Color _mainColor;
  EditAccountDetails(this.data, this._mainColor);

  @override
  _EditAccountDetailsState createState() =>
      _EditAccountDetailsState();
}

class _EditAccountDetailsState extends State<EditAccountDetails> {
  var personName = TextEditingController();
  var email = TextEditingController();
  //var role = TextEditingController();
  var street = TextEditingController();
  var city = TextEditingController();
  var state = TextEditingController();
  var zip = TextEditingController();
  var phone = TextEditingController();
  String citySearch = "";
  String streetSearch = "";
  String collection = "";


  Future<String> _getDataFromSharedPref(key) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(key);
    if (data == null){
      return null;
    }
    return data;
  }

  Future<void> _setSharedPref(key, String) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, String);
  }
  Future<DocumentSnapshot> getDatas()async{
    DocumentSnapshot d;
    String uid = widget.data["uid"];
    _getDataFromSharedPref(uid).then((value) async {
      if (value != null){
        DocumentSnapshot data = jsonDecode(value);
        d = data;
        if (!mounted) return;
        setState(() {
          personName.text = data["displayName"] ?? "";
          email.text = data["email"] ?? "";
          street.text = data["street"] ?? "";
          streetSearch = data["street"] ?? "";
          city.text = data["city"] ?? "";
          citySearch = data["city"] ?? "";
          state.text = data["state"] ?? "";
          zip.text = data["zip"] ?? "";
          phone.text = data["phone"] ?? "";
        });
      }
    });
    return d;
  }
  @override
  void initState() {
    //this function is called when the page starts
    super.initState();
  }

  Future<Map> getData() async {
    Map data;
    String uid = widget.data["uid"];
    String name = widget.data["name"];
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((val) {
      data = val.data();
      setState(() {
        personName.text = name;
        email.text = data["email"] ?? "";
        street.text = data["street"] ?? "";
        streetSearch = data["street"] ?? "";
        city.text = data["city"] ?? "";
        citySearch = data["city"] ?? "";
        state.text = data["state"] ?? "";
        zip.text = data["zip"] ?? "";
        phone.text = data["phone"] ?? "";
      });
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: widget._mainColor,
        child: Padding(
          padding: EdgeInsets.all(20),
        ),
      ),
      appBar: AppBar(
        centerTitle: false,
        elevation: 10.0,
        title: Text("Account"),
        actions: <Widget>[
          Builder(
            builder: (context) => CupertinoButton(
              child: Text("Save", style: TextStyle(color: Colors.white),),
              onPressed: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                Geolocator().placemarkFromAddress(streetSearch + " " + citySearch).then((results) {
                  FirebaseFirestore.instance
                      .collection(collection)
                      .doc(widget.data["uid"])
                      .update({
                        'displayName': personName.text.trim(),
                        'street': results[0].subThoroughfare + " " + results[0].thoroughfare,
                        'city': results[0].locality,
                        'state': results[0].administrativeArea,
                        'zip': results[0].postalCode,
                        'lat': results[0].position.latitude,
                        'long': results[0].position.longitude,
                        'email': email.text.trim(),
                        'phone': phone.text.trim(),
                      }).then((v) {
                        String data = json.encode({'displayName': personName.text.trim(),
                          'street': results[0].subThoroughfare + " " + results[0].thoroughfare,
                          'city': results[0].locality,
                          'state': results[0].administrativeArea,
                          'zip': results[0].postalCode,
                          'lat': results[0].position.latitude,
                          'long': results[0].position.longitude,
                          'email': email.text.trim(),
                          'phone': phone.text.trim()
                        });
                        _setSharedPref(widget.data["uid"], data);
                        setState(() {
                          street.text = results[0].subThoroughfare + " " + results[0].thoroughfare;
                          city.text = results[0].locality;
                          state.text = results[0].administrativeArea;
                          zip.text = results[0].postalCode;
                        });
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Saved Successfully"),
                          ),
                        );
                        //Navigator.of(context).pop();
                      });
                }).catchError((error) {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Text(error.message),
                    ),
                  );
                  //print("Error: " +""+ error.message);
                });
              },
            ),
          ),
        ],
        backgroundColor: widget._mainColor,
      ),
      body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot){
          if(snapshot.hasError){
            return Center(child: Text("Error ${snapshot.error.toString()}"),);
          }
          if(snapshot.hasData){
            return Column(
              children: <Widget>[
                Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  //padding: EdgeInsets.all(20.0),
                  //color: mainColor,
                  child: Stack(
                    children: <Widget>[
                      Opacity(
                        opacity: 0.7,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Image.network(
                            "https://media.timeout.com/images/105239239/image.jpg",
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  backgroundColor: Colors.white,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
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
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(
                            left: 15.0, top: 15.0, right: 15.0, bottom: 5.0),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.info),
                            SizedBox(
                              width: 30.0,
                            ),
                            Expanded(
                              child: TextField(
                                autocorrect: true,
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                controller: personName,
                                decoration: InputDecoration(
                                  hintText: "Restaurant Name",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 15.0, top: 10, right: 15.0, bottom: 5.0),
                        //color: Colors.green,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.location_on),
                            SizedBox(
                              width: 30.0,
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  TextField(
                                    autocorrect: true,
                                    textCapitalization: TextCapitalization.words,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: (_) =>
                                        FocusScope.of(context).nextFocus(),
                                    onChanged: (val){
                                      setState(() {
                                        streetSearch = val;
                                      });
                                    },
                                    controller: street,
                                    decoration: InputDecoration(
                                      hintText: "Street",
                                    ),
                                  ),
                                  TextField(
                                    autocorrect: true,
                                    enableSuggestions: true,
                                    textCapitalization: TextCapitalization.words,
                                    keyboardType: TextInputType.text,
                                    textInputAction: TextInputAction.next,
                                    onSubmitted: (_) =>
                                        FocusScope.of(context).nextFocus(),
                                    onChanged: (val){
                                      citySearch = val;
                                    },
                                    enabled: true,
                                    controller: city,
                                    decoration: InputDecoration(
                                      hintText: "City",
                                    ),
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: TextField(
                                          enabled: false,
                                          controller: state,
                                          decoration: InputDecoration(
                                            hintText: "State",
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10.0,
                                      ),
                                      Expanded(
                                        child: TextField(
                                          enabled: false,
                                          controller: zip,
                                          decoration: InputDecoration(
                                            hintText: "Zip",
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: 15.0, top: 10, right: 15.0, bottom: 5.0),
                        //color: Colors.green,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.email),
                            SizedBox(
                              width: 30.0,
                            ),
                            Expanded(
                              child: TextField(
                                enableSuggestions: true,
                                autocorrect: false,
                                textCapitalization: TextCapitalization.none,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                onSubmitted: (_) =>
                                    FocusScope.of(context).nextFocus(),
                                controller: email,
                                decoration: InputDecoration(
                                  hintText: "Email",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding:
                        EdgeInsets.only(left: 15.0, right: 15.0, bottom: 5.0),
                        //color: Colors.green,
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.phone),
                            SizedBox(
                              width: 30.0,
                            ),
                            Expanded(
                              child: TextField(
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.phone,
                                controller: phone,
                                decoration: InputDecoration(
                                  hintText: "Phone Number",
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          return Center(child: Text("Loading ${snapshot.hasData}"),);
        },
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pb_ph1/Drawer/Help.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  MaterialPageRoute(builder: (context) => EditProfile(widget._data, widget._mainColor)));
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
                      builder: (context) => AccountSettings(widget._mainColor, widget._data)));
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
                  MaterialPageRoute(builder: (context) => Notifications(widget._mainColor, widget._data)));
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


class EditProfile extends StatefulWidget {
  final Map data;
  final Color _mainColor;
  EditProfile(this.data, this._mainColor);

  @override
  _EditProfileState createState() =>
      _EditProfileState();
}
class _EditProfileState extends State<EditProfile> {
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

class AccountSettings extends StatefulWidget {
  final Color _mainColor;
  final Map _data;
  AccountSettings(this._mainColor,this._data);

  @override
  _AccountDetailsState createState() => _AccountDetailsState();
}
class _AccountDetailsState extends State<AccountSettings> {
  var email = TextEditingController();
  String role;
  @override
  void initState() {
    // this function is called when the page starts
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Settings"),
        backgroundColor: widget._mainColor,
      ),
      bottomNavigationBar: BottomAppBar(
        color: widget._mainColor,
        child: Padding(
          padding: EdgeInsets.all(20),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              //margin: EdgeInsets.only(top: 15.0, left: 30.0, right: 15.0),
              child: Column(
                children: <Widget>[
                  ListTile(
                    //contentPadding: EdgeInsets.only(left: 20.0, right: 30.0),
                    title: Text(
                      "Change Email",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text("Change your login and notification email"),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          // return object of type Dialog
                          return AlertDialog(
                            //shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
                            backgroundColor: Colors.white,
                            title: Text("Change Email"),
                            content: TextField(
                              controller: email,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "New Email",
                              ),
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text("Change"),
                                onPressed: () {
                                  print(email.text);
                                  //widget._currentUser.
                                },
                              ),
                              FlatButton(
                                child: Text("Cancel"),
                                //color: Colors.blueAccent,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                  ListTile(
                    //contentPadding: EdgeInsets.only(left: 20.0, right: 30.0),
                    title: Text(
                      "Delete Account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text("Permanently delete my account"),
                    onTap: () {
                      //print(userObject.toString());
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            //shape: RoundedRectangleBorder(borderRadius:  BorderRadius.circular(2)),
                            backgroundColor: Colors.white,
                            title:  Text("Delete Confirmation"),
                            content:  Text(
                                "Are you sure you want to delete"),
                            actions: <Widget>[
                              FlatButton(
                                child:  Text("Yes"),
                                onPressed: () {

                                },
                              ),
                              FlatButton(
                                child:  Text("No"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
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


class Notifications extends StatefulWidget {
  final Color _mainColor;
  final Map _data;
  Notifications(this._mainColor,this._data);

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  bool status = false;
  bool emailStatus = false;
  bool msgStatus = false;
  bool callStatus = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Notifications"),
        backgroundColor: widget._mainColor,
      ),
      bottomNavigationBar: BottomAppBar(
        color: widget._mainColor,
        child: Padding(
          padding: EdgeInsets.all(20),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
              child: Text(
                "Select which apps you want to receive notifications",
                style: TextStyle(
                  fontSize: 15.0,
                  // fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.all(15),
              leading: Icon(Icons.mail,size: 30,),
              title: Text("Email"),
              trailing: Switch(
                  activeColor: widget._mainColor,
                  value: emailStatus,
                  onChanged: (value) {
                    print("VALUE : $value");
                    setState(() {
                      emailStatus = value;
                    });
                  }),
            ),
            Divider(
              height: 0,
              color: widget._mainColor,
            ),
            ListTile(
              contentPadding: EdgeInsets.all(15),
              leading: Icon(Icons.message,size: 30,),
              title: Text("Messages"),
              trailing: Switch(
                  activeColor: widget._mainColor,
                  value: msgStatus,
                  onChanged: (value) {
                    print("VALUE : $value");
                    setState(() {
                      msgStatus = value;
                    });
                  }),
            ),
            Divider(
              height: 0,
              color: widget._mainColor,
            ),
            ListTile(
              contentPadding: EdgeInsets.all(15),
              leading: Icon(Icons.phone,size: 30,),
              title: Text("Calls"),
              trailing: Switch(
                  activeColor: widget._mainColor,
                  value: callStatus,
                  onChanged: (value) {
                    print("VALUE : $value");
                    setState(() {
                      callStatus = value;
                    });
                  }),
            ),
            Divider(
              height: 0,
              color: widget._mainColor,
            ),
          ],
        ),
      ),
    );
  }
  void _showDialog() {
// flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
//      return object of type Dialog
        return AlertDialog(
          elevation: 0.0,
          shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(15)),
          backgroundColor:Colors.white,
          title: new Text("Notifications coming soon!"),

          content: new Text("Eventually, you will be able to pick and choose the notification methods you like"
              " in order to recieve information from Plate Beacon!"),
          actions: <Widget>[
// usually buttons at the bottom of the dialog
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
  }
}
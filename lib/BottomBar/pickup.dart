import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Pickup extends StatefulWidget {
  @override
  _PickupState createState() => _PickupState();
}

class _PickupState extends State<Pickup> {
  @override
  void initState() {
    //this function is called when the page starts
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("This third Screen"),);
  }
}

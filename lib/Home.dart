import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
//client and restaurant homescreens exist in this file
class ClientHomeScreen extends StatefulWidget {
  @override
  _ClientHomeScreenState createState() => _ClientHomeScreenState();
}
class _ClientHomeScreenState extends State<ClientHomeScreen> {
  @override
  Widget build(BuildContext context) {
    //replace with customer screen
    return Center(child: Text("Client Home Screen"),);
  }
}



class RestaurantHomeScreen extends StatefulWidget {
  @override
  _RestaurantHomeScreenState createState() => _RestaurantHomeScreenState();
}
class _RestaurantHomeScreenState extends State<RestaurantHomeScreen> {

  @override
  void initState() {
    // this function is called when the page starts
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Restaurant Home Screen"),);
  }
}


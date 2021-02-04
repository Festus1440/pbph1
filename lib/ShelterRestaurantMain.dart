import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pb_ph1/Home.dart';
import 'package:pb_ph1/restaurantBottomBar/pickup.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ShelterDrawer/Settings.dart';
import 'drawers.dart';
import 'Gmap.dart';
import 'package:pb_ph1/ShelterDrawer/Settings.dart';


class ShelterRestaurantMain extends StatefulWidget {
  final Map data;
  ShelterRestaurantMain(this.data);

  @override
  _ShelterRestaurantMainState createState() => _ShelterRestaurantMainState();
}

class _ShelterRestaurantMainState extends State<ShelterRestaurantMain> {
  String name = "Name";
  String city = "City";
  String state = "State";
  Color _active = Colors.white;
  Color _inactive = Colors.black;
  bool _isShelter;
  Color _mainColor;

  Completer<GoogleMapController> _mapController = Completer();

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

  Future<void> _deleteData(key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  @override
  void initState() {
    super.initState();
    _isShelter = widget.data["role"] == "Shelter" ? true : false;
    _mainColor = widget.data["role"] == "Shelter" ? Colors.blue : Colors.green;
  }

  List<Widget> _buildScreens() {
    return [
      widget.data["role"] == "Shelter" ? ShelterHomeScreen() : RestaurantHomeScreen(),
      GMap(),
      Pickup(),
    ];
  }

  PersistentTabController _controller;

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        activeColor: _active,
        inactiveColor: _inactive,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.location_on_rounded),
        title: ("Map"),
        activeColor: _active,
        inactiveColor: _inactive,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(widget.data["role"] == "Shelter" ? Icons.shopping_basket: CupertinoIcons.heart),
        title: widget.data["role"] == "Shelter" ? ("Pickups"): ("Donations"),
        activeColor: _active,
        inactiveColor: _inactive,
      ),
    ];
  }

  int _bottomBarIndex = 0;
  String appBarTitle = "Home";

  void _onItemTapped(int index) {
    _bottomBarIndex = index;
    switch (index) {
      case 0:
        appBarTitle = "Home";
        break;
      case 1:
        appBarTitle = "Map";
        break;
      case 2:
        appBarTitle = "Pickups";
        break;
      case 3:
        appBarTitle = "Account";
        break;
      default:
        appBarTitle = "Home";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: _mainColor,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        navBarHeight: MediaQuery.of(context).viewInsets.bottom > 0
            ? 0.0
            : kBottomNavigationBarHeight,
        hideNavigationBarWhenKeyboardShows: true,
        //margin: EdgeInsets.all(10.0),
        popActionScreens: PopActionScreensType.once,
        bottomScreenMargin: 0.0,
        //hideNavigationBar: _hideNavBar,
        decoration: NavBarDecoration(
          colorBehindNavBar: Colors.indigo,
          //borderRadius: BorderRadius.circular(20.0)
        ),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style6, // Choose the nav bar style with this property
      ),
      appBar: AppBar(
        elevation: 10.0,
        title: Text(appBarTitle),
        backgroundColor: _mainColor,
        actions: [
          IconButton(icon: Icon(Icons.settings),
            onPressed: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Setting(_mainColor, widget.data)));
            },)
        ],
      ),
      drawer: Drawers(_mainColor,name, state, city, widget.data),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:vgo/screens/login.dart';
import 'package:vgo/screens/profile.dart';

class NavigationScreen extends StatefulWidget {
  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  bool isLogged = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: isLogged ? ProfileScreen() : Login(),
      ),
    );
  }
}

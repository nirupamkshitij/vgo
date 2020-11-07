import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tik_tok_demo/utilities/constants.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      print('Connectedddddddddddd');
      setState(() {});
    });
    Timer(Duration(seconds: 3), () {
      Navigator.pushNamed(context, 'navigation');
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Container(),
            Container(
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                      top: height * 0.15,
                    ),
                    child: Image(
                      image: AssetImage('images/tik-tok.png'),
                      fit: BoxFit.contain,
                      height: 100,
                      width: 100,
                    ),
                  ),
                  Center(
                    child: Text(
                      "Vgo",
                      style: GoogleFonts.archivoBlack(
                        textStyle: TextStyle(
                          fontSize: 36,
                          color: mainBgColor,
                        ),
                      ),
                    ),
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

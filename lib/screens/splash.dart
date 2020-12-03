import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vgo/screens/login.dart';
import 'package:vgo/screens/profile.dart';
import 'package:vgo/utilities/constants.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return StreamBuilder<User>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User user = snapshot.data;
          if (user == null) {
            print("USER LOGGED OUT");
            return Login();
          }
          print("USER LOGGED IN");
          return ProfileScreen();
        } else {
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
                            "Yo Video",
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
      },
    );
  }
}

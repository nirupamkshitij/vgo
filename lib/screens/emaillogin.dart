import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vgo/utilities/constants.dart';

class EmailLogin extends StatefulWidget {
  @override
  _EmailLoginState createState() => _EmailLoginState();
}

final _auth = FirebaseAuth.instance;
String userPass = '';
String userMail = '';

class _EmailLoginState extends State<EmailLogin> {
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    Firebase.initializeApp().whenComplete(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          backgroundColor: bottomContainerColor,
          centerTitle: true,
          title: Text(
            'Log in to TikTok',
            style: GoogleFonts.raleway(
              fontSize: 18,
              color: mainBgColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Container(
          color: bottomContainerColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.1,
                  left: 25,
                  right: 25,
                ),
                child: TextField(
                  controller: _mailController,
                  onChanged: (value) {
                    setState(() {
                      userMail = value;
                    });
                  },
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                    color: mainBgColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: darkFadeTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    border: InputBorder.none,
                    labelText: 'Enter Email',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 25,
                  left: 25,
                  right: 25,
                ),
                child: TextField(
                  controller: _passController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  onChanged: (value) {
                    setState(() {
                      userPass = value;
                    });
                  },
                  style: TextStyle(
                    color: mainBgColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    labelStyle: TextStyle(
                      color: darkFadeTextColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    border: InputBorder.none,
                    labelText: 'Enter Password',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.4,
                  left: 25,
                  right: 25,
                ),
                child: ButtonTheme(
                  height: 50,
                  minWidth: double.infinity,
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                        side: BorderSide(),
                        borderRadius: BorderRadius.circular(5)),
                    color: buttonBgColor,
                    onPressed: () async {
                      try {
                        final result =
                            await InternetAddress.lookup('google.com');
                        if (result.isNotEmpty &&
                            result[0].rawAddress.isNotEmpty) {
                          try {
                            if (userMail == '' || userPass == '') {
                              _scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  backgroundColor: errorCardColor,
                                  content: Text(
                                    'Please Enter Your Credentials ',
                                    style: GoogleFonts.raleway(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  duration: Duration(seconds: 3),
                                ),
                              );
                            } else {
                              try {
                                UserCredential newUser =
                                    await _auth.signInWithEmailAndPassword(
                                        email: userMail, password: userPass);
                                if (newUser != null) {
                                  Navigator.pushNamed(context, 'home');
                                }
                                // final SharedPreferences prefs =
                                //     await SharedPreferences
                                //         .getInstance();
                                // prefs.setString('adminname', userMail);
                                // prefs.setString(
                                //     'adminPassword', userPassword);
                                // prefs.setBool('isAdminReady', true);

                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    backgroundColor: errorCardColor,
                                    content: Text(
                                      'No user found for that email',
                                      style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    duration: Duration(seconds: 3),
                                  ));
                                } else if (e.code == 'wrong-password') {
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    backgroundColor: errorCardColor,
                                    content: Text(
                                      'Wrong password provided for that user',
                                      style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    duration: Duration(seconds: 3),
                                  ));
                                }
                              }
                            }
                          } catch (e) {
                            print(e);
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              backgroundColor: errorCardColor,
                              content: Text(
                                'Wrong Username/Password ',
                                style: GoogleFonts.raleway(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              duration: Duration(seconds: 3),
                            ));
                          }
                        }
                      } catch (e) {
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          backgroundColor: errorCardColor,
                          content: Text(
                            'Check your Internet Connection ',
                            style: GoogleFonts.raleway(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          duration: Duration(seconds: 3),
                        ));
                      }
                    },
                    child: Text(
                      'Login',
                      style: GoogleFonts.raleway(
                        fontSize: 18,
                        color: mainBgColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

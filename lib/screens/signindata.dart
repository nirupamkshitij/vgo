import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vgo/screens/userinfo.dart';
import 'package:vgo/screens/verification.dart';
import 'package:vgo/utilities/constants.dart';

class SignInData extends StatefulWidget {
  @override
  _SignInDataState createState() => _SignInDataState();
}

String userName = '';
String userMail = '';
String userPass = '';
int userNumber = 0;
final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class _SignInDataState extends State<SignInData> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
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
        appBar: AppBar(
          backgroundColor: bottomContainerColor,
          centerTitle: true,
          title: Text(
            'Sign Up',
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
                  top: 25,
                  left: 25,
                  right: 25,
                ),
                child: TextField(
                  controller: _nameController,
                  onChanged: (value) {
                    setState(() {
                      userName = value;
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
                    labelText: 'Full Name',
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
                  controller: _idController,
                  onChanged: (value) {
                    setState(() {
                      userId = value;
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
                    labelText: 'User Id',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 15,
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
                    labelText: 'Email',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 15,
                  left: 25,
                  right: 25,
                ),
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: _numberController,
                  onEditingComplete: () {
                    setState(() {
                      userNumber = int.parse(_numberController.text);
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
                    labelText: 'Phone Number',
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 15,
                  left: 25,
                  right: 25,
                ),
                child: TextField(
                  keyboardType: TextInputType.visiblePassword,
                  controller: _passController,
                  onEditingComplete: () {
                    setState(() {
                      userPass = _passController.text;
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
                  top: MediaQuery.of(context).size.height * 0.2,
                ),
                child: Text(
                  """We'll send OTP verification on
above given mail Id""",
                  style: TextStyle(
                    color: darkFadeTextColor,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 15,
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
                            if (userMail == '' ||
                                userPass == '' ||
                                userName == '' ||
                                userId == '') {
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
                                    await _auth.createUserWithEmailAndPassword(
                                  email: userMail,
                                  password: userPass,
                                );
                                if (newUser != null) {
                                  print(newUser);
                                  await _firestore
                                      .collection('user')
                                      .doc(userId)
                                      .set({
                                    'name': userName,
                                    'phone': userNumber,
                                    'userId': userId,
                                    'mail': userMail,
                                  });
                                  print('uploaded');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => Verification(
                                        email: userMail,
                                        name: userName,
                                        number: userNumber,
                                      ),
                                    ),
                                  );
                                }
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  print('The password provided is too weak.');
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    backgroundColor: errorCardColor,
                                    content: Text(
                                      'The password provided is too weak.',
                                      style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    duration: Duration(seconds: 3),
                                  ));
                                } else if (e.code == 'email-already-in-use') {
                                  print(
                                      'The account already exists for that email.');
                                  _scaffoldKey.currentState
                                      .showSnackBar(SnackBar(
                                    backgroundColor: errorCardColor,
                                    content: Text(
                                      'The account already exists for that email.',
                                      style: GoogleFonts.raleway(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    duration: Duration(seconds: 3),
                                  ));
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
                      'Continue',
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

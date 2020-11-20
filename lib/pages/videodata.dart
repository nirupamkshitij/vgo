import 'dart:io';

import 'package:flutter/material.dart';
import 'package:vgo/utilities/constants.dart';

class VideoDetailsData extends StatefulWidget {
  VideoDetailsData({@required this.url, @required this.docId});
  final String url;
  final String docId;
  @override
  _VideoDetailsDataState createState() => _VideoDetailsDataState();
}

class _VideoDetailsDataState extends State<VideoDetailsData> {
  final _nameController = TextEditingController();
  final _songController = TextEditingController();
  final _artistController = TextEditingController();
  final _tagsController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  _dataUpdates() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          if (_nameController.text == '' ||
              _songController.text == '' ||
              _artistController == '' ||
              _tagsController.text == '' ||
              _nameController.text == null ||
              _songController.text == null ||
              _artistController == null ||
              _tagsController.text == null) {
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                backgroundColor: errorCardColor,
                content: Text(
                  'Please Fill in the Data ',
                  style: GoogleFonts.raleway(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                duration: Duration(seconds: 3),
              ),
            );
          } else {
            try {
              await _firestore.collection('user').doc(userMail).set({
                'name': userName,
                'phone': userNumber,
                'userId': userId,
                'mail': userMail,
                'dpURl': userURL,
                'userBio': userBio,
              });
              print('uploaded');
              Navigator.pushNamed(context, 'home');
            } on FirebaseException catch (e) {
              print(e.code);
              if (e.code == 'weak-password') {
                print('The password provided is too weak.');
                _scaffoldKey.currentState.showSnackBar(SnackBar(
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
                print('The account already exists for that email.');
                _scaffoldKey.currentState.showSnackBar(SnackBar(
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
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Container(
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
                  child: TextFormField(
                    controller: _nameController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: TextStyle(
                      fontSize: 16,
                      color: mainBgColor,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: darkFadeTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      border: InputBorder.none,
                      labelText: 'Video Name',
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                      top: 25,
                      left: 25,
                      right: 25,
                    ),
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 16,
                        color: mainBgColor,
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        labelStyle: TextStyle(
                          color: darkFadeTextColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        border: InputBorder.none,
                        labelText: 'Video Artist',
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.only(
                    top: 25,
                    left: 25,
                    right: 25,
                  ),
                  child: TextFormField(
                    controller: _songController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    onChanged: (value) {
                      setState(() {});
                    },
                    style: TextStyle(
                      fontSize: 16,
                      color: mainBgColor,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: darkFadeTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      border: InputBorder.none,
                      labelText: 'Song',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 25,
                    left: 25,
                    right: 25,
                  ),
                  child: TextFormField(
                    controller: _artistController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    onEditingComplete: () {
                      setState(() {});
                    },
                    style: TextStyle(
                      fontSize: 16,
                      color: mainBgColor,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        color: darkFadeTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      border: InputBorder.none,
                      labelText: 'tags',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

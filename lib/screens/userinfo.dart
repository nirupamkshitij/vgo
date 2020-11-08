import 'dart:io';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vgo/utilities/constants.dart';

final _bioController = TextEditingController();
final _passwordController = TextEditingController();
final _confirmController = TextEditingController();
String userBio = '';
String userId = '';
String userPassword = '';
String userConfirmPassword = '';
String userName = '';
String userMail = '';
int userNumber = 0;
String userURL = '';
var userImage;
final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;

class UserProfileInfo extends StatefulWidget {
  _UserProfileInfoState createState() => _UserProfileInfoState();
}

class _UserProfileInfoState extends State<UserProfileInfo> {
  // ignore: avoid_init_to_null
  File _image = null;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final picker = ImagePicker();
  _imgFromCamera() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );
    setState(
      () {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      },
    );
  }

  _dataUpdates() async {
    await _fileUploader();
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        try {
          if (userMail == '' ||
              userBio == '' ||
              userName == '' ||
              userId == '' ||
              userNumber == 0 ||
              userURL == '' ||
              userImage == null) {
            print(userMail);
            print(userBio);
            print(userName);
            print(userId);
            print(userNumber);
            print(userURL);
            print(userImage);
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

  Future<Null> _cropImage() async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: _image.path,
        aspectRatioPresets: Platform.isAndroid
            ? [
                CropAspectRatioPreset.square,
              ]
            : [
                CropAspectRatioPreset.square,
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Please Crop Image',
            toolbarColor: bottomContainerColor,
            toolbarWidgetColor: buttonBgColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Cropper',
        ));
    if (croppedFile != null) {
      setState(() {
        _image = croppedFile;
        userImage = _image;
      });
    }
  }

  _imgFromGallery() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 50,
    );

    setState(
      () {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
          _cropImage();
        } else {
          print('No image selected.');
        }
      },
    );
  }

  Future _fileUploader() async {
    if (_image != null) {
      final storageReference =
          FirebaseStorage.instance.ref().child('$userMail/dp');
      final UploadTask uploadTask = storageReference.putFile(_image);
      await uploadTask.whenComplete(() async {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: okCardColor,
          content: Text(
            'Profile Picture Updated',
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.w700,
            ),
          ),
          duration: Duration(seconds: 3),
        ));
        userURL = await (storageReference.getDownloadURL());
        print(userURL);
      });
    } else {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: errorCardColor,
        content: Text(
          'No File',
          style: GoogleFonts.raleway(
            fontWeight: FontWeight.w700,
          ),
        ),
        duration: Duration(seconds: 3),
      ));
    }
  }

  @override
  void initState() {
    getUserMail();
    super.initState();
  }

  void getUserMail() async {
    try {
      userMail = _auth.currentUser.email;
      try {
        await _firestore.collection("user").doc(userMail).get().then((value) {
          setState(() {
            userName = value.data()['name'];
            userMail = value.data()['mail'];
            userNumber = value.data()['phone'];
            userId = value.data()['userId'];
            try {
              userImage = value.data()['dpURl'];
            } catch (e) {
              userImage = null;
            }
            print('Got Data');
          });
        });
      } catch (e) {
        print(e);
        _scaffoldKey.currentState.showSnackBar(SnackBar(
            backgroundColor: errorCardColor,
            content: Text(
              'An error occurred. Please try again later.',
              style: TextStyle(color: fadeTextColor),
            ),
            duration: Duration(seconds: 3)));
      }
    } catch (e) {
      print(e);
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          backgroundColor: errorCardColor,
          content: Text(
            'An error occurred. Please try again later.',
            style: TextStyle(color: fadeTextColor),
          ),
          duration: Duration(seconds: 3)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        floatingActionButton: Padding(
          padding: EdgeInsets.only(
            top: 15,
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: FloatingActionButton(
              heroTag: "btn2",
              backgroundColor: bottomContainerColor,
              onPressed: () {
                _dataUpdates();
                // Navigator.popAndPushNamed(context, 'home');
              },
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return RadialGradient(
                    center: Alignment.center,
                    radius: 0.5,
                    colors: <Color>[
                      buttonBgColor,
                      buttonBgColor,
                    ],
                    tileMode: TileMode.repeated,
                  ).createShader(bounds);
                },
                child: Text(
                  'Save',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        backgroundColor: bottomContainerColor,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        _showPicker(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(top: 25),
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.file(
                                  _image,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.fitHeight,
                                ),
                              )
                            : userImage == null
                                ? Container(
                                    decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    width: 100,
                                    height: 100,
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey[800],
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: Image.network(
                                      userImage,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "Change Profile Pic",
                      style: TextStyle(
                        color: darkFadeTextColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.250),
              child: Tabbar(
                userNumber: userNumber,
                userMail: userMail,
                userName: userName,
                userId: userId,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}

mixin StorageUploadTask {}

class Tabbar extends StatefulWidget {
  const Tabbar({
    @required this.userMail,
    @required this.userName,
    @required this.userNumber,
    @required this.userId,
  });
  final String userName;
  final String userMail;
  final int userNumber;
  final String userId;
  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          backgroundColor: bottomContainerColor,
          appBar: TabBar(
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: buttonBgColor,
            unselectedLabelColor: darkFadeTextColor,
            indicatorColor: buttonBgColor,
            tabs: [
              Tab(
                child: Container(
                  child: Text(
                    'Profile Info',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  child: Text(
                    'Account Info',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
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
                          controller: _bioController,
                          onChanged: (value) {
                            setState(() {
                              userBio = value;
                            });
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
                            labelText: 'Bio',
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
                            enabled: false,
                            initialValue: widget.userId,
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
                              labelText: 'Username',
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 25,
                          left: 25,
                          right: 25,
                        ),
                        child: TextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              userPassword = value;
                            });
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
                            labelText: 'Enter Password',
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
                          controller: _confirmController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          onEditingComplete: () {
                            setState(() {
                              userConfirmPassword = _confirmController.text;
                            });
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
                            labelText: 'Confirm Password',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
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
                        enabled: false,
                        initialValue: widget.userName,
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
                      child: TextFormField(
                        enabled: false,
                        initialValue: widget.userMail,
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
                          labelText: 'Email',
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
                        enabled: false,
                        initialValue: widget.userNumber.toString(),
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
                          labelText: 'Phone Number',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

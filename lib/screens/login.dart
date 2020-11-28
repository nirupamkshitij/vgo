import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_twitter_login/flutter_twitter_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vgo/screens/signin.dart';
import 'package:vgo/utilities/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(10.0),
          child: FloatingActionButton(
            mini: true,
            heroTag: "btn1",
            elevation: 0,
            onPressed: () {},
            child: Icon(
              Icons.help_outline_rounded,
              size: 26.0,
              color: fadeTextColor,
            ),
            backgroundColor: mainBgColor,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        body: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.only(top: height * 0.155, bottom: height * 0.05),
              child: Column(
                children: [
                  Center(
                    child: Text(
                      'Log in to TikTok',
                      style: GoogleFonts.raleway(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: mainTextColor,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      '''Manage your account, check notifications,
comment on videos, and more.''',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: fadeTextColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SignInButton(
                    Buttons.Email,
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.02, horizontal: width * 0.1),
                    text: "Log in with Email",
                    onPressed: () {
                      Navigator.pushNamed(context, 'email');
                    },
                    elevation: 5,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SignInButton(
                    Buttons.Facebook,
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.02, horizontal: width * 0.1),
                    text: "Log in with Facebook",
                    onPressed: () async {
                      await signInWithFacebook();
                      // Navigator.pushReplacementNamed(context, 'profile');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SignInButton(
                    Buttons.Google,
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.01, horizontal: width * 0.1),
                    text: "Log in with Google",
                    onPressed: () async {
                      await signInWithGoogle();
                      // Navigator.pushReplacementNamed(context, 'profile');
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SignInButton(
                    Buttons.Twitter,
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.02, horizontal: width * 0.1),
                    text: "Log in with Twitter",
                    onPressed: () async {
                      await signInWithTwitter();
                      print(
                          "USER IS ${FirebaseAuth.instance.currentUser.toString()}");
                      // Navigator.pushReplacementNamed(context, 'profile');
                    },
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding:
                    EdgeInsets.only(bottom: height * 0.025, top: height * 0.29),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '''Don't have an account?  ''',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.raleway(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: mainTextColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          CupertinoPageRoute<bool>(
                            builder: (BuildContext context) => SignIn(),
                          ),
                        );
                      },
                      child: Text(
                        '''Sign Up''',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: redColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<UserCredential> signInWithTwitter() async {
    // Create a TwitterLogin instance
    final TwitterLogin twitterLogin = new TwitterLogin(
      consumerKey: 'zVZRE5g6kceMfBcdMjuIWor9N',
      consumerSecret: 'Krl2pCWfjMcnRLdm7EqXfelP8Ng3d1Mf427PFHkw4qDbFR2l1u',
    );

    // Trigger the sign-in flow
    final TwitterLoginResult loginResult = await twitterLogin.authorize();
    print("ERROR IS");
    print(loginResult.errorMessage);
    print(loginResult.status);
    if (loginResult.status == TwitterLoginStatus.loggedIn) {
      // Get the Logged In session
      final TwitterSession twitterSession = loginResult.session;

      // Create a credential from the access token
      final AuthCredential twitterAuthCredential =
          TwitterAuthProvider.credential(
              accessToken: twitterSession.token, secret: twitterSession.secret);

      // Once signed in, return the UserCredential

      return await FirebaseAuth.instance
          .signInWithCredential(twitterAuthCredential);
    } else if (loginResult.status == TwitterLoginStatus.cancelledByUser) {
      Fluttertoast.showToast(
          msg: 'Login cancelled',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: errorCardColor,
          textColor: Colors.white,
          fontSize: 16.0);
    } else if (loginResult.status == TwitterLoginStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: errorCardColor,
          content: Text(
            'An error occured',
            style: GoogleFonts.raleway(
              fontWeight: FontWeight.w700,
            ),
          ),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final GoogleAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    // await _firestore.collection('user').doc(userMail).set({
    //   'name': userName,
    //   'phone': userNumber,
    //   'userId': userId,
    //   'mail': userMail,
    // });
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    final AccessToken result = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final FacebookAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(result.token);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance
        .signInWithCredential(facebookAuthCredential);
  }
}

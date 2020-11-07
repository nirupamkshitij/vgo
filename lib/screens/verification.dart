import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vgo/screens/userinfo.dart';
import 'package:vgo/utilities/constants.dart';

class Verification extends StatefulWidget {
  Verification(
      {@required this.name, @required this.email, @required this.number});
  final String name;
  final String email;
  final int number;
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  Timer _timer;
  bool isReady = false;
  final TextEditingController _textEditingController = TextEditingController();
  int currentSeconds = 0;
  final interval = const Duration(seconds: 1);
  final int timerMaxSeconds = 120;

  String get timerText =>
      '${((timerMaxSeconds - currentSeconds) ~/ 60).toString().padLeft(2, '0')}: ${((timerMaxSeconds - currentSeconds) % 60).toString().padLeft(2, '0')}';

  startTimeout([int milliseconds]) {
    var duration = interval;
    _timer = Timer.periodic(duration, (timer) {
      setState(() {
        currentSeconds = timer.tick;
        if (timer.tick >= timerMaxSeconds) {
          timer.cancel();
          setState(() {
            isReady = true;
          });
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startTimeout();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        dispose();
        Navigator.popAndPushNamed(context, 'signin');
        return Future.value(false);
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: false,
          appBar: AppBar(
            backgroundColor: bottomContainerColor,
            centerTitle: true,
            title: Text(
              'Verification',
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
                      top: MediaQuery.of(context).size.height * 0.1),
                  child: Text(
                    """Hi """ +
                        widget.name +
                        """\n
Enter 6 Digit Verification code sent on
below given mail Id
""" +
                        widget.email,
                    style: TextStyle(
                      color: darkFadeTextColor,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 25,
                    left: 25,
                    right: 25,
                  ),
                  child: TextField(
                    controller: _textEditingController,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    style: TextStyle(
                      color: mainBgColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      labelStyle: TextStyle(
                        color: darkFadeTextColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      border: InputBorder.none,
                      labelText: 'Verification Code',
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.40,
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => UserInfo(
                              userMail: widget.email,
                              userName: widget.name,
                              userNumber: widget.number,
                              userImage: null,
                              userId: null,
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'Submit',
                        style: GoogleFonts.raleway(
                          fontSize: 18,
                          color: mainBgColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 25,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          isReady ? print('yes') : print('no');
                        },
                        child: Text(
                          'Resend',
                          style: GoogleFonts.raleway(
                            fontSize: 18,
                            color: isReady ? buttonBgColor : darkFadeTextColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Text(
                        timerText,
                        style: GoogleFonts.raleway(
                          fontSize: 18,
                          color: mainBgColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

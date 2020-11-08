import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tik_tok_demo/utilities/constants.dart';

class Terms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: bottomContainerColor,
          centerTitle: true,
          title: Text(
            'Terms & Conditions',
            style: GoogleFonts.raleway(
              fontSize: 18,
              color: mainBgColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        backgroundColor: bottomContainerColor,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Vel facilisis volutpat est velit egestas dui id ornare arcu. Ut diam quam nulla porttitor massa id neque. Facilisis magna etiam tempor orci eu lobortis elementum nibh tellus. Cursus sit amet dictum sit amet justo donec.\n \nEu lobortis elementum nibh tellus molestie. Purus in massa tempor nec feugiat nisl pretium fusce id. Quisque egestas diam in arcu cursus euismod quis viverra. Odio aenean sed adipiscing diam donec adipiscing tristique. Interdum varius sit amet mattis vulputate enim nulla. Mattis rhoncus urna neque viverra justo nec ultrices dui sapien. Arcu cursus euismod quis viverra nibh cras.',
                style: TextStyle(
                  color: mainBgColor,
                  fontSize: 14,
                ),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

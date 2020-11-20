import 'package:flutter/material.dart';
import 'package:vgo/utilities/constants.dart';

class VideoDetailsData extends StatefulWidget {
  @override
  _VideoDetailsDataState createState() => _VideoDetailsDataState();
}

class _VideoDetailsDataState extends State<VideoDetailsData> {
  final _nameController = TextEditingController();
  final _songController = TextEditingController();
  final _artistController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
                  labelText: 'Confirm Password',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class VideoDeatilsData extends StatefulWidget {
  @override
  _VideoDeatilsDataState createState() => _VideoDeatilsDataState();
}

class _VideoDeatilsDataState extends State<VideoDeatilsData> {
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
    );
  }
}

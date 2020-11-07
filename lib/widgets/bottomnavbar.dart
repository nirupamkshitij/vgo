import 'package:flutter/material.dart';
import 'package:vgo/utilities/constants.dart';

customIcon() {
  return Container(
    width: 45,
    height: 27,
    child: Stack(
      children: [
        Container(
          margin: EdgeInsets.only(left: 10),
          width: 38,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 250, 45, 108),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        Container(
          margin: EdgeInsets.only(right: 10),
          width: 38,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 32, 211, 234),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        Center(
          child: Container(
            child: Container(
              height: double.infinity,
              width: 38,
              decoration: BoxDecoration(
                color: mainBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.add,
              ),
            ),
          ),
        )
      ],
    ),
  );
}

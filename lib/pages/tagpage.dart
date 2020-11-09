import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tik_tok_demo/utilities/constants.dart';

class TagPage extends StatefulWidget {
  TagPage({@required this.tagKey});
  final String tagKey;
  @override
  _TagPageState createState() => _TagPageState();
}

class _TagPageState extends State<TagPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: bottomContainerColor,
          title: Text(
            widget.tagKey,
            style: GoogleFonts.raleway(
              fontSize: 18,
              color: mainBgColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Container(
          color: bottomContainerColor,
          child: GridView.count(
            crossAxisCount: 3,
            children: List.generate(50, (index) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 3.0, color: bottomContainerColor),
                  color: bottomContainerColor,
                ),
                constraints: BoxConstraints.expand(width: 120),
                child: Image.network(
                  'https://picsum.photos/id/${index + 450}/540/810',
                  repeat: ImageRepeat.repeatX,
                  fit: BoxFit.contain,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

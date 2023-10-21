import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  final String text;
  final double size;
  final Color fontColor;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final String fontFamily;
  final int maxlines;

  const SmallText({
    super.key,
    required this.text,
    this.size = 12.0,
    this.fontColor = const Color.fromARGB(255, 0, 0, 0),
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    // this.fontFamily = "font-variant-caps: small-caps"
    this.fontFamily = "Poppins",
    this.maxlines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxlines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontFamily: fontFamily,
        color: fontColor,
      ),
    );
  }
}

import 'package:flutter/material.dart';

class BigText extends StatelessWidget {
  final String text;
  final double size;
  final Color fontColor;
  final FontWeight fontWeight;
  final int maxlines;
  
  const BigText({
    super.key,
    required this.text,
    this.size = 30.0,
    this.fontColor = const Color.fromARGB(255, 0, 0, 0),
    this.fontWeight = FontWeight.bold,
    this.maxlines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: maxlines,
      overflow: TextOverflow.ellipsis,
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: fontWeight,
        fontFamily: "Poppins",
        color: fontColor,
      ),
    );
  }
}

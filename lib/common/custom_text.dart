import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    required this.text,
    this.textColor,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.overflow,
    this.maxline,
    this.textAlign,
    Key? key,
  }) : super(key: key);

  final String text;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final TextOverflow? overflow;
  final int? maxline;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      maxLines: maxline,
      textAlign: textAlign,
      style: TextStyle(
        color: textColor ?? Colors.black,
        fontSize: fontSize ?? 14,
        fontWeight: fontWeight,
        fontFamily: fontFamily ?? 'Poppins',
      ),
    );
  }
}

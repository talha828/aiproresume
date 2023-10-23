import 'package:flutter/material.dart';

import 'colors.dart';
import 'custom_text.dart';



class ElevatedButtonIcon extends StatelessWidget {
  final IconData icon;
  final String? label;
  final VoidCallback onPressed;
  final double? height;
  final Color? color;

  const ElevatedButtonIcon(
      {Key? key,
      required this.icon,
      this.label,
      required this.onPressed,
      this.height,
      this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 55,
      child: ElevatedButton.icon(
        style:
            ElevatedButton.styleFrom(backgroundColor: color ?? Mycolors().blue),
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white),
        label: CustomText(
          text: label ?? '',
          textColor: Colors.white,
        ),
      ),
    );
  }
}

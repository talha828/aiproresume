import 'package:flutter/material.dart';
import 'colors.dart';

// ignore: must_be_immutable
class CustomButton extends StatelessWidget {
  CustomButton({
    required this.onTap,
    required this.buttonText,
    this.sizeHeight,
    required this.sizeWidth,
    this.buttonColor,
    this.boderRadius,
    this.textColor,
    this.borderColor,
    this.icon,
    this.iconColor,
    this.isIcon = false,
    this.fontFamily,
    Key? key,
  }) : super(key: key);

  VoidCallback onTap;
  Color? buttonColor;
  double? boderRadius;
  Color? textColor;
  String buttonText;
  Color? borderColor;
  IconData? icon;
  bool? isIcon;
  Color? iconColor;
  double? sizeHeight;
  double sizeWidth;
  String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: sizeHeight ?? 45,
      width: sizeWidth,
      decoration: BoxDecoration(
        color: buttonColor ?? Mycolors().blue,
        borderRadius: BorderRadius.circular(boderRadius ?? 8),
        border: Border.all(
          color: borderColor ?? Colors.transparent,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: isIcon == false
                  ? Text(
                      buttonText,
                      style: TextStyle(
                        color: textColor ?? Colors.white,
                        fontSize: 14,
                      ),
                    )
                  : Icon(
                      icon,
                      color: iconColor,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

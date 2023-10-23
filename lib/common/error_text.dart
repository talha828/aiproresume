import 'package:flutter/material.dart';
class ErrorText{
String? errorText(controller) {
  // at any time, we can get the text from _controller.value.text
  final text = controller.value.text;
  // Note: you can do your own custom validation here
  // Move this logic this outside the widget for more testable code
  if (text.isEmpty) {
    return 'Can\'t be empty';
  }

  if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(controller.value.text)) {
    return "Enter a valid input";
  }

  // return null if the text is valid
  return null;
}
String? errorTextEmail(controller) {
  // at any time, we can get the text from _controller.value.text
  final text = controller.value.text;
  // Note: you can do your own custom validation here
  // Move this logic this outside the widget for more testable code
  if (text.isEmpty) {
    return 'Can\'t be empty';
  }

  if (!RegExp(
                          r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                      .hasMatch(controller.value.text)) {
                    return "Enter a valid email address";
                  }

  // return null if the text is valid
  return null;
}
}

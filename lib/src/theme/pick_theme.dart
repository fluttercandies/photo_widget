import 'package:flutter/material.dart';

class PickTheme {
  final Color backgroundColor;
  final Color primaryColor;
  final Color textColor;
  final Color disableColor;

  const PickTheme({
    this.primaryColor = Colors.blue,
    this.textColor = Colors.white,
    this.disableColor = const Color(0xff8B8B8B),
    this.backgroundColor = const Color(0xFF333333),
  });
}

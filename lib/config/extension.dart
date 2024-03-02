import 'package:flutter/cupertino.dart';

extension PasswordValidator on String {
  bool isValidPassword() {
    return isNotEmpty && length >= 6;
  }
}

double kLeftindentation = 25;
double kFieldSeparator = 15;
Color primaryColor = const Color(0xff2C74F5);

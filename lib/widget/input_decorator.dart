import 'package:flutter/material.dart';

class CommonDecorator {
  static InputDecoration inputDecorator(String hint) {
    return InputDecoration(
      border: const OutlineInputBorder(borderSide: BorderSide.none),
      fillColor: const Color(0xffF2F2F2),
      filled: true,
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
    );
  }
}

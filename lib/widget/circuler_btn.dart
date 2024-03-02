import 'package:flutter/material.dart';
import 'package:resume_builder/config/extension.dart';

class CirculerBtn extends StatelessWidget {
  const CirculerBtn({Key? key, required this.child, required this.onTap})
      : super(key: key);
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: child,
      ),
    );
  }
}

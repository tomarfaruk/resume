import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String message;
  const EmptyState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        borderRadius: BorderRadius.circular(16),
        elevation: 3,
        color: Theme.of(context).cardColor.withOpacity(.95),
        shadowColor: const Color(0xff888888),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(message),
          ),
        ),
      ),
    );
  }
}

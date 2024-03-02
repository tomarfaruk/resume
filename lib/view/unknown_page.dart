import 'package:flutter/material.dart';

class UnknownRoutePage extends StatefulWidget {
  const UnknownRoutePage({Key? key}) : super(key: key);

  @override
  State<UnknownRoutePage> createState() => _UnknownRoutePageState();
}

class _UnknownRoutePageState extends State<UnknownRoutePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
          child: Center(child: Text('Unknown page, please define this route'))),
    );
  }
}

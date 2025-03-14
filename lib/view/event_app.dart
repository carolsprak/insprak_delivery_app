import 'package:flutter/material.dart';

import 'login_screen.dart';


class EventApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Insprak Delivery",
      home: LoginScreen(),
    );
  }
}

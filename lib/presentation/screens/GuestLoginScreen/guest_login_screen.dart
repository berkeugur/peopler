import 'package:flutter/material.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'body.dart';

class GuestLoginScreen extends StatelessWidget {
  const GuestLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mode().homeScreenScaffoldBackgroundColor(),
      body: const GuestLoginScreenBody(),
    );
  }
}

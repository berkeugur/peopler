import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';

class MaintenanceScreen extends StatelessWidget {
  const MaintenanceScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text("Bakımdayız."),
      ),
    );
  }
}

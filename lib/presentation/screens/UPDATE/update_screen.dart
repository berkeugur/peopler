import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';

class UpdateScreen extends StatelessWidget {
  const UpdateScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: TextButton(onPressed: () {
          LaunchReview.launch(
              writeReview: false,
              androidAppId: "app.peopler",
              iOSAppId: "585027354");
        },
          child: const Text("Uygulamayı Güncelle."),),
      ),
    );
  }
}

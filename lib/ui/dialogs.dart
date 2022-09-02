import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:peopler/core/constants/app/animations_constants.dart';

class PeoplerDialogs {
  static Future showSuccessfulDialog(BuildContext ctx, AnimationController controller) async => await showDialog(
        barrierColor: Colors.transparent,
        context: ctx,
        builder: (ctx) => Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Lottie.asset(
            AnimationsConstants.SUCCESS_PATH,
            controller: controller,
            repeat: true,
            onLoaded: (composition) {
              // Configure the AnimationController with the duration of the
              // Lottie file and start the animation.
              controller
                ..duration = composition.duration
                ..forward().then((value) => Navigator.of(ctx).pop());
            },
          ),
        ),
      );
}

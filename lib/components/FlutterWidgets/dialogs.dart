import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:peopler/core/constants/app/animations_constants.dart';

class PeoplerDialogs {
  Future showSuccessfulDialog(BuildContext ctx, AnimationController controller) async => await showDialog(
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
  static Future showLoadingDialog(BuildContext ctx, AnimationController controller) async => await showDialog(
        barrierColor: Colors.transparent,
        context: ctx,
        builder: (ctx) => Dialog(
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Lottie.asset(
            AnimationsConstants.LOADING_PATH,
            controller: controller,
            repeat: true,
          ),
        ),
      );

  Future showContanctInfo(
    BuildContext context,
  ) async {
    await showDialog(
      context: context,
      builder: (contextSD) => AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
        contentPadding: const EdgeInsets.only(top: 20.0, bottom: 5, left: 25, right: 25),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "support@peopler.app üzerinden iletişime geçebilirsiniz.",
              textAlign: TextAlign.center,
              style: GoogleFonts.rubik(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: Theme.of(context).primaryColor,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                child: Text(
                  "TAMAM",
                  style: GoogleFonts.rubik(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

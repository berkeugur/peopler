import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/app/animations_constants.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';
import 'package:peopler/data/repository/location_repository.dart';
import 'package:peopler/others/locator.dart';

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
              style: PeoplerTextStyle.normal.copyWith(
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
                  style: PeoplerTextStyle.normal.copyWith(
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

  Future showAYSBgLocationDecline(
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
              "Emin misin? Çünkü her zaman izin ver seçeneği uygulamanın kapalıyken bile çalışmasını sağlar. \nBu seçeneği işaretlemezsen insanlar seni uygulama kapalıyken bulamayacaklar!",
              textAlign: TextAlign.center,
              style: PeoplerTextStyle.normal.copyWith(
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
              borderRadius: BorderRadius.circular(99),
              onTap: () async {
                Navigator.of(context).pop();
                final LocationRepository _locationRepository = locator<LocationRepository>();
                _locationRepository.openPermissionSettings();

                /// We use delay here because when user clicked this button, he/she will be redirected to permission settings first.
                await Future.delayed(const Duration(seconds: 3));
                await Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.HOME_SCREEN, (Route<dynamic> route) => false);
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
                  "İzin Ver",
                  style: PeoplerTextStyle.normal.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              borderRadius: BorderRadius.circular(99),
              onTap: () async {
                Navigator.of(context).pop();
                await Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.HOME_SCREEN, (Route<dynamic> route) => false);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  //color: Theme.of(context).primaryColor,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                child: Text(
                  "Şimdi Değil",
                  style: PeoplerTextStyle.normal.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

   loadingDialogFullScreen({required BuildContext context, List<String>? loadingTexts})  {
     showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: DefaultTextStyle(
                textAlign: TextAlign.center,
                style: PeoplerTextStyle.normal.copyWith(
                  fontSize: 18.0,
                ),
                child: AnimatedTextKit(
                  pause: const Duration(milliseconds: 1700),
                  repeatForever: true,
                  animatedTexts: List.generate(
                    loadingTexts?.length ?? 0,
                    (index) => TyperAnimatedText(
                      loadingTexts?[index] ?? "",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  onTap: () {
                    debugPrint("Tap Event");
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/services.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/presentation/screens/SUBSCRIPTIONS/subscriptions_functions.dart';

class SystemUIService {
  setSystemUIforThemeMode() async {
    /// Dark Mode
    if (Mode.isEnableDarkMode) {
      printf("setSystemUIforThemeMode Dark");
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(
          //Navigation Bar
          systemNavigationBarIconBrightness: Brightness.light,
          systemNavigationBarColor: const Color(0xFF000B21),
          //Status Bar
          statusBarColor: const Color(0xFF000B21),
          //statusBarBrightness: Brightness.dark,
          //statusBarIconBrightness: Brightness.light,
        ),
      );
      return;
    }

    /// Light Mode
    printf("setSystemUIforThemeMode Light");
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: const Color(0xFFFFFFFF),
        systemNavigationBarColor: const Color(0xFFFFFFFF),
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  setSystemUIForBlue() async {
    printf("setSystemUIForBlue");
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: const Color(0xFF0353EF),
        systemNavigationBarColor: const Color(0xFF0353EF),
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  setSystemUIForWhite() async {
    printf("setSystemUIForWhite");
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: const Color(0xFFFFFFFF),
        systemNavigationBarColor: const Color(0xFFFFFFFF),
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }
}

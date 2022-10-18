import 'package:flutter/services.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';

class SystemUIService {
  setSystemUIforThemeMode() async {
    if (Mode.isEnableDarkMode) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarColor: const Color(0xFF000B21),
          systemNavigationBarColor: const Color(0xFF000B21),
          statusBarIconBrightness: Brightness.light,
        ),
      );
    } else {
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

  setSystemUIForBlue() async {
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

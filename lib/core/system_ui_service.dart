import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';

class SystemUIService {
  setSystemUIforThemeMode() async {
    /// Dark Mode
    if (Mode.isEnableDarkMode) {
      debugPrint("setSystemUIforThemeMode Dark");
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
    debugPrint("setSystemUIforThemeMode Light");
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
    debugPrint("setSystemUIForBlue");
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarColor: const Color(0xFF0353EF),
        systemNavigationBarColor: const Color(0xFF0353EF),
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  /*
  setSystemUIForWhite() async {
    debugPrint("setSystemUIForWhite");
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarColor: const Color(0xFFFFFFFF),
        systemNavigationBarColor: const Color(0xFFFFFFFF),
        statusBarIconBrightness: Brightness.dark,
      ),
    ); 
  }
  */
}

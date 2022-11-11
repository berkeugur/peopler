import 'dart:io' show Platform;

class AppPlatform {
  static bool get isAndroid {
    return Platform.isAndroid;
  }

  static bool get isIOS {
    return Platform.isIOS;
  }
}

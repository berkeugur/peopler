import 'package:flutter/material.dart';

class Reloader {
  static ValueNotifier<bool> isConnected = ValueNotifier(false);
  static ValueNotifier<bool> isUnBlocked = ValueNotifier(false);
  static ValueNotifier<bool> isLoginButtonTapped = ValueNotifier(false);

  static ValueNotifier<bool> otherUserProfileReload = ValueNotifier(false);

  Future reload({required ValueNotifier<bool> reloadItem}) async {
    await Future.delayed(const Duration(seconds: 1), (() {
      reloadItem.value = !reloadItem.value;
    })).then((val) => reloadItem.value = !reloadItem.value);
  }
}

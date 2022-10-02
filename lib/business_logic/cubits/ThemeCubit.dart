import 'package:flutter/material.dart' show ValueNotifier;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../others/classes/dark_light_mode_controller.dart';

ValueNotifier<bool> setTheme = ValueNotifier(true);

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(true);

  openLightMode() {
    Mode.isEnableDarkMode = false;
    Mode.isEnableDarkModeNotifier.value = false;
    setTheme.value = !setTheme.value;
    Future.delayed(const Duration(milliseconds: 500), () {
      setTheme.value = !setTheme.value;
      Mode.isEnableDarkMode = false;
      Mode.isEnableDarkModeNotifier.value = false;
    }).then((value) {
      setTheme.value = !setTheme.value;
      Mode.isEnableDarkMode = false;
      Mode.isEnableDarkModeNotifier.value = false;
    });
    emit(true);
  }

  openDarkMode() {
    Mode.isEnableDarkMode = true;
    Mode.isEnableDarkModeNotifier.value = true;
    setTheme.value = !setTheme.value;
    Future.delayed(const Duration(milliseconds: 500), () {
      setTheme.value = !setTheme.value;
      Mode.isEnableDarkMode = true;
      Mode.isEnableDarkModeNotifier.value = true;
    }).then((value) {
      setTheme.value = !setTheme.value;
      Mode.isEnableDarkMode = true;
      Mode.isEnableDarkModeNotifier.value = true;
    });
    emit(false);
  }
}

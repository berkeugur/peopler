import 'package:flutter/material.dart' show ValueNotifier;
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../others/classes/dark_light_mode_controller.dart';

ValueNotifier<bool> setTheme = ValueNotifier(true);

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(true);

  Future<void> openLightMode() async {
    Mode.isEnableDarkMode = false;
    Future.delayed(const Duration(milliseconds: 500), () {
      setTheme.value = !setTheme.value;
      Mode.isEnableDarkMode = false;
    }).then((value) {
      setTheme.value = !setTheme.value;
      Mode.isEnableDarkMode = false;
    });
    emit(true);
  }

  Future<void> openDarkMode() async {
    Mode.isEnableDarkMode = true;
    Future.delayed(const Duration(milliseconds: 500), () {
      setTheme.value = !setTheme.value;
      Mode.isEnableDarkMode = true;
    }).then((value) {
      setTheme.value = !setTheme.value;
      Mode.isEnableDarkMode = true;
    });
    emit(false);
  }
}

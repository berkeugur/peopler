import 'package:flutter/material.dart';
import '../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../others/locator.dart';

Container safeArea({required BuildContext context}) {
  final Mode _mode = locator<Mode>();
  double safePadding = MediaQuery
      .of(context)
      .padding
      .top;

      return Container(
        height: safePadding,
        color: _mode.homeScreenScaffoldBackgroundColor(),
      );
}
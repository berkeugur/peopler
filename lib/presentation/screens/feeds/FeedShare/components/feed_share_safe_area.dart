import 'package:flutter/material.dart';

import '../../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../../others/locator.dart';


Container safeArea(
    double safePadding, BuildContext context) {
  final Mode _mode = locator<Mode>();
      return Container(
        height: safePadding,
        color: _mode.feedShareScreenScaffoldBackgroundColor(),
      );

}

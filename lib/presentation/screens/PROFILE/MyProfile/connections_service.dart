// ignore: avoid_print
import 'package:flutter/material.dart';

import '../OthersProfile/functions.dart';
import '../OthersProfile/profile/profile_screen_components.dart';

printf(String text) => print(text);

class ConnectionService {
  pushOthersProfile({required BuildContext context, required String otherProfileID}) {
    openOthersProfile(context, otherProfileID, SendRequestButtonStatus.connected);
  }
}

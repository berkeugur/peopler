// ignore: avoid_print
import 'package:flutter/material.dart';
import 'package:peopler/core/constants/enums/send_req_button_status_enum.dart';
import 'package:peopler/presentation/screens/PROFILE/OthersProfile/functions.dart';

printf(String text) => print(text);

class ConnectionService {
  pushOthersProfile({required BuildContext context, required String otherProfileID}) {
    openOthersProfile(context, otherProfileID, SendRequestButtonStatus.connected);
  }
}

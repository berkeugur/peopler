import 'package:flutter/material.dart';
import 'package:peopler/core/constants/enums/send_req_button_status_enum.dart';
import 'package:peopler/data/model/user.dart';

class ProfileButtons extends StatelessWidget {
  final SendRequestButtonStatus status;
  const ProfileButtons({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case SendRequestButtonStatus.save:
        return Container(); //_buildSaveStatus(context, otherUser.userID);
      case SendRequestButtonStatus.saved:
        return Container(); //_buildSavedStatus();
      case SendRequestButtonStatus.connect:
        return Container(); //_buildConnectStatus(context, otherUser.userID);
      case SendRequestButtonStatus.requestSent:
        return Container(); //_buildRequestSentStatus();
      case SendRequestButtonStatus.accept:
        return Container(); //_buildAcceptStatus(context, otherUser.userID, otherUser);
      case SendRequestButtonStatus.connected:
        return Container(); //_buildConnectedStatus(otherUser, context);
      default:
        return const Text("error");
    }
  }
}

class ProfileButtonWidget extends StatelessWidget {
  final MyUser user;
  const ProfileButtonWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

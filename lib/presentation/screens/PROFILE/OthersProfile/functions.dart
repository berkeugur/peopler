import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/core/constants/enums/send_req_button_status_enum.dart';
import 'package:peopler/presentation/screens/GUEST_LOGIN/guest_login_screen.dart';
import 'package:peopler/presentation/screens/PROFILE/OthersProfile/profile/profile_screen.dart';
import 'package:peopler/presentation/screens/PROFILE/OthersProfile/profile/profile_screen_components.dart';
import 'package:peopler/presentation/screens/SUBSCRIPTIONS/subscriptions_functions.dart';
import '../../../../business_logic/blocs/UserBloc/user_bloc.dart';

void openOthersProfile(context, userID, SendRequestButtonStatus status) {
  UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
  if (UserBloc.user != null) {
    _userBloc.mainKey.currentState?.push(MaterialPageRoute(
      builder: (context) => OthersProfileScreen(
        userID: userID,
        status: status,
      ),
    ));
  } else {
    _userBloc.mainKey.currentState?.push(MaterialPageRoute(
      builder: (context) => const GuestLoginScreen(),
    ));
  }
}

Future<bool> popOtherUserScreen(context) async {
  Navigator.pop(context);
  return Future.value(true);
}

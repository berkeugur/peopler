import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/presentation/screens/profile/OthersProfile/profile/profile_screen.dart';
import 'package:peopler/presentation/screens/profile/OthersProfile/profile/profile_screen_components.dart';
import '../../../../business_logic/blocs/UserBloc/user_bloc.dart';

void openOthersProfile(context, userID, SendRequestButtonStatus status) {
  UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
  if(UserBloc.user != null) {
    _userBloc.mainKey.currentState?.push(MaterialPageRoute(
      builder: (context) =>
          OthersProfileScreen(userID: userID, status: status,),
    ));
  } else {
    _userBloc.mainKey.currentState?.push(    MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(child: Text("Giriş yapmanız gerekiyor"),),
      ),
    ));
  }
}

Future<bool> popOtherUserScreen(context) async {
  Navigator.pop(context);
  return Future.value(true);
}

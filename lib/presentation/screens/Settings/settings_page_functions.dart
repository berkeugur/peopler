import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../business_logic/blocs/UserBloc/bloc.dart';
import '../../../business_logic/cubits/FloatingActionButtonCubit.dart';
import '../../tab_item.dart';

///op = On Pressed
// ignore: non_constant_identifier_names
op_settings_back_arrow(context) {
  final FloatingActionButtonCubit _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);
  _homeScreen.currentScreen = {_homeScreen.currentTab: ScreenItem.feedScreen};
  _homeScreen.changeFloatingActionButtonEvent();
  Navigator.pop(context);
}

// ignore: non_constant_identifier_names
op_settings_peopler_title() {
  if (kDebugMode) {
    print("pressed peopler title");
  }
}

// ignore: non_constant_identifier_names
op_settings_message_icon() {
  if (kDebugMode) {
    print("pressed message icon");
  }
}

// ignore: non_constant_identifier_names
op_settings_ppl_photo() {
  if (kDebugMode) {
    print("pressed op_settings_ppl_photo");
  }
}

// ignore: non_constant_identifier_names
op_in_the_same_city() {
  if (kDebugMode) {
    print("pressed op_in_the_same_city()");
  }
}

// ignore: non_constant_identifier_names
op_in_the_same_environment() {
  if (kDebugMode) {
    print("pressedop_in_the_same_environment()");
  }
}

// ignore: non_constant_identifier_names
op_close_the_everyone() {
  if (kDebugMode) {
    print("pressed op_close_the_everyone");
  }
}

// ignore: non_constant_identifier_names
op_open_the_everyone() {
  if (kDebugMode) {
    print("pressed  op_open_the_everyone");
  }
}

op_change_password(context) {
  if (kDebugMode) {
    print("pressed  op_change_password");
  }
}

op_delete_account(BuildContext context) {
  UserBloc _userBloc = BlocProvider.of(context);
  _userBloc.add(deleteUser());

  Navigator.of(context).canPop();
}

op_suggestion_or_complaint() {
  if (kDebugMode) {
    print("pressed  op_suggestion_or_complaint");
  }
}

op_terms_of_use() {
  if (kDebugMode) {
    print("pressed  op_terms_of_use");
  }
}

// ignore: non_constant_identifier_names
op_confidentiality_agreement() {
  if (kDebugMode) {
    print("pressed  op_confidentiality_agreement");
  }
}

op_sign_out(context) {
  UserBloc _userBloc = BlocProvider.of<UserBloc>(context);

  if (kDebugMode) {
    print("pressed  op_sign_out");
  }
  _userBloc.add(signOutEvent());
  _userBloc.mainKey.currentState?.pushReplacementNamed('/welcomeScreen');
}

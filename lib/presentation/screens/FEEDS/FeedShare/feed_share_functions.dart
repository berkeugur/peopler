import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/components/snack_bars.dart';
import 'package:peopler/core/constants/enums/screen_item_enum.dart';
import '../../../../business_logic/blocs/AddAnFeedBloc/bloc.dart';
import '../../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../../business_logic/cubits/FloatingActionButtonCubit.dart';
import '../../../../data/model/feed.dart';
import '../../../../others/classes/variables.dart';
import '../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../others/locator.dart';
import '../../../../others/widgets/snack_bars.dart';

// ignore: non_constant_identifier_names
feed_share_button_on_pressed(BuildContext context) {
  final Mode _mode = locator<Mode>();

  if (feedController.text.replaceAll(" ", "").length > 10) {
    MyFeed _feed = MyFeed(userID: UserBloc.user?.userID ?? "error #1DEUUXB");
    AddFeedBloc _addFeedBloc = BlocProvider.of<AddFeedBloc>(context);
    _addFeedBloc.add(AddAFeedEvent(myFeed: _feed));
    debugPrint("share feed button is clicked");
  } else {
    SnackBars(context: context).simple('Paylaşımın çok kısa');
  }
}

// ignore: non_constant_identifier_names
feed_share_back_icon_on_pressed(context) {
  final FloatingActionButtonCubit _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);
  _homeScreen.currentScreen = {_homeScreen.currentTab: ScreenItem.feedScreen};
  _homeScreen.changeFloatingActionButtonEvent();
  Navigator.pop(context);
}

// ignore: non_constant_identifier_names
feed_share_profile_photo_on_pressed() {}

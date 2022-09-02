import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/PuchaseGetOfferBloc/bloc.dart';
import 'package:peopler/core/constants/app/animations_constants.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import '../../../business_logic/blocs/UserBloc/bloc.dart';
import '../../../data/fcm_and_local_notifications.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatelessWidget {
  static const splashScreenDuration = 1;
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(checkUserSignedInEvent());

    /// Start to listen awesome notifications clickable
    FCMAndLocalNotifications.listenNotification();

    // ACHTUNG !!!!!!!!!!!!! USE pushReplacementMethod when navigating if a page contains BlocListener
    // so that the page destroyed and BlocListener disposed.
    // DO NOT USE pushNamed
    return BlocListener<UserBloc, UserState>(
      listener: (context, UserState state) {
        if (state is SignedInState) {
          Timer(const Duration(seconds: splashScreenDuration), () {
            Navigator.of(context).pushReplacementNamed(NavigationConstants.HOME_SCREEN);
          });
        } else if (state is SignedOutState) {
          Timer(const Duration(seconds: splashScreenDuration), () {
            Navigator.of(context).pushReplacementNamed(NavigationConstants.ON_BOARDING);
          });
        } else if (state is SignedInMissingInfoState) {
          Timer(const Duration(seconds: splashScreenDuration), () {
            Navigator.of(context).pushReplacementNamed('/genderSelectScreen');
          });
        } else if (state is SignedInNotVerifiedState) {
          Timer(const Duration(seconds: splashScreenDuration), () {
            _userBloc.add(waitForVerificationEvent());

            Navigator.of(context).pushReplacementNamed('/verifyScreen');
          });
        }
      },
      child: Scaffold(
        backgroundColor: Mode().homeScreenScaffoldBackgroundColor(),
        body: Center(
            child: Lottie.asset(
          AnimationsConstants.LOADING_PATH,
          width: MediaQuery.of(context).size.width / 2,
          repeat: true,
        )),
      ),
    );
  }
}

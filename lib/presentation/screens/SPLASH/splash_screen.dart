import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';
import '../../../business_logic/blocs/UserBloc/bloc.dart';
import '../../../data/fcm_and_local_notifications.dart';

class SplashScreen extends StatefulWidget {
  static const splashScreenDuration = 1;
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
    _userBloc.add(checkUserSignedInEvent(context: context));

    /// Start to listen awesome notifications clickable
    FCMAndLocalNotifications.listenNotification();

    // ACHTUNG !!!!!!!!!!!!! USE pushReplacementMethod when navigating if a page contains BlocListener
    // so that the page destroyed and BlocListener disposed.
    // DO NOT USE pushNamed
    return BlocListener<UserBloc, UserState>(
      listener: (context, UserState state) {
        if (state is SignedInState) {
          Timer(const Duration(seconds: SplashScreen.splashScreenDuration), () async {
            await Navigator.of(context).pushReplacementNamed(NavigationConstants.HOME_SCREEN);
          });
        } else if (state is SignedOutState) {
          Timer(const Duration(seconds: SplashScreen.splashScreenDuration), () async {
            await Navigator.of(context).pushReplacementNamed(NavigationConstants.ON_BOARDING);
          });
        } else if (state is SignedInMissingInfoState) {
          Timer(const Duration(seconds: SplashScreen.splashScreenDuration), () async {
            await Navigator.of(context).pushReplacementNamed(NavigationConstants.CONTINUE_WITH_LINKEDIN);
          });
        } else if (state is SignedInNotVerifiedState) {
          Timer(const Duration(seconds: SplashScreen.splashScreenDuration), () async {
            _userBloc.add(waitForVerificationEvent());
            await Navigator.of(context).pushReplacementNamed(NavigationConstants.VERIFY_SCREEN);
          });
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF0353EF),
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: Center(
            child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.5,
          child: Image.asset(
            "assets/peopler.png",
            scale: 1,
          ),
        )),
      ),
    );
  }
}

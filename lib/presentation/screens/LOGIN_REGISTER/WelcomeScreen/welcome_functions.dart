import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../../business_logic/blocs/UserBloc/user_event.dart';
import '../../../../data/repository/connectivity_repository.dart';
import '../../../../others/locator.dart';

void show_privacy_policy(BuildContext context) {
  bool _isloading = false;
  ValueNotifier<int> _progressPercent = ValueNotifier(0);
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {Factory(() => EagerGestureRecognizer())};

  UniqueKey _key = UniqueKey();
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: Colors.transparent,
        child: _isloading == true
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 80.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                    ValueListenableBuilder(
                        valueListenable: _progressPercent,
                        builder: (context, value, x) {
                          return Text("%$_progressPercent yükleniyor.");
                        }),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: WebView(
                  gestureRecognizers: gestureRecognizers,
                  onProgress: (progress) {
                    _isloading = progress == 100 ? false : true;
                    _progressPercent.value = progress;
                    if (kDebugMode) {
                      print("this progress code: $_progressPercent");
                    }
                  },
                  initialUrl: 'https://peopler.app/gizlilik-politikasi/',
                ),
              ),
      );
    },
  );
}

void termOfUseTextOnPressed(BuildContext context) {
  bool _isloading = false;
  ValueNotifier<int> _progressPercent = ValueNotifier(0);
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {Factory(() => EagerGestureRecognizer())};

  UniqueKey _key = UniqueKey();
  showModalBottomSheet<void>(
    context: context,
    builder: (BuildContext context) {
      return Container(
        color: Colors.transparent,
        child: _isloading == true
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 80.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Theme.of(context).primaryColor,
                    ),
                    ValueListenableBuilder(
                        valueListenable: _progressPercent,
                        builder: (context, value, x) {
                          return Text("%$_progressPercent yükleniyor.");
                        }),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: WebView(
                  gestureRecognizers: gestureRecognizers,
                  onProgress: (progress) {
                    _isloading = progress == 100 ? false : true;
                    _progressPercent.value = progress;
                    if (kDebugMode) {
                      print("this progress code: $_progressPercent");
                    }
                  },
                  initialUrl: 'https://peopler.app/kullanici-sozlesmesi/',
                ),
              ),
      );
    },
  );
}

void areYouAlreadyMemberOnPressed(BuildContext context) {
  Navigator.of(context).pushNamed(NavigationConstants.LOGIN_SCREEN);
}

void continueWithLinkedinButtonOnPressed(BuildContext context) async {
  final ConnectivityRepository _connectivityRepository = locator<ConnectivityRepository>();
  bool _connection = await _connectivityRepository.checkConnection(context);
  if (_connection == false) return;
  Navigator.of(context).pushNamed(NavigationConstants.LINKEDIN_LOGIN_SCREEN);
}

void continueWithUniversityEmailOnPressed(BuildContext context) {
  UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
  _userBloc.add(initializeMyUserEvent());
  Navigator.of(context).pushNamed(NavigationConstants.NAME_SCREEN);
}

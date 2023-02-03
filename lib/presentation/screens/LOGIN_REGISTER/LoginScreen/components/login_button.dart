import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_event.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_state.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';
import 'package:peopler/core/constants/reloader/reload.dart';
import 'package:peopler/core/system_ui_service.dart';
import 'package:peopler/others/classes/variables.dart';
import 'package:peopler/others/locator.dart';
import 'package:peopler/presentation/screens/SUBSCRIPTIONS/subscriptions_functions.dart';

import '../../../../../data/repository/connectivity_repository.dart';

Future<void> signInFunction({required BuildContext context}) async {
  //await Future.delayed(Duration(seconds: 10));
  final ConnectivityRepository _connectivityRepository = locator<ConnectivityRepository>();
  bool _connection = await _connectivityRepository.checkConnection(context);
  if (_connection == false) return;

  if (loginEmailController.text.isEmpty && loginPasswordController.text.isEmpty) {
    SnackBars(context: context).simple("Lütfen e posta adresinizi ve şifrenizi girin.");
    Reloader.isLoginButtonTapped.value = false;
  } else if (loginEmailController.text.isEmpty) {
    SnackBars(context: context).simple("Lütfen e posta adresinizi girin.");
    Reloader.isLoginButtonTapped.value = false;
  } else if (loginPasswordController.text.isEmpty) {
    SnackBars(context: context).simple("Lütfen şifrenizi girin.");
    Reloader.isLoginButtonTapped.value = false;
  } else if (loginEmailController.text.isNotEmpty && loginPasswordController.text.isNotEmpty) {
    BlocProvider.of<UserBloc>(context).add(signInWithEmailandPasswordEvent(email: loginEmailController.text, password: loginPasswordController.text));
  }
}

// ignore: must_be_immutable
class LoginButton extends StatelessWidget {
  LoginButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
    return BlocListener<UserBloc, UserState>(
      bloc: _userBloc,
      listener: (context, UserState state) {
        if (state is SignedInState) {
          /// Set theme mode before Home Screen
          SystemUIService().setSystemUIforThemeMode();

          Navigator.of(context).pushReplacementNamed(NavigationConstants.HOME_SCREEN);
          Reloader.isLoginButtonTapped.value = false;
          loginPasswordController.clear();
          loginEmailController.clear();
        } else if (state is SignedInNotVerifiedState) {
          Navigator.of(context).pushReplacementNamed(NavigationConstants.VERIFY_SCREEN);
          Reloader.isLoginButtonTapped.value = false;
        } else if (state is InvalidEmailState) {
          SnackBars(context: context).simple("E posta adresiniz istenilen biçimde değil!");
          Reloader.isLoginButtonTapped.value = false;
        } else if (state is UserNotFoundState) {
          SnackBars(context: context).simple("Böyle bir e posta adresi kayıtlı değil veya silinmiş olabilir!");
          Reloader.isLoginButtonTapped.value = false;
        } else if (state is WrongPasswordState) {
          SnackBars(context: context).simple("Hatalı şifre girdiniz.\nŞifrenizi unuttuysanız sıfırlayabilirsiniz");
          Reloader.isLoginButtonTapped.value = false;
        }
      },
      child: ValueListenableBuilder(
        valueListenable: Reloader.isLoginButtonTapped,
        builder: (context, value, _) {
          if (value == false) {
            return InkWell(
              onTap: () async {
                Reloader.isLoginButtonTapped.value = true;
                await signInFunction(context: context);
              },
              child: AnimatedContainer(
                height: 50,
                duration: const Duration(milliseconds: 2100),
                width: value == true ? 0 : null,
                padding: const EdgeInsets.symmetric(
                  vertical: 12.5,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0353EF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Giriş Yap",
                      style: GoogleFonts.dmSans(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              //icon: Icon(Icons.arrow_forward_ios),
            );
          } else {
            return InkWell(
              onTap: () {},
              child: AnimatedContainer(
                height: 50,
                duration: const Duration(milliseconds: 2100),
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0353EF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

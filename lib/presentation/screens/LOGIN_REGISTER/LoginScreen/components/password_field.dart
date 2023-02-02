import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_state.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';
import 'package:peopler/core/constants/reloader/reload.dart';
import 'package:peopler/core/system_ui_service.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/LoginScreen/components/login_button.dart';

import '../../../../../core/constants/length/max_length_constants.dart';
import '../../../../../others/classes/variables.dart';

Widget passwordInputField(BuildContext buildContext, StateSetter setState, double screenWidth) {
  UserBloc _userBloc = BlocProvider.of<UserBloc>(buildContext);
  return BlocListener<UserBloc, UserState>(
    bloc: _userBloc,
    listener: (context, UserState state) {
      if (state is SignedInState) {
        /// Set theme mode before Home Screen
        SystemUIService().setSystemUIforThemeMode();

        Navigator.of(context).pushReplacementNamed(NavigationConstants.HOME_SCREEN);
        Reloader.isLoginButtonTapped.value = false;
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
    child: Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(screenWidth < 300 ? 10 : 20, 0, 10, 0),
      margin: const EdgeInsets.only(top: 10),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        onSubmitted: (value) async {
          Reloader.isLoginButtonTapped.value = true;
          await signInFunction(context: buildContext);
        },
        obscuringCharacter: "●",
        obscureText: isVisibleLoginPassword,
        keyboardType: TextInputType.visiblePassword,
        cursorColor: const Color(0xFF0353EF),
        maxLength: MaxLengthConstants.PASSWORD,
        controller: loginPasswordController,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          suffixIcon: IconButton(
              onPressed: () {
                setState(() {
                  isVisibleLoginPassword = !isVisibleLoginPassword;
                });
              },
              icon: Icon(
                isVisibleLoginPassword == true ? Icons.visibility : Icons.visibility_off,
                color: Colors.grey[400],
              )),
          counterText: "",
          contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          hintMaxLines: 1,
          border: InputBorder.none,
          hintText: '●●●●●●',
          hintStyle: GoogleFonts.dmSans(
            color: Colors.grey[500],
          ),
        ),
        style: GoogleFonts.dmSans(
          color: Colors.grey[800],
        ),
        autofillHints: const [AutofillHints.password],
        onEditingComplete: () => TextInput.finishAutofillContext(),
      ),
    ),
  );
}

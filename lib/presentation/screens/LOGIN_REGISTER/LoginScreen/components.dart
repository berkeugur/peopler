import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/core/constants/length/max_length_constants.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';

import '../../../../business_logic/blocs/UserBloc/bloc.dart';
import '../../../../data/repository/connectivity_repository.dart';
import '../../../../others/classes/variables.dart';
import '../../../../others/locator.dart';
import '../../../../others/widgets/snack_bars.dart';
import 'login_screen.dart';

Center signInButton(context) {
  UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
  return Center(
    child: BlocListener<UserBloc, UserState>(
      bloc: _userBloc,
      listener: (context, UserState state) {
        if (state is SignedInState) {
          Navigator.of(context).pushReplacementNamed(NavigationConstants.HOME_SCREEN);
        } else if (state is SignedInNotVerifiedState) {
          Navigator.of(context).pushReplacementNamed(NavigationConstants.VERIFY_SCREEN);
        } else if (state is InvalidEmailState) {
          SnackBars(context: context).simple("E posta adresiniz istenilen biçimde değil!");
        } else if (state is UserNotFoundState) {
          SnackBars(context: context).simple("Böyle bir e posta adresi kayıtlı değil veya silinmiş olabilir!");
        } else if (state is WrongPasswordState) {
          SnackBars(context: context).simple("Hatalı şifre girdiniz.\nŞifrenizi unuttuysanız sıfırlayabilirsiniz");
        }
      },
      child: Container(
        height: 40,
        width: 140,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xFF0353EF),
        ),
        child: TextButton(
          onPressed: () async {
            final ConnectivityRepository _connectivityRepository = locator<ConnectivityRepository>();
            bool _connection = await _connectivityRepository.checkConnection(context);
            if (_connection == false) return;

            if (loginEmailController.text.isEmpty && loginPasswordController.text.isEmpty) {
              SnackBars(context: context).simple("Lütfen e posta adresinizi ve şifrenizi girin.");
            } else if (loginEmailController.text.isEmpty) {
              SnackBars(context: context).simple("Lütfen e posta adresinizi girin.");
            } else if (loginPasswordController.text.isEmpty) {
              SnackBars(context: context).simple("Lütfen şifrenizi girin.");
            } else if (loginEmailController.text.isNotEmpty && loginPasswordController.text.isNotEmpty) {
              _userBloc.add(signInWithEmailandPasswordEvent(email: loginEmailController.text, password: loginPasswordController.text));
            }
          },
          child: Text(
            "Giriş Yap",
            textScaleFactor: 1,
            style: GoogleFonts.rubik(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w400),
          ),
        ),
      ),
    ),
  );
}

Container passwordInputField(StateSetter setState, double screenWidth) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.fromLTRB(screenWidth < 300 ? 10 : 40, 0, 20, 0),
    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
    height: 50,
    decoration: BoxDecoration(color: const Color(0xFF0353EF), borderRadius: BorderRadius.circular(25)),
    child: TextField(
      onTap: () async {
        await Future.delayed(const Duration(milliseconds: 500), () {
          jumpToBottomScrollController.animateTo(jumpToBottomScrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
        });
      },
      obscureText: isVisibleLoginPassword,
      keyboardType: TextInputType.visiblePassword,
      cursorColor: const Color(0xFFB3CBFA),
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
              color: const Color(0xFFB3CBFA).withOpacity(0.6),
            )),
        counterText: "",
        contentPadding: const EdgeInsets.fromLTRB(0, 13, 0, 10),
        hintMaxLines: 1,
        border: InputBorder.none,
        hintText: 'Şifre',
        hintStyle: const TextStyle(color: Color(0xFFB3CBFA), fontSize: 18),
      ),
      style: const TextStyle(color: Color(0xFFFFFFFF)),
      autofillHints: const [AutofillHints.password],
      onEditingComplete: () => TextInput.finishAutofillContext(),
    ),
  );
}

Container emailFormField(StateSetter setState, double screenWidth) {
  return Container(
    alignment: Alignment.center,
    padding: EdgeInsets.fromLTRB(screenWidth < 300 ? 10 : 10, 0, 20, 0),
    margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
    height: 50,
    decoration: BoxDecoration(color: const Color(0xFF0353EF), borderRadius: BorderRadius.circular(25)),
    child: TextField(
      onTap: () async {
        await Future.delayed(const Duration(milliseconds: 500), () {
          jumpToBottomScrollController.animateTo(jumpToBottomScrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
        });
      },
      keyboardType: TextInputType.emailAddress,
      cursorColor: const Color(0xFFB3CBFA),
      onEditingComplete: () {
        setState(() {});
      },
      maxLength: MaxLengthConstants.EMAIL,
      controller: loginEmailController,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        counterText: "",
        contentPadding: EdgeInsets.fromLTRB(30, 13, 0, 10),
        hintMaxLines: 1,
        border: InputBorder.none,
        hintText: 'isimsoyisim@uni.edu.tr',
        hintStyle: TextStyle(color: Color(0xFFB3CBFA), fontSize: 16),
      ),
      style: const TextStyle(color: Color(0xFFFFFFFF)),
      autofillHints: const [AutofillHints.email],
    ),
  );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import '../../../business_logic/blocs/UserBloc/bloc.dart';
import '../LOGIN_REGISTER/WelcomeScreen/welcome_component.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';

class GuestLoginScreenBody extends StatefulWidget {
  const GuestLoginScreenBody({Key? key}) : super(key: key);

  @override
  State<GuestLoginScreenBody> createState() => _GuestLoginScreenBodyState();
}

class _GuestLoginScreenBodyState extends State<GuestLoginScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Giriş Yapmanız Gerekiyor",
          textScaleFactor: 1,
          style: PeoplerTextStyle.normal.copyWith(fontSize: 16, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 20,
        ),
        continueWithButton(
          context,
          backgroundColor: Color(0xFF0353EF),
          icon: SvgPicture.asset(
            "assets/images/svg_icons/linkedin.svg",
            width: 0,
            height: 0,
            fit: BoxFit.contain,
          ),
          text: "Giriş Yap",
          onPressed: () async {
            UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
            await _userBloc.restartApp();
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/visibility/widget_visibility.dart';
import 'package:peopler/presentation/screens/SUBSCRIPTIONS/subscriptions_functions.dart';

import '../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../presentation/screens/SUBSCRIPTIONS/subscriptions_page.dart';
import '../classes/dark_light_mode_controller.dart';

//ScaffoldMessenger.of(context).showSnackBar(customSnackBar(context, "please do it right", Icons.add, Colors.white, Color(0xFF0D43DE)),);
//
//  Success Icon Icons.check_circle_outline_outlined,
//  Error Icon Icons.warning_amber_outlined,
//  Alert Icon Icons.error_outline_rounded,
//
//
//

showFreeUser(BuildContext context, String text) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
        contentPadding: const EdgeInsets.only(top: 25.0, bottom: 10, left: 25, right: 25),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              textAlign: TextAlign.center,
              style: PeoplerTextStyle.normal.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              borderRadius: BorderRadius.circular(99),
              onTap: () async {
                UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
                _userBloc.mainKey.currentState?.push(
                  MaterialPageRoute(builder: (context) => const SubscriptionsPage()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  color: Theme.of(context).primaryColor,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset("assets/images/svg_icons/ppl_mini_logo.svg"),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Premium & Plus",
                      style: PeoplerTextStyle.normal.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            InkWell(
              borderRadius: BorderRadius.circular(99),
              onTap: () async {
                Navigator.of(context).pop();
                //await Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.HOME_SCREEN, (Route<dynamic> route) => false);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  //color: Theme.of(context).primaryColor,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 10,
                ),
                child: Text(
                  "24 Saat Sonra Yenilensin",
                  style: PeoplerTextStyle.normal.copyWith(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 0,
            ),
          ],
        ),
      );
    },
  );
}

showNumOfConnectionRequestsConsumed(BuildContext context) {
  showFreeUser(context, "Uppss! İstek hakkın bitti. Ayrıcalıkları keşfetmeye nedersin?");
}

showRestNumOfConnectionRequests(BuildContext context) {
  if (WidgetVisibility.isshowRestNumOfConnectionRequestsVisible) {
    SnackBars(context: context).simple("Kalan istek gönderme hakkınız ${UserBloc.user!.numOfSendRequest - 1}");
    printf("Kalan istek gönderme hakkınız ${UserBloc.user!.numOfSendRequest - 1}");
  }
}

showYouNeedToLogin(BuildContext context) {
  SnackBars(context: context).simple("Başkalarının profilini görebilmek için giriş yapmalısınız.");
}

showYouNeedToLoginSave(BuildContext context) {
  SnackBars(context: context).simple("Başkalarını kaydedebilmek için giriş yapmalısınız.");
}

showCityChangeWarning(BuildContext context) {
  showFreeUser(context, "Şehir değiştirebilmek için premium hesaba geçmelisiniz.");
}

showGeriAlWarning(BuildContext context) {
  showFreeUser(context, "İsteğinizi geri çekebilmek için premium veya plus hesaba geçmelisiniz.");
}

showLinkedInPopWarning(BuildContext context) {
  SnackBars(context: context).simple("LinkedIn ile giriş yapabildiğiniz için öncelikle kayıt olmanız gerekmektedir.");
}

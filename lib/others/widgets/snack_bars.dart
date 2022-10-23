import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
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
        content: Text(text),
        actions: [
          TextButton(
            child: const Text("İptal"),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: const Text("Ayrıcalıkları Keşfet"),
            onPressed: () {
              UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
              _userBloc.mainKey.currentState?.push(
                MaterialPageRoute(builder: (context) => const SubscriptionsPage()),
              );
            },
          ),
        ],
      );
    },
  );
}

showNumOfConnectionRequestsConsumed(BuildContext context) {
  showFreeUser(context, "İstek gönderme haklarınızı tükettiniz. Sınırsız istek için plus veya premium hesaba geçin.");
}

showRestNumOfConnectionRequests(BuildContext context) {
  if (WidgetVisibility.isshowRestNumOfConnectionRequestsVisiable) {
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

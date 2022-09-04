import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/components/snack_bars.dart';

import '../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../presentation/screens/subscriptions/subscriptions_page.dart';
import '../classes/dark_light_mode_controller.dart';

//ScaffoldMessenger.of(context).showSnackBar(customSnackBar(context, "please do it right", Icons.add, Colors.white, Color(0xFF0D43DE)),);
//
//  Success Icon Icons.check_circle_outline_outlined,
//  Error Icon Icons.warning_amber_outlined,
//  Alert Icon Icons.error_outline_rounded,
//
//
//

showNumOfConnectionRequestsConsumed(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        content: const Text("İstek gönderme haklarınızı tükettiniz. Sınırsız istek için plus veya premium hesaba geçin."),
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

showRestNumOfConnectionRequests(BuildContext context) {
  SnackBars(context: context).simple("Kalan istek gönderme hakkınız ${UserBloc.user!.numOfSendRequest - 1}");
}

showYouNeedToLogin(BuildContext context) {
  SnackBars(context: context).simple("Başkalarının profilini görebilmek için giriş yapmalısınız.");
}

showYouNeedToLoginSave(BuildContext context) {
  SnackBars(context: context).simple("Başkalarını kaydedebilmek için giriş yapmalısınız.");
}

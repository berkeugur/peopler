import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

customSnackBar({required BuildContext context, required String title, required IconData? icon, required Color? textColor, required Color? bgColor}) {
  const double iconSize = 25;
  final double screenWidth = MediaQuery.of(context).size.width;

  return SnackBar(
    elevation: 6.0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: bgColor,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
                width: iconSize * 2,
                height: iconSize * 2,
                child: TextButton(
                    onPressed: () {},
                    child: Icon(
                      icon,
                      color: textColor,
                      size: iconSize,
                    ))),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
                width: screenWidth - (iconSize * 2 * 2) - 10 - 62,
                child: Text(
                  title,
                  style: TextStyle(fontSize: 16, color: textColor),
                )),
          ],
        ),
        SizedBox(
          height: iconSize + 5,
          width: iconSize + 5,
          child: InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
            child: Icon(Icons.close, color: textColor, size: iconSize),
          ),
        ),
      ],
    ),
  );
}

alertSnackBar(context, String text, GlobalKey<ScaffoldMessengerState>? key) {
  const double iconSize = 25;
  double screenWidth = MediaQuery.of(context).size.width;
  return SnackBar(
    elevation: 6.0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.amber,
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
                width: iconSize * 2,
                height: iconSize * 2,
                child: TextButton(
                    onPressed: () {},
                    child: Icon(
                      Icons.error_outline_rounded,
                      color: Colors.grey[850],
                      size: iconSize,
                    ))),
            const SizedBox(
              width: 10,
            ),
            SizedBox(
                width: screenWidth - (iconSize * 2 * 2) - 10 - 62,
                child: Text(
                  text,
                  style: TextStyle(color: Colors.grey[850]),
                )),
          ],
        ),
        SizedBox(
          height: iconSize * 2,
          width: iconSize * 2,
          child: TextButton(
            onPressed: () {},
            child: Icon(Icons.close, color: Colors.grey[850], size: iconSize),
          ),
        ),
      ],
    ),
  );
}

backSnackBar(String text, GlobalKey<ScaffoldMessengerState> key, void Function()? x, void Function()? y) {
  const double iconSize = 25;
  return SnackBar(
    elevation: 6.0,
    behavior: SnackBarBehavior.floating,
    backgroundColor: Colors.grey[850],
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            SizedBox(
                width: iconSize * 2,
                height: iconSize * 2,
                child: TextButton(
                    onPressed: () {},
                    child: const Icon(
                      Icons.error_outline_rounded,
                      color: Colors.white,
                      size: iconSize,
                    ))),
            const SizedBox(
              width: 10,
            ),
            Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
                onPressed: x,
                child: const Text(
                  "  sil  ",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                )),
            Container(
              width: 10,
            ),
            OutlinedButton(
                onPressed: y,
                child: const Text(
                  " iptal ",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                )),
          ],
        ),
      ],
    ),
  );
}

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
  ScaffoldMessenger.of(context).showSnackBar(
    customSnackBar(
        context: context,
        title: "Kalan istek gönderme hakkınız ${UserBloc.user!.numOfSendRequest - 1}",
        icon: Icons.done,
        textColor: const Color(0xFFFFFFFF),
        bgColor: Mode.isEnableDarkMode == true ? const Color(0xFF0353EF) : const Color(0xFF000B21)),
  );
}

showYouNeedToLogin(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    customSnackBar(
        context: context,
        title: "Başkalarının profilini görebilmek için giriş yapmalısınız.",
        icon: Icons.done,
        textColor: const Color(0xFFFFFFFF),
        bgColor: Mode.isEnableDarkMode == true ? const Color(0xFF0353EF) : const Color(0xFF000B21)),
  );
}

showYouNeedToLoginSave(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    customSnackBar(
        context: context,
        title: "Başkalarını kaydedebilmek için giriş yapmalısınız.",
        icon: Icons.done,
        textColor: const Color(0xFFFFFFFF),
        bgColor: Mode.isEnableDarkMode == true ? const Color(0xFF0353EF) : const Color(0xFF000B21)),
  );
}

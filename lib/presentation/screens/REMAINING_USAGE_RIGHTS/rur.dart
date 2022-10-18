import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/components/FlutterWidgets/app_bars.dart';

import '../../../core/constants/enums/subscriptions_enum.dart';

String get cityChangeRight {
  SubscriptionTypes subscriptionTypes = UserBloc.entitlement;
  switch (subscriptionTypes) {
    case SubscriptionTypes.free:
      return "yok";
    case SubscriptionTypes.admin:
      return "admin";
    case SubscriptionTypes.plus:
      return "∞";
    case SubscriptionTypes.premium:
      return "∞";
  }
}

String get requestBackrollRight {
  SubscriptionTypes subscriptionTypes = UserBloc.entitlement;
  switch (subscriptionTypes) {
    case SubscriptionTypes.free:
      return "yok";
    case SubscriptionTypes.admin:
      return "admin";
    case SubscriptionTypes.plus:
      return "yok";
    case SubscriptionTypes.premium:
      return "∞";
  }
}

String get numOfSendRequest {
  if (UserBloc.user != null) {
    if (UserBloc.user!.numOfSendRequest > 0) {
      return "${UserBloc.user?.numOfSendRequest} adet";
    } else {
      return "yok";
    }
  } else {
    return "error";
  }
}

class RemainingUsageRights extends StatelessWidget {
  const RemainingUsageRights({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(UserBloc.revenueCatResult?.customerInfo.activeSubscriptions);
    return Scaffold(
      appBar: PeoplerAppBars(context: context).RUR,
      body: Column(
        children: [
          const Divider(),
          RurItem(
            iconPath: "assets/premiumfeatures_icons/icon1.svg",
            title: "İstek Gönderme Hakkı",
            trailingText: numOfSendRequest,
          ),
          const Divider(),
          RurItem(
            iconPath: "assets/premiumfeatures_icons/icon6.svg",
            title: "Şehir Değiştirme Hakkı",
            trailingText: cityChangeRight,
          ),
          const Divider(),
          RurItem(
            iconPath: "assets/premiumfeatures_icons/icon2.svg",
            title: "İstek Geri Alma Hakkı",
            trailingText: requestBackrollRight,
          ),
          const Divider(),
        ],
      ),
    );
  }
}

class RurItem extends StatelessWidget {
  final String iconPath;
  final String title;
  final String trailingText;
  const RurItem({
    Key? key,
    required this.iconPath,
    required this.title,
    required this.trailingText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextStyle font = GoogleFonts.dmSans();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                width: 25,
                height: 25,
                child: SvgPicture.asset(
                  iconPath,
                  color: Colors.black,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Text(
                title,
                style: font,
              ),
            ],
          ),
          Text(
            trailingText,
            style: font,
          ),
        ],
      ),
    );
  }
}

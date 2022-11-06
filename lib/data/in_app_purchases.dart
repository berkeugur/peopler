import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../others/strings.dart';

class PurchaseApi {
  static const _apiKeyIOS = 'appl_ywiwctMGVJhMAvcwXcWpUHkUJOo';
  static const _apiKeyAndroid = 'goog_lIWnTrUUfIIBwbuJSPAlbcbIvjb';
  static late CustomerInfo purchaserInfo;
  static late Offering? currentOffering;

  Future<void> init() async {
    await Purchases.setDebugLogsEnabled(Strings.isDebug);

    PurchasesConfiguration? configuration;

    if(Platform.isAndroid) {
      configuration = PurchasesConfiguration(_apiKeyAndroid);
    } else if(Platform.isIOS) {
      configuration = PurchasesConfiguration(_apiKeyIOS);
    }
    await Purchases.configure(configuration!);

    purchaserInfo = await Purchases.getCustomerInfo();
    debugPrint(purchaserInfo.toJson().toString());
  }

  Future<Offering?> fetchCurrentOffer() async {
    try {
      final Offerings offerings = await Purchases.getOfferings();
      debugPrint(offerings.toString());
      return offerings.current;
    } on PlatformException catch(e) {
      debugPrint("Current offer cannot be retrieved");
      return null;
    }
  }

  Future<void> makePurchases(Package package) async {
    UpgradeInfo? upgradeInfo;
    if(purchaserInfo.activeSubscriptions.isNotEmpty) {
      upgradeInfo = UpgradeInfo(purchaserInfo.activeSubscriptions[0], prorationMode: ProrationMode.immediateWithTimeProration);
    }

    try {
      if(Platform.isIOS) {
        purchaserInfo = await Purchases.purchasePackage(package);
      } else if(Platform.isAndroid) {
        purchaserInfo = await Purchases.purchasePackage(package, upgradeInfo: upgradeInfo);
      }
    } on PlatformException catch (e) {
      rethrow;
    }
  }
}
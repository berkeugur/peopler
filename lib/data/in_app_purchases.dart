import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {
  static const _apiKeyIOS = 'appl_ywiwctMGVJhMAvcwXcWpUHkUJOo';
  static const _apiKeyAndroid = 'goog_lIWnTrUUfIIBwbuJSPAlbcbIvjb';
  static late CustomerInfo purchaserInfo;
  static late Offering? currentOffering;

  Future<void> init() async {
    await Purchases.setDebugLogsEnabled(true);

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
    try {
      purchaserInfo = await Purchases.purchasePackage(package);
    } on PlatformException catch (e) {
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
        debugPrint("User cancelled purchase");
      } else {
        debugPrint(e.message);
      }
    }
  }
}
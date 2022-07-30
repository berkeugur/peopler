import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {
  static const _apiKeyIOS = 'appl_ywiwctMGVJhMAvcwXcWpUHkUJOo';
  static const _apiKeyAndroid = 'goog_wckqWIasEAQgEuTWcHcmXFYgenh';
  static late PurchaserInfo purchaserInfo;
  static late Offering? currentOffering;

  Future<void> init() async {
    await Purchases.setDebugLogsEnabled(true);
    if(Platform.isAndroid) {
      await Purchases.setup(_apiKeyAndroid);
    } else if(Platform.isIOS) {
      await Purchases.setup(_apiKeyIOS);
    }
    purchaserInfo = await Purchases.getPurchaserInfo();
    debugPrint(purchaserInfo.toJson().toString());
  }

  /*
  static Future<Map<String, Offering>> fetchOffers() async {
    try {
      final Offerings offerings = await Purchases.getOfferings();
      final Map<String, Offering> offeringsMap = offerings.all;

      return offeringsMap;
    } on PlatformException catch(e) {
      return {};
    }
  }
   */

  Future<Offering?> fetchCurrentOffer() async {
    try {
      final Offerings offerings = await Purchases.getOfferings();
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

  /*
  bool isUserPremium() {
    if(purchaserInfo.entitlements.all["premium"] == null) {
      debugPrint("There is no entitlement called premium");
      return false;
    }
    return purchaserInfo.entitlements.all["premium"]!.isActive;
  }

  bool isUserPlus() {
    if(purchaserInfo.entitlements.all["plus"] == null) {
      debugPrint("There is no entitlement called plus");
      return false;
    }
    return purchaserInfo.entitlements.all["plus"]!.isActive;
  }
   */
}
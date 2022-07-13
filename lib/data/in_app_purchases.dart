import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/models/offering_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class PurchaseApi {
  static const _apiKey = 'appl_ywiwctMGVJhMAvcwXcWpUHkUJOo';

  static Future init() async {
    await Purchases.setDebugLogsEnabled(true);
    await Purchases.setup(_apiKey);
  }

  static Future<Map<String, Offering>> fetchOffers() async {
    try {
      final Offerings offerings = await Purchases.getOfferings();
      final Map<String, Offering> offeringsMap = offerings.all;

      return offeringsMap;
    } on PlatformException catch(e) {
      return {};
    }
  }

  static Future<Offering?> fetchCurrentOffer() async {
    try {
      final Offerings offerings = await Purchases.getOfferings();
      return offerings.current;
    } on PlatformException catch(e) {
      debugPrint("Current offer cannot be retrieved");
      return null;
    }
  }
}
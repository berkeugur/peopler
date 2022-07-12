import 'package:peopler/presentation/screens/subscriptions/subscriptions_page.dart';

enum SubscriptionType { plus, premium }

enum SubscriptionPlan { oneMonth, threeMonth, sixMonth }

class SubscriotionService {
  purchaseButton({required SubscriptionPlan plan, required SubscriptionType type}) {
    if (type == SubscriptionType.plus) {
      switch (plan) {
        case SubscriptionPlan.oneMonth:
          return print("Plus 1 Aylık Planı Satın Alma Butonu Fonksiyonu");
        case SubscriptionPlan.threeMonth:
          return print("Plus 3 Aylık Planı Satın Alma Butonu Fonksiyonu");
        case SubscriptionPlan.sixMonth:
          return print("Plus 6 Aylık Planı Satın Alma Butonu Fonksiyonu");
        default:
          print("impossiable");
      }
    } else if (type == SubscriptionType.premium) {
      switch (plan) {
        case SubscriptionPlan.oneMonth:
          return print("Premium 1 Aylık Planı Satın Alma Butonu Fonksiyonu");
        case SubscriptionPlan.threeMonth:
          return print("Premium 3 Aylık Planı Satın Alma Butonu Fonksiyonu");
        case SubscriptionPlan.sixMonth:
          return print("Premium 6 Aylık Planı Satın Alma Butonu Fonksiyonu");
        default:
          print("impossiable");
      }
    } else {
      print("impossiable");
    }
  }
}

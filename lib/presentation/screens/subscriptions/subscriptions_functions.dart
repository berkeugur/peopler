import 'package:flutter/material.dart';

enum SubscriptionType { plus, premium }

enum SubscriptionPlan { oneMonth, threeMonth, sixMonth }

printf(String text) {
  // ignore: avoid_print
  return print(text);
}

class SubscriptionService {
  purchaseButton({required SubscriptionPlan plan, required SubscriptionType type}) {
    if (type == SubscriptionType.plus) {
      switch (plan) {
        case SubscriptionPlan.oneMonth:
          return printf("Plus 1 Aylık Planı Satın Alma Butonu Fonksiyonu");
        case SubscriptionPlan.threeMonth:
          return printf("Plus 3 Aylık Planı Satın Alma Butonu Fonksiyonu");
        case SubscriptionPlan.sixMonth:
          return printf("Plus 6 Aylık Planı Satın Alma Butonu Fonksiyonu");
        default:
          printf("impossiable");
      }
    } else if (type == SubscriptionType.premium) {
      switch (plan) {
        case SubscriptionPlan.oneMonth:
          return printf("Premium 1 Aylık Planı Satın Alma Butonu Fonksiyonu");
        case SubscriptionPlan.threeMonth:
          return printf("Premium 3 Aylık Planı Satın Alma Butonu Fonksiyonu");
        case SubscriptionPlan.sixMonth:
          return printf("Premium 6 Aylık Planı Satın Alma Butonu Fonksiyonu");
        default:
          printf("impossiable");
      }
    } else {
      printf("impossiable");
    }
  }

  String priceText({required SubscriptionPlan plan, required SubscriptionType type}) {
    String symbol = "₺";
    if (type == SubscriptionType.plus) {
      switch (plan) {
        case SubscriptionPlan.oneMonth:
          return "${39.99} $symbol";
        case SubscriptionPlan.threeMonth:
          return "${99.99} $symbol";
        case SubscriptionPlan.sixMonth:
          return "${179.99} $symbol";
        default:
          return "error $symbol";
      }
    } else if (type == SubscriptionType.premium) {
      switch (plan) {
        case SubscriptionPlan.oneMonth:
          return "${49.99} $symbol";
        case SubscriptionPlan.threeMonth:
          return "${129.99} $symbol";
        case SubscriptionPlan.sixMonth:
          return "${199.99} $symbol";
        default:
          return "error $symbol";
      }
    } else {
      return "error $symbol";
    }
  }

  double price({required SubscriptionPlan plan, required SubscriptionType type}) {
    if (type == SubscriptionType.plus) {
      switch (plan) {
        case SubscriptionPlan.oneMonth:
          return 39.99;
        case SubscriptionPlan.threeMonth:
          return 99.99;
        case SubscriptionPlan.sixMonth:
          return 179.99;
        default:
          return 9999;
      }
    } else if (type == SubscriptionType.premium) {
      switch (plan) {
        case SubscriptionPlan.oneMonth:
          return 49.99;
        case SubscriptionPlan.threeMonth:
          return 129.99;
        case SubscriptionPlan.sixMonth:
          return 199.99;
        default:
          return 999;
      }
    } else {
      return 999;
    }
  }

  //ekstra birşey eklenmesine gerek yok bir aylık plana göre 3 ve 6 aylık planların ne kadar indirimli olduğunu
  //gösterir. Verileri price fonksiyonundan alır
  String discount({required SubscriptionPlan plan, required SubscriptionType type}) {
    if (type == SubscriptionType.plus) {
      switch (plan) {
        case SubscriptionPlan.oneMonth:
          return "";
        case SubscriptionPlan.threeMonth:
          return "%" +
              (100 -
                      ((SubscriptionService().price(plan: SubscriptionPlan.threeMonth, type: SubscriptionType.plus) / 3) * 100) /
                          price(plan: SubscriptionPlan.oneMonth, type: SubscriptionType.plus))
                  .toStringAsFixed(0) +
              " indirim";
        case SubscriptionPlan.sixMonth:
          return "%" +
              (100 -
                      ((SubscriptionService().price(plan: SubscriptionPlan.sixMonth, type: SubscriptionType.plus) / 6) * 100) /
                          price(plan: SubscriptionPlan.oneMonth, type: SubscriptionType.plus))
                  .toStringAsFixed(0) +
              " indirim";
        default:
          return "error";
      }
    } else if (type == SubscriptionType.premium) {
      switch (plan) {
        case SubscriptionPlan.oneMonth:
          return "";
        case SubscriptionPlan.threeMonth:
          return "%" +
              (100 -
                      ((SubscriptionService().price(plan: SubscriptionPlan.threeMonth, type: SubscriptionType.premium) / 3) * 100) /
                          price(plan: SubscriptionPlan.oneMonth, type: SubscriptionType.premium))
                  .toStringAsFixed(0) +
              " indirim";
        case SubscriptionPlan.sixMonth:
          return "%" +
              (100 -
                      ((SubscriptionService().price(plan: SubscriptionPlan.sixMonth, type: SubscriptionType.premium) / 6) * 100) /
                          price(plan: SubscriptionPlan.oneMonth, type: SubscriptionType.premium))
                  .toStringAsFixed(0) +
              " indirim";
        default:
          return "error";
      }
    } else {
      return "error";
    }
  }
}

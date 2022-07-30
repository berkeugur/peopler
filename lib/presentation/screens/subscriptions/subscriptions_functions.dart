import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/data/in_app_purchases.dart';
import '../../../business_logic/blocs/PurchaseMakePurchaseBloc/bloc.dart';

enum SubscriptionType { plus, premium }

enum SubscriptionPlan { oneMonth, threeMonth, sixMonth }

printf(String text) {
  // ignore: avoid_print
  return print(text);
}

class SubscriptionService {
  purchaseButton({required SubscriptionPlan plan, required SubscriptionType type, required BuildContext context}) {
    PurchaseMakePurchaseBloc _purchaseMakePurchaseBloc = BlocProvider.of<PurchaseMakePurchaseBloc>(context);

    if (type == SubscriptionType.plus) {
      switch (plan) {
        case SubscriptionPlan.oneMonth:
          _purchaseMakePurchaseBloc.add(MakePurchaseEvent(package: PurchaseApi.currentOffering?.getPackage("plus_one_month")));
          break;
        case SubscriptionPlan.threeMonth:
          _purchaseMakePurchaseBloc.add(MakePurchaseEvent(package: PurchaseApi.currentOffering?.getPackage("plus_three_month")));
          break;
        case SubscriptionPlan.sixMonth:
          _purchaseMakePurchaseBloc.add(MakePurchaseEvent(package: PurchaseApi.currentOffering?.getPackage("plus_six_month")));
          break;
        default:
          printf("impossible");
          break;
      }
    } else if (type == SubscriptionType.premium) {
      switch (plan) {
        case SubscriptionPlan.oneMonth:
          _purchaseMakePurchaseBloc.add(MakePurchaseEvent(package: PurchaseApi.currentOffering?.getPackage("premium_one_month")));
          break;
        case SubscriptionPlan.threeMonth:
          _purchaseMakePurchaseBloc.add(MakePurchaseEvent(package: PurchaseApi.currentOffering?.getPackage("premium_three_month")));
          break;
        case SubscriptionPlan.sixMonth:
          _purchaseMakePurchaseBloc.add(MakePurchaseEvent(package: PurchaseApi.currentOffering?.getPackage("premium_six_month")));
          break;
        default:
          printf("impossible");
          break;
      }
    } else {
      printf("impossible");
    }
  }

  String priceText({required SubscriptionPlan plan, required SubscriptionType type}) {
    String symbol = "₺";
    if (type == SubscriptionType.plus) {
      switch (plan) {
        case SubscriptionPlan.oneMonth:
          return "${PurchaseApi.currentOffering?.getPackage("plus_one_month")?.product.priceString} $symbol";
        case SubscriptionPlan.threeMonth:
          return "${PurchaseApi.currentOffering?.getPackage("plus_three_month")?.product.priceString} $symbol";
        case SubscriptionPlan.sixMonth:
          return "${PurchaseApi.currentOffering?.getPackage("plus_six_month")?.product.priceString} $symbol";
        default:
          return "error $symbol";
      }
    } else if (type == SubscriptionType.premium) {
      switch (plan) {
        case SubscriptionPlan.oneMonth:
          return "${PurchaseApi.currentOffering?.getPackage("premium_one_month")?.product.priceString} $symbol";
        case SubscriptionPlan.threeMonth:
          return "${PurchaseApi.currentOffering?.getPackage("premium_three_month")?.product.priceString} $symbol";
        case SubscriptionPlan.sixMonth:
          return "${PurchaseApi.currentOffering?.getPackage("premium_six_month")?.product.priceString} $symbol";
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
          return PurchaseApi.currentOffering?.getPackage("plus_one_month")?.product.price ?? 9999;
        case SubscriptionPlan.threeMonth:
          return PurchaseApi.currentOffering?.getPackage("plus_three_month")?.product.price ?? 9999;
        case SubscriptionPlan.sixMonth:
          return PurchaseApi.currentOffering?.getPackage("plus_six_month")?.product.price ?? 9999;
        default:
          return 9999;
      }
    } else if (type == SubscriptionType.premium) {
      switch (plan) {
        case SubscriptionPlan.oneMonth:
          return PurchaseApi.currentOffering?.getPackage("premium_one_month")?.product.price ?? 9999;
        case SubscriptionPlan.threeMonth:
          return PurchaseApi.currentOffering?.getPackage("premium_three_month")?.product.price ?? 9999;
        case SubscriptionPlan.sixMonth:
          return PurchaseApi.currentOffering?.getPackage("premium_six_month")?.product.price ?? 9999;
        default:
          return 999;
      }
    } else {
      return 999;
    }
  }


  /*
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
   */
}

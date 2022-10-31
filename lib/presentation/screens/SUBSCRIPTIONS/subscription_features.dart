import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/enums/subscriptions_enum.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';

class SubscriptionFeatures {
  static List<Widget> plusFeatures = [];
  static List<Widget> premiumFeatures = [];

  void init(tabController) {
    premiumFeatures = [
      subscriptionFeatures(
        imgPath: "assets/premiumfeatures_icons/premium1.png",
        title: "Bağlantı İsteğini Hızlandır",
        subtitle: "Kaydettiğin kullanıcılara bağlantı isteği göndermek için bekleme!",
        tabController: tabController,
        subscriptionType: SubscriptionTypes.premium,
      ),
      subscriptionFeatures(
        imgPath: "assets/premiumfeatures_icons/premium2.png",
        title: "Şehir Değiştir",
        subtitle: "Farklı şehirdeki insanlarla da bağlantıya geç",
        tabController: tabController,
        subscriptionType: SubscriptionTypes.premium,
      ),
      subscriptionFeatures(
        imgPath: "assets/premiumfeatures_icons/premium3.png",
        title: "Peopler Premiuma Geç",
        subtitle: "Sınırsız Bağlantı, Geri Alma, Intro Mesaj, Profiline Bakanları Gör ve çok daha fazlası*",
        tabController: tabController,
        subscriptionType: SubscriptionTypes.premium,
      ),
    ];

    plusFeatures = [
      subscriptionFeatures(
        imgPath: "assets/premiumfeatures_icons/plus1.png",
        title: "Sınırsız Bağlantı İsteği Gönder",
        subtitle: "Etrafında veya şehrindeki insanları kaçırma!",
        tabController: tabController,
        subscriptionType: SubscriptionTypes.plus,
      ),
      subscriptionFeatures(
        imgPath: "assets/premiumfeatures_icons/plus2.png",
        title: "Sildiğin Kullanıcıları Geri Getir",
        subtitle: "Yanlışlıkla sildiğin kullanıcıları geri getir",
        tabController: tabController,
        subscriptionType: SubscriptionTypes.plus,
      ),
      subscriptionFeatures(
        imgPath: "assets/premiumfeatures_icons/plus3.png",
        title: "Intro Mesaj Gönder",
        subtitle: "Bağlantıya geçmediğin kullanıcılara kendini tanıt",
        tabController: tabController,
        subscriptionType: SubscriptionTypes.plus,
      ),
      subscriptionFeatures(
        imgPath: "assets/premiumfeatures_icons/plus4.png",
        title: "Profiline Bakan Kullanıcıları Gör",
        subtitle: "Profiline tıklayan kullancıları gör",
        tabController: tabController,
        subscriptionType: SubscriptionTypes.plus,
      ),
    ];
  }

  Column subscriptionFeatures(
      {required SubscriptionTypes subscriptionType,
      required String imgPath,
      required String title,
      required String subtitle,
      required TabController tabController}) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Image.asset(
          imgPath,
          height: 100,
          width: double.infinity,
          // color: subscriptionType == SubscriptionFeatures.plusFeatures ? Colors.white : const Color(0xFF0353EF),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          title,
          textScaleFactor: 1,
          style: PeoplerTextStyle.normal.copyWith(
            fontSize: 16,
            color: tabController.index == 0 ? Mode().disabledBottomMenuItemAssetColor()! : Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Text(
            subtitle,
            textScaleFactor: 1,
            textAlign: TextAlign.center,
            style: PeoplerTextStyle.normal.copyWith(
              fontSize: 14,
              color: tabController.index == 0 ? Mode().disabledBottomMenuItemAssetColor()! : Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}

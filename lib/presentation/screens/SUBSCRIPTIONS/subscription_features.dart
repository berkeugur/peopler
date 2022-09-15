import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/core/constants/enums/subscriptions_enum.dart';

class SubscriptionFeatures {
  static List<Widget> plusFeatures = [];
  static List<Widget> premiumFeatures = [];

  void init(tabController) {
    premiumFeatures = [
      subscriptionFeatures(
        imgPath: "assets/premiumfeatures_icons/icon5.svg",
        title: "Bağlantı İsteğini Hızlandır",
        subtitle: "Kaydettiğin kullanıcılara bağlantı isteği göndermek için bekleme!",
        tabController: tabController,
        subscriptionType: SubscriptionTypes.premium,
      ),
      subscriptionFeatures(
        imgPath: "assets/premiumfeatures_icons/icon6.svg",
        title: "Şehir Değiştir",
        subtitle: "Farklı şehirdeki insanlarla da bağlantıya geç",
        tabController: tabController,
        subscriptionType: SubscriptionTypes.premium,
      ),
      subscriptionFeatures(
        imgPath: "assets/premiumfeatures_icons/icon7.svg",
        title: "Peopler Premiuma Geç",
        subtitle: "Sınırsız Bağlantı, Geri Alma, Intro Mesaj, Profiline Bakanları Gör ve çok daha fazlası*",
        tabController: tabController,
        subscriptionType: SubscriptionTypes.premium,
      ),
    ];

    plusFeatures = [
      subscriptionFeatures(
        imgPath: "assets/premiumfeatures_icons/icon1.svg",
        title: "Sınırsız Bağlantı İsteği Gönder",
        subtitle: "Etrafında veya şehrindeki insanları kaçırma!",
        tabController: tabController,
        subscriptionType: SubscriptionTypes.plus,
      ),
      subscriptionFeatures(
        imgPath: "assets/premiumfeatures_icons/icon2.svg",
        title: "Sildiğin Kullanıcıları Geri Getir",
        subtitle: "Yanlışlıkla sildiğin kullanıcıları geri getir",
        tabController: tabController,
        subscriptionType: SubscriptionTypes.plus,
      ),
      subscriptionFeatures(
        imgPath: "assets/premiumfeatures_icons/icon3.svg",
        title: "Intro Mesaj Gönder",
        subtitle: "Bağlantıya geçmediğin kullanıcılara kendini tanıt",
        tabController: tabController,
        subscriptionType: SubscriptionTypes.plus,
      ),
      subscriptionFeatures(
        imgPath: "assets/premiumfeatures_icons/icon4.svg",
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
        SizedBox.square(
          child: Container(
            width: 100,
            height: 100,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: subscriptionType != SubscriptionFeatures.plusFeatures ? Colors.white : const Color(0xFF0353EF),
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: tabController.index == 0 ? const Color(0xFF0353EF).withOpacity(0.5) : Colors.white.withOpacity(0.5),
                  spreadRadius: 3.5,
                  blurRadius: 5,
                  offset: const Offset(0, 0), // changes position of shadow
                ),
              ],
            ),
            child: SvgPicture.asset(
              imgPath,
              width: 100,
              height: 100,
              color: subscriptionType == SubscriptionFeatures.plusFeatures ? Colors.white : const Color(0xFF0353EF),
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          title,
          textScaleFactor: 1,
          style: GoogleFonts.rubik(
            fontSize: 16,
            color: tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          subtitle,
          textScaleFactor: 1,
          textAlign: TextAlign.center,
          style: GoogleFonts.rubik(
            fontSize: 14,
            color: tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

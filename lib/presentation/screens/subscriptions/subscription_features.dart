import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

class SubscriptionFeatures {

  static List<Widget> plusFeatures = [];
  static List<Widget> premiumFeatures = [];

  void init(tabController)  {
    premiumFeatures = [
      subscriptionFeatures(
        imgPath: "assets/images/hobby_badges/theater.svg",
        title: "Seni kaydedenleri gör",
        subtitle: "Listesine seni ekleyen kullanıcılar ile iletişime geç",
        tabController: tabController,
      ),
      subscriptionFeatures(
        imgPath: "assets/images/hobby_badges/fitness.svg",
        title: "Fitnatları gör",
        subtitle: "Listesine seni ekleyen kullanıcılar ile iletişime geç",
        tabController: tabController,
      ),
      subscriptionFeatures(
        imgPath: "assets/images/hobby_badges/origami.svg",
        title: "Origami oyna",
        subtitle: "Listesine seni ekleyen kullanıcılar ile iletişime geç",
        tabController: tabController,
      ),
    ];

    plusFeatures = [
      subscriptionFeatures(
        imgPath: "assets/images/hobby_badges/theater.svg",
        title: "Seni kaydedenleri gör",
        subtitle: "Listesine seni ekleyen kullanıcılar ile iletişime geç",
        tabController: tabController,
      ),
      subscriptionFeatures(
        imgPath: "assets/images/hobby_badges/fitness.svg",
        title: "Fitnatları gör",
        subtitle: "Listesine seni ekleyen kullanıcılar ile iletişime geç",
        tabController: tabController,
      ),
      subscriptionFeatures(
        imgPath: "assets/images/hobby_badges/origami.svg",
        title: "Origami oyna",
        subtitle: "Listesine seni ekleyen kullanıcılar ile iletişime geç",
        tabController: tabController,
      ),
    ];
  }

  Column subscriptionFeatures(
      {required String imgPath,
        required String title,
        required String subtitle,
        required TabController tabController}) {
    return Column(
      children: [
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
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
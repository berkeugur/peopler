import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/presentation/screens/feeds/FeedScreen/feed_functions.dart';
import 'package:peopler/presentation/screens/subscriptions/subscriptions_functions.dart';

class SubscriptionsPage extends StatefulWidget {
  @override
  _SubscriptionsPageState createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      print('my index is' + _tabController.index.toString());
      setState(() {
        premiumFeatures = [
          subscriptionFeatures(
            imgPath: "assets/images/hobby_badges/theater.svg",
            title: "Seni kaydedenleri gör",
            subtitle: "Listesine seni ekleyen kullanıcılar ile iletişime geç",
            tabController: _tabController,
          ),
          subscriptionFeatures(
            imgPath: "assets/images/hobby_badges/fitness.svg",
            title: "Fitnatları gör",
            subtitle: "Listesine seni ekleyen kullanıcılar ile iletişime geç",
            tabController: _tabController,
          ),
          subscriptionFeatures(
            imgPath: "assets/images/hobby_badges/origami.svg",
            title: "Origami oyna",
            subtitle: "Listesine seni ekleyen kullanıcılar ile iletişime geç",
            tabController: _tabController,
          ),
        ];

        plusFeatures = [
          subscriptionFeatures(
            imgPath: "assets/images/hobby_badges/theater.svg",
            title: "Seni kaydedenleri gör",
            subtitle: "Listesine seni ekleyen kullanıcılar ile iletişime geç",
            tabController: _tabController,
          ),
          subscriptionFeatures(
            imgPath: "assets/images/hobby_badges/fitness.svg",
            title: "Fitnatları gör",
            subtitle: "Listesine seni ekleyen kullanıcılar ile iletişime geç",
            tabController: _tabController,
          ),
          subscriptionFeatures(
            imgPath: "assets/images/hobby_badges/origami.svg",
            title: "Origami oyna",
            subtitle: "Listesine seni ekleyen kullanıcılar ile iletişime geç",
            tabController: _tabController,
          ),
        ];
        scaffoldColor = scaffoldColor = _tabController.index == 0 ? Colors.white : Color(0xFF0353EF);
      });
    });

    premiumFeatures = [
      subscriptionFeatures(
        imgPath: "assets/images/hobby_badges/theater.svg",
        title: "Seni kaydedenleri gör",
        subtitle: "Listesine seni ekleyen kullanıcılar ile iletişime geç",
        tabController: _tabController,
      ),
      subscriptionFeatures(
        imgPath: "assets/images/hobby_badges/fitness.svg",
        title: "Fitnatları gör",
        subtitle: "Listesine seni ekleyen kullanıcılar ile iletişime geç",
        tabController: _tabController,
      ),
      subscriptionFeatures(
        imgPath: "assets/images/hobby_badges/origami.svg",
        title: "Origami oyna",
        subtitle: "Listesine seni ekleyen kullanıcılar ile iletişime geç",
        tabController: _tabController,
      ),
    ];

    plusFeatures = [
      subscriptionFeatures(
        imgPath: "assets/images/hobby_badges/theater.svg",
        title: "Seni kaydedenleri gör",
        subtitle: "Listesine seni ekleyen kullanıcılar ile iletişime geç",
        tabController: _tabController,
      ),
      subscriptionFeatures(
        imgPath: "assets/images/hobby_badges/fitness.svg",
        title: "Fitnatları gör",
        subtitle: "Listesine seni ekleyen kullanıcılar ile iletişime geç",
        tabController: _tabController,
      ),
      subscriptionFeatures(
        imgPath: "assets/images/hobby_badges/origami.svg",
        title: "Origami oyna",
        subtitle: "Listesine seni ekleyen kullanıcılar ile iletişime geç",
        tabController: _tabController,
      ),
    ];
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  List<Widget> plusFeatures = [];

  List<Widget> premiumFeatures = [];

  //1 aylık plan index 0, 3 aylık 1, 6 aylık 2,
  int selectedPlusPlanIndex = 1;
  int selectedPremiumPlanIndex = 1;
  late Color? scaffoldColor = _tabController.index == 0 ? Colors.white : Color(0xFF0353EF);
  @override
  Widget build(BuildContext context) {
    scaffoldColor = scaffoldColor = _tabController.index == 0 ? Colors.white : Color(0xFF0353EF);

    print(_tabController.index);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          leading: Container(
            padding: EdgeInsets.all(10),
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: SvgPicture.asset(
                "assets/images/svg_icons/back_arrow.svg",
                width: 25,
                height: 25,
                color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
              ),
            ),
          ),
          backgroundColor: _tabController.index == 0 ? Colors.white : Color(0xFF0353EF),
        ),
        backgroundColor: scaffoldColor,
        body: Column(
          children: [
            // give the tab bar a height [can change hheight to preferred height]
            Container(
              height: 30,
              padding: const EdgeInsets.symmetric(horizontal: 60),
              decoration: BoxDecoration(
                //color: Colors.grey[300],
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
              ),
              child: TabBar(
                onTap: (index) {
                  setState(() {});
                },
                controller: _tabController,
                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                ),
                labelColor: scaffoldColor,
                unselectedLabelColor: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                tabs: [
                  // first tab [you can add an icon using the icon property]
                  Tab(
                    child: Text(
                      "Plus",
                      textScaleFactor: 1,
                      style: GoogleFonts.rubik(),
                    ),
                  ),

                  // second tab [you can add an icon using the icon property]
                  Tab(
                    child: Text(
                      "Premium",
                      textScaleFactor: 1,
                      style: GoogleFonts.rubik(),
                    ),
                  ),
                ],
              ),
            ),
            // tab bar view here
            Expanded(
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 70 - 45,
                  child: TabBarView(
                    physics: const BouncingScrollPhysics(),
                    controller: _tabController,
                    children: [
                      // first tab [you can add an icon using the icon property]
                      PlusTab(context),

                      // second tab [you can add an icon using the icon property]
                      PremiumTab(context),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget PremiumTab(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        height: 500,
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1,
                autoPlay: true,
                aspectRatio: 4 / 2,
                enlargeCenterPage: true,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
              ),
              items: premiumFeatures,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 40),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedPremiumPlanIndex = 0;
                      });
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 100) / 3,
                      margin: selectedPremiumPlanIndex == 0
                          ? const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 20)
                          : const EdgeInsets.all(5),
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: selectedPremiumPlanIndex == 0 ? 2 : 1,
                          color: selectedPremiumPlanIndex == 0
                              ? _tabController.index == 0
                                  ? Color(0xFF0353EF)
                                  : Colors.white
                              : const Color.fromARGB(255, 194, 194, 194),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: selectedPremiumPlanIndex == 0 ? 4 : 1,
                                  color: selectedPremiumPlanIndex == 0
                                      ? _tabController.index == 0
                                          ? Color(0xFF0353EF)
                                          : Colors.white
                                      : Colors.transparent),
                              borderRadius:
                                  BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13)),
                              color: selectedPremiumPlanIndex != 0
                                  ? scaffoldColor
                                  : _tabController.index == 0
                                      ? Color(0xFF0353EF)
                                      : Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "EN UYGUN",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.rubik(
                                    fontSize: selectedPremiumPlanIndex != 0 ? 12 : 13,
                                    color: selectedPremiumPlanIndex == 0
                                        ? scaffoldColor
                                        : _tabController.index == 0
                                            ? Color(0xFF0353EF)
                                            : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "6",
                                      textScaleFactor: 1,
                                      style: GoogleFonts.rubik(
                                        fontSize: 16,
                                        color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "ay",
                                      textScaleFactor: 1,
                                      style: GoogleFonts.rubik(
                                        fontSize: 16,
                                        color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "179.99TL",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.rubik(
                                    fontSize: 16,
                                    color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(99),
                                    color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                  ),
                                  child: Text(
                                    "%12 indirim",
                                    textScaleFactor: 1,
                                    style: GoogleFonts.rubik(
                                      fontSize: 14,
                                      color: scaffoldColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${(179.99 / 3).toStringAsFixed(2)}/ay",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.rubik(
                                    fontSize: 12,
                                    color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedPremiumPlanIndex = 1;
                      });
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 100) / 3,
                      margin: selectedPremiumPlanIndex == 1
                          ? const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 20)
                          : const EdgeInsets.all(5),
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: selectedPremiumPlanIndex == 1 ? 2 : 1,
                          color: selectedPremiumPlanIndex == 1
                              ? _tabController.index == 0
                                  ? Color(0xFF0353EF)
                                  : Colors.white
                              : const Color.fromARGB(255, 194, 194, 194),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: selectedPremiumPlanIndex == 1 ? 4 : 1,
                                  color: selectedPremiumPlanIndex == 1
                                      ? _tabController.index == 0
                                          ? Color(0xFF0353EF)
                                          : Colors.white
                                      : Colors.transparent),
                              borderRadius:
                                  BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13)),
                              color: selectedPremiumPlanIndex != 1
                                  ? scaffoldColor
                                  : _tabController.index == 0
                                      ? Color(0xFF0353EF)
                                      : Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "EN POPÜLER",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.rubik(
                                    fontSize: selectedPremiumPlanIndex != 1 ? 12 : 13,
                                    color: selectedPremiumPlanIndex == 1
                                        ? scaffoldColor
                                        : _tabController.index == 0
                                            ? Color(0xFF0353EF)
                                            : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "3",
                                      textScaleFactor: 1,
                                      style: GoogleFonts.rubik(
                                        fontSize: 16,
                                        color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "ay",
                                      textScaleFactor: 1,
                                      style: GoogleFonts.rubik(
                                        fontSize: 16,
                                        color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "99.99TL",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.rubik(
                                    fontSize: 16,
                                    color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(99),
                                    color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                  ),
                                  child: Text(
                                    "%12 indirim",
                                    textScaleFactor: 1,
                                    style: GoogleFonts.rubik(
                                      fontSize: 14,
                                      color: scaffoldColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${99.99 / 3}/ay",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.rubik(
                                    fontSize: 12,
                                    color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        print("hebele gübele");
                        selectedPremiumPlanIndex = 2;
                      });
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 100) / 3,
                      margin: selectedPremiumPlanIndex == 2
                          ? const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 20)
                          : const EdgeInsets.all(5),
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: selectedPremiumPlanIndex == 2 ? 2 : 1,
                          color: selectedPremiumPlanIndex == 2
                              ? _tabController.index == 0
                                  ? Color(0xFF0353EF)
                                  : Colors.white
                              : const Color.fromARGB(255, 194, 194, 194),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  " ",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.rubik(
                                    fontSize: selectedPremiumPlanIndex != 0 ? 12 : 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "1",
                                      textScaleFactor: 1,
                                      style: GoogleFonts.rubik(
                                        fontSize: 16,
                                        color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "ay",
                                      textScaleFactor: 1,
                                      style: GoogleFonts.rubik(
                                        fontSize: 16,
                                        color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "39.99TL",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.rubik(
                                    fontSize: 16,
                                    color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                  child: Text(
                                    " ",
                                    textScaleFactor: 1,
                                    style: GoogleFonts.rubik(
                                      fontSize: 14,
                                      color: scaffoldColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  " ",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.rubik(
                                    fontSize: 12,
                                    color: scaffoldColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(40),
              child: InkWell(
                onTap: () {
                  if (selectedPremiumPlanIndex == 0) {
                    SubscriotionService()
                        .purchaseButton(plan: SubscriptionPlan.sixMonth, type: SubscriptionType.premium);
                  } else if (selectedPremiumPlanIndex == 1) {
                    SubscriotionService()
                        .purchaseButton(plan: SubscriptionPlan.threeMonth, type: SubscriptionType.premium);
                  } else if (selectedPremiumPlanIndex == 2) {
                    SubscriotionService()
                        .purchaseButton(plan: SubscriptionPlan.oneMonth, type: SubscriptionType.premium);
                  } else {
                    print("3 index var else imkansız.");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                    color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "HEMEN SATIN AL",
                        textScaleFactor: 1,
                        style: GoogleFonts.rubik(
                          color: scaffoldColor,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }

  Column subscriptionFeatures(
      {required String imgPath,
      required String title,
      required String subtitle,
      required TabController tabController}) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            boxShadow: [
              BoxShadow(
                color: tabController.index == 0 ? Color(0xFF0353EF).withOpacity(0.5) : Colors.white.withOpacity(0.5),
                spreadRadius: 3.5,
                blurRadius: 5,
                offset: Offset(0, 0), // changes position of shadow
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
            color: tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
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
            color: tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget PlusTab(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        height: 500,
        child: Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                viewportFraction: 1,
                autoPlay: true,
                aspectRatio: 4 / 2,
                enlargeCenterPage: true,
                enlargeStrategy: CenterPageEnlargeStrategy.height,
              ),
              items: plusFeatures,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 40),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedPlusPlanIndex = 0;
                      });
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 100) / 3,
                      margin: selectedPlusPlanIndex == 0
                          ? const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 20)
                          : const EdgeInsets.all(5),
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: selectedPlusPlanIndex == 0 ? 2 : 1,
                          color: selectedPlusPlanIndex == 0
                              ? _tabController.index == 0
                                  ? Color(0xFF0353EF)
                                  : Colors.white
                              : const Color.fromARGB(255, 194, 194, 194),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: selectedPlusPlanIndex == 0 ? 4 : 1,
                                  color: selectedPlusPlanIndex == 0
                                      ? _tabController.index == 0
                                          ? Color(0xFF0353EF)
                                          : Colors.white
                                      : Colors.transparent),
                              borderRadius:
                                  BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13)),
                              color: selectedPlusPlanIndex != 0
                                  ? scaffoldColor
                                  : _tabController.index == 0
                                      ? Color(0xFF0353EF)
                                      : Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "EN UYGUN",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.rubik(
                                    fontSize: selectedPlusPlanIndex != 0 ? 12 : 13,
                                    color: selectedPlusPlanIndex == 0
                                        ? scaffoldColor
                                        : _tabController.index == 0
                                            ? Color(0xFF0353EF)
                                            : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "6",
                                      textScaleFactor: 1,
                                      style: GoogleFonts.rubik(
                                        fontSize: 16,
                                        color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "ay",
                                      textScaleFactor: 1,
                                      style: GoogleFonts.rubik(
                                        fontSize: 16,
                                        color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "179.99TL",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.rubik(
                                    fontSize: 16,
                                    color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(99),
                                    color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                  ),
                                  child: Text(
                                    "%12 indirim",
                                    textScaleFactor: 1,
                                    style: GoogleFonts.rubik(
                                      fontSize: 14,
                                      color: scaffoldColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${(179.99 / 3).toStringAsFixed(2)}/ay",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.rubik(
                                    fontSize: 12,
                                    color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedPlusPlanIndex = 1;
                      });
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 100) / 3,
                      margin: selectedPlusPlanIndex == 1
                          ? const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 20)
                          : const EdgeInsets.all(5),
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: selectedPlusPlanIndex == 1 ? 2 : 1,
                          color: selectedPlusPlanIndex == 1
                              ? _tabController.index == 0
                                  ? Color(0xFF0353EF)
                                  : Colors.white
                              : const Color.fromARGB(255, 194, 194, 194),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  width: selectedPlusPlanIndex == 1 ? 4 : 1,
                                  color: selectedPlusPlanIndex == 1
                                      ? _tabController.index == 0
                                          ? Color(0xFF0353EF)
                                          : Colors.white
                                      : Colors.transparent),
                              borderRadius:
                                  BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13)),
                              color: selectedPlusPlanIndex != 1
                                  ? scaffoldColor
                                  : _tabController.index == 0
                                      ? Color(0xFF0353EF)
                                      : Colors.white,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "EN POPÜLER",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.rubik(
                                    fontSize: selectedPlusPlanIndex != 1 ? 12 : 13,
                                    color: selectedPlusPlanIndex == 1
                                        ? scaffoldColor
                                        : _tabController.index == 0
                                            ? Color(0xFF0353EF)
                                            : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "3",
                                      textScaleFactor: 1,
                                      style: GoogleFonts.rubik(
                                        fontSize: 16,
                                        color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "ay",
                                      textScaleFactor: 1,
                                      style: GoogleFonts.rubik(
                                        fontSize: 16,
                                        color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "99.99TL",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.rubik(
                                    fontSize: 16,
                                    color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(99),
                                    color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                  ),
                                  child: Text(
                                    "%12 indirim",
                                    textScaleFactor: 1,
                                    style: GoogleFonts.rubik(
                                      fontSize: 14,
                                      color: scaffoldColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${99.99 / 3}/ay",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.rubik(
                                    fontSize: 12,
                                    color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedPlusPlanIndex = 2;
                      });
                    },
                    child: Container(
                      width: (MediaQuery.of(context).size.width - 100) / 3,
                      margin: selectedPlusPlanIndex == 2
                          ? const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 20)
                          : const EdgeInsets.all(5),
                      height: 150,
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: selectedPlusPlanIndex == 2 ? 2 : 1,
                          color: selectedPlusPlanIndex == 2
                              ? _tabController.index == 0
                                  ? Color(0xFF0353EF)
                                  : Colors.white
                              : const Color.fromARGB(255, 194, 194, 194),
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  " ",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.rubik(
                                    fontSize: selectedPlusPlanIndex != 0 ? 12 : 13,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "1",
                                      textScaleFactor: 1,
                                      style: GoogleFonts.rubik(
                                        fontSize: 16,
                                        color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "ay",
                                      textScaleFactor: 1,
                                      style: GoogleFonts.rubik(
                                        fontSize: 16,
                                        color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  "39.99TL",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.rubik(
                                    fontSize: 16,
                                    color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                  child: Text(
                                    " ",
                                    textScaleFactor: 1,
                                    style: GoogleFonts.rubik(
                                      fontSize: 14,
                                      color: scaffoldColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  " ",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.rubik(
                                    fontSize: 12,
                                    color: scaffoldColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.all(40),
              child: InkWell(
                onTap: () {
                  print("selected premium plan inde = $selectedPlusPlanIndex");
                  if (selectedPlusPlanIndex == 0) {
                    SubscriotionService().purchaseButton(plan: SubscriptionPlan.sixMonth, type: SubscriptionType.plus);
                  } else if (selectedPlusPlanIndex == 1) {
                    SubscriotionService()
                        .purchaseButton(plan: SubscriptionPlan.threeMonth, type: SubscriptionType.plus);
                  } else if (selectedPlusPlanIndex == 2) {
                    SubscriotionService().purchaseButton(plan: SubscriptionPlan.oneMonth, type: SubscriptionType.plus);
                  } else {
                    print("3 index var else imkansız.");
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                    color: _tabController.index == 0 ? Color(0xFF0353EF) : Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "HEMEN SATIN AL",
                        textScaleFactor: 1,
                        style: GoogleFonts.rubik(
                          color: scaffoldColor,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        ));
  }
}

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/presentation/screens/subscriptions/subscription_features.dart';
import 'package:peopler/presentation/screens/subscriptions/subscriptions_functions.dart';

class SubscriptionsPage extends StatefulWidget {
  const SubscriptionsPage({Key? key}) : super(key: key);

  @override
  _SubscriptionsPageState createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SubscriptionFeatures _subscriptionFeatures = SubscriptionFeatures();

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      debugPrint('my index is $_tabController.index.toString()');
      setState(() {
        _subscriptionFeatures.init(_tabController);
        scaffoldColor = scaffoldColor = _tabController.index == 0 ? Colors.white : const Color(0xFF0353EF);
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  //1 aylık plan index 0, 3 aylık 1, 6 aylık 2,
  int selectedPlusPlanIndex = 1;
  int selectedPremiumPlanIndex = 1;
  late Color? scaffoldColor = _tabController.index == 0 ? Colors.white : const Color(0xFF0353EF);

  @override
  Widget build(BuildContext context) {
    scaffoldColor = scaffoldColor = _tabController.index == 0 ? Colors.white : const Color(0xFF0353EF);

    debugPrint(_tabController.index.toString());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Colors.transparent,
          leading: Container(
            padding: const EdgeInsets.all(10),
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: SvgPicture.asset(
                "assets/images/svg_icons/back_arrow.svg",
                width: 25,
                height: 25,
                color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
              ),
            ),
          ),
          backgroundColor: _tabController.index == 0 ? Colors.white : const Color(0xFF0353EF),
        ),
        backgroundColor: scaffoldColor,
        body: Column(
          children: [
            // give the tab bar a height [can change height to preferred height]
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
                  color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
                ),
                labelColor: scaffoldColor,
                unselectedLabelColor: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
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
                      plusTab(context),

                      // second tab [you can add an icon using the icon property]
                      premiumTab(context),
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

  Widget premiumTab(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 40),
        height: 500,
        child: Column(
          children: [
            const SizedBox(
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
              items: SubscriptionFeatures.premiumFeatures,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 40),
              child: Row(
                children: [
                  _buildSixMonthPremiumWidget(context),
                  _buildThreeMonthPremiumWidget(context),
                  _buildOneMonthPremiumWidget(context),
                ],
              ),
            ),
            _buildBuyImmediatelyPremiumButton()
          ],
        ));
  }

  InkWell _buildSixMonthPremiumWidget(BuildContext context) {
    return InkWell(
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
                ? const Color(0xFF0353EF)
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
                        ? const Color(0xFF0353EF)
                        : Colors.white
                        : Colors.transparent),
                borderRadius:
                const BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13)),
                color: selectedPremiumPlanIndex != 0
                    ? scaffoldColor
                    : _tabController.index == 0
                    ? const Color(0xFF0353EF)
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
                          ? const Color(0xFF0353EF)
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
                          color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "ay",
                        textScaleFactor: 1,
                        style: GoogleFonts.rubik(
                          fontSize: 16,
                          color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
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
                      color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
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
                      color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell _buildThreeMonthPremiumWidget(BuildContext context) {
    return InkWell(
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
                ? const Color(0xFF0353EF)
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
                        ? const Color(0xFF0353EF)
                        : Colors.white
                        : Colors.transparent),
                borderRadius:
                const BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13)),
                color: selectedPremiumPlanIndex != 1
                    ? scaffoldColor
                    : _tabController.index == 0
                    ? const Color(0xFF0353EF)
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
                          ? const Color(0xFF0353EF)
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
                          color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "ay",
                        textScaleFactor: 1,
                        style: GoogleFonts.rubik(
                          fontSize: 16,
                          color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
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
                      color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
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
                      color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell _buildOneMonthPremiumWidget(BuildContext context) {
    return InkWell(
                  onTap: () {
                    setState(() {
                      debugPrint("hebele gübele");
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
                                ? const Color(0xFF0353EF)
                                : Colors.white
                            : const Color.fromARGB(255, 194, 194, 194),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
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
                                      color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "ay",
                                    textScaleFactor: 1,
                                    style: GoogleFonts.rubik(
                                      fontSize: 16,
                                      color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
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
                                  color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
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
                );
  }

  Container _buildBuyImmediatelyPremiumButton() {
    return Container(
            margin: const EdgeInsets.all(40),
            child: InkWell(
              onTap: () {
                if (selectedPremiumPlanIndex == 0) {
                  SubscriptionService()
                      .purchaseButton(plan: SubscriptionPlan.sixMonth, type: SubscriptionType.premium);
                } else if (selectedPremiumPlanIndex == 1) {
                  SubscriptionService()
                      .purchaseButton(plan: SubscriptionPlan.threeMonth, type: SubscriptionType.premium);
                } else if (selectedPremiumPlanIndex == 2) {
                  SubscriptionService()
                      .purchaseButton(plan: SubscriptionPlan.oneMonth, type: SubscriptionType.premium);
                } else {
                  debugPrint("3 index var else imkansız.");
                }
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
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
          );
  }

  Widget plusTab(BuildContext context) {
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
              items: SubscriptionFeatures.plusFeatures,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 40),
              child: Row(
                children: [
                  _buildSixMonthPlusWidget(context),
                  _buildThreeMonthPlusWidget(context),
                  _buildOneMonthPlusWidget(context),
                ],
              ),
            ),
            _buildBuyImmediatelyPlusButton()
          ],
        ));
  }

  InkWell _buildSixMonthPlusWidget(BuildContext context) {
    return InkWell(
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
                ? const Color(0xFF0353EF)
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
                        ? const Color(0xFF0353EF)
                        : Colors.white
                        : Colors.transparent),
                borderRadius:
                const BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13)),
                color: selectedPlusPlanIndex != 0
                    ? scaffoldColor
                    : _tabController.index == 0
                    ? const Color(0xFF0353EF)
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
                          ? const Color(0xFF0353EF)
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
                          color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "ay",
                        textScaleFactor: 1,
                        style: GoogleFonts.rubik(
                          fontSize: 16,
                          color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
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
                      color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
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
                      color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell _buildThreeMonthPlusWidget(BuildContext context) {
    return InkWell(
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
                ? const Color(0xFF0353EF)
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
                        ? const Color(0xFF0353EF)
                        : Colors.white
                        : Colors.transparent),
                borderRadius:
                const BorderRadius.only(topLeft: Radius.circular(13), topRight: Radius.circular(13)),
                color: selectedPlusPlanIndex != 1
                    ? scaffoldColor
                    : _tabController.index == 0
                    ? const Color(0xFF0353EF)
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
                          ? const Color(0xFF0353EF)
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
                          color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "ay",
                        textScaleFactor: 1,
                        style: GoogleFonts.rubik(
                          fontSize: 16,
                          color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
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
                      color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(99),
                      color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
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
                      color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InkWell _buildOneMonthPlusWidget(BuildContext context) {
    return InkWell(
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
                                ? const Color(0xFF0353EF)
                                : Colors.white
                            : const Color.fromARGB(255, 194, 194, 194),
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
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
                                      color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "ay",
                                    textScaleFactor: 1,
                                    style: GoogleFonts.rubik(
                                      fontSize: 16,
                                      color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
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
                                  color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
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
                );
  }

  Container _buildBuyImmediatelyPlusButton() {
    return Container(
            margin: const EdgeInsets.all(40),
            child: InkWell(
              onTap: () {
                debugPrint("selected premium plan index = $selectedPlusPlanIndex");
                if (selectedPlusPlanIndex == 0) {
                  SubscriptionService().purchaseButton(plan: SubscriptionPlan.sixMonth, type: SubscriptionType.plus);
                } else if (selectedPlusPlanIndex == 1) {
                  SubscriptionService()
                      .purchaseButton(plan: SubscriptionPlan.threeMonth, type: SubscriptionType.plus);
                } else if (selectedPlusPlanIndex == 2) {
                  SubscriptionService().purchaseButton(plan: SubscriptionPlan.oneMonth, type: SubscriptionType.plus);
                } else {
                  debugPrint("3 index var else imkansız.");
                }
              },
              child: Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  color: _tabController.index == 0 ? const Color(0xFF0353EF) : Colors.white,
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
          );
  }
}

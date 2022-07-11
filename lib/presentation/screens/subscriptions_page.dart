import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/presentation/screens/feeds/FeedScreen/feed_functions.dart';

Column subscriptionFeatures({required String imgPath, required String title, required String subtitle}) {
  return Column(
    children: [
      SvgPicture.asset(
        imgPath,
        width: 100,
        height: 100,
      ),
      SizedBox(
        height: 20,
      ),
      Text(
        title,
        textScaleFactor: 1,
        style: GoogleFonts.rubik(
          fontSize: 16,
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
      SizedBox(
        height: 15,
      ),
      Text(
        subtitle,
        textScaleFactor: 1,
        textAlign: TextAlign.center,
        style: GoogleFonts.rubik(
          fontSize: 14,
          color: Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}

class SubscriptionsPage extends StatefulWidget {
  @override
  _SubscriptionsPageState createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  List<Widget> features = [
    subscriptionFeatures(
      imgPath: "assets/images/hobby_badges/theater.svg",
      title: "Seni kaydedenleri gör",
      subtitle: "Listesine seni ekleyen kullanıcılar ile iletişime geç",
    ),
    subscriptionFeatures(
      imgPath: "assets/images/hobby_badges/fitness.svg",
      title: "Fitnatları gör",
      subtitle: "Listesine seni ekleyen kullanıcılar ile iletişime geç",
    ),
    subscriptionFeatures(
      imgPath: "assets/images/hobby_badges/origami.svg",
      title: "Origami oyna",
      subtitle: "Listesine seni ekleyen kullanıcılar ile iletişime geç",
    ),
  ];

  //1 aylık plan index 0, 3 aylık 1, 6 aylık 2,
  int selectedPlanIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0353EF),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Column(
          children: [
            // give the tab bar a height [can change hheight to preferred height]
            Container(
              height: 30,
              padding: EdgeInsets.symmetric(horizontal: 20),
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
                  color: Colors.white,
                ),
                labelColor: Color(0xFF0353EF),
                unselectedLabelColor: Colors.white,
                tabs: [
                  // first tab [you can add an icon using the icon property]
                  Tab(
                    text: 'Plus',
                  ),

                  // second tab [you can add an icon using the icon property]
                  Tab(
                    text: 'Premium',
                  ),
                ],
              ),
            ),
            // tab bar view here
            Expanded(
              child: TabBarView(
                physics: ClampingScrollPhysics(),
                controller: _tabController,
                children: [
                  // first tab [you can add an icon using the icon property]
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        color: Color(0xFF0353EF),
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
                              items: features,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 40),
                              child: Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedPlanIndex = 0;
                                      });
                                    },
                                    child: Container(
                                      width: (MediaQuery.of(context).size.width - 100) / 3,
                                      margin: selectedPlanIndex == 0
                                          ? EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 20)
                                          : EdgeInsets.all(5),
                                      height: 150,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: selectedPlanIndex == 0 ? 2 : 1,
                                          color: selectedPlanIndex == 0
                                              ? Colors.white
                                              : Color.fromARGB(255, 194, 194, 194),
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Column(mainAxisSize: MainAxisSize.min, children: []),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedPlanIndex = 1;
                                      });
                                    },
                                    child: Container(
                                      width: (MediaQuery.of(context).size.width - 100) / 3,
                                      margin: selectedPlanIndex == 1
                                          ? EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 20)
                                          : EdgeInsets.all(5),
                                      height: 150,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: selectedPlanIndex == 1 ? 2 : 1,
                                          color: selectedPlanIndex == 1
                                              ? Colors.white
                                              : Color.fromARGB(255, 194, 194, 194),
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedPlanIndex = 2;
                                      });
                                    },
                                    child: Container(
                                      width: (MediaQuery.of(context).size.width - 100) / 3,
                                      margin: selectedPlanIndex == 2
                                          ? EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 20)
                                          : EdgeInsets.all(5),
                                      height: 150,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: selectedPlanIndex == 2 ? 2 : 1,
                                          color: selectedPlanIndex == 2
                                              ? Colors.white
                                              : Color.fromARGB(255, 194, 194, 194),
                                        ),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(99),
                                color: Colors.white,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "HEMEN SATIN AL",
                                    textScaleFactor: 1,
                                    style: GoogleFonts.rubik(
                                      color: Color(0xFF0353EF),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        )),
                  ),

                  // second tab [you can add an icon using the icon property]
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(40),
                      color: Color(0xFF0353EF),
                      height: 500,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        color: Colors.white,
                        child: Center(child: Text("premium")),
                      ),
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
}

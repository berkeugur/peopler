import 'package:flutter/material.dart';
import 'bottom_buttons.dart';
import 'constants.dart';
import 'one_page.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingPageState createState() => _OnBoardingPageState();
}

int currentOnBoardingScreenIndex = 0;

class _OnBoardingPageState extends State<OnBoardingScreen> /*with ChangeNotifier*/ {
  final _controller = PageController();

  // OpenPainter _painter = OpenPainter(3, 1);

  @override
  Widget build(BuildContext context) {
    return onBoardingList();
  }

  createCircle({required int index}) {
    return AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.only(right: 4),
        height: 5,
        width: currentOnBoardingScreenIndex == index ? 15 : 5,
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(3)));
  }

  Widget onBoardingList() {
    return Container(
      color: OnBoardingScreenDataList.screen_list[currentOnBoardingScreenIndex].backgroundColor,
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          color: OnBoardingScreenDataList.screen_list[currentOnBoardingScreenIndex].backgroundColor,
          alignment: Alignment.center,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        alignment: Alignment.center,
                        child: PageView(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          controller: _controller,
                          onPageChanged: (value) {
                            // _painter.changeIndex(value);
                            setState(() {
                              currentOnBoardingScreenIndex = value;
                            });
                            // notifyListeners();
                          },
                          children: OnBoardingScreenDataList.screen_list.map((e) => ExplanationPage(screen: e)).toList(),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(OnBoardingScreenDataList.screen_list.length, (index) => createCircle(index: index)),
                              )),
                          Row(
                            mainAxisAlignment: currentOnBoardingScreenIndex != OnBoardingScreenDataList.screen_list.length - 1
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.center,
                            children: [
                              BottomButtons(
                                currentIndex: currentOnBoardingScreenIndex,
                                dataLength: OnBoardingScreenDataList.screen_list.length,
                                controller: _controller,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

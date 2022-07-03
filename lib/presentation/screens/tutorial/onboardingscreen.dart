import 'package:flutter/material.dart';
import 'bottom_buttons.dart';
import 'constants.dart';
import 'one_page.dart';

class TutorialScreen extends StatefulWidget {
  const TutorialScreen({Key? key}) : super(key: key);

  @override
  _TutorialScreenState createState() => _TutorialScreenState();
}

int currentOnBoardingScreenIndex = 0;

class _TutorialScreenState extends State<TutorialScreen> /*with ChangeNotifier*/ {
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
        color: TutorialDataList.screen_list[currentOnBoardingScreenIndex].backgroundColor,
        child: SafeArea(
            child: Container(
          padding: const EdgeInsets.all(16),
          color: TutorialDataList.screen_list[currentOnBoardingScreenIndex].backgroundColor,
          alignment: Alignment.center,
          child: Column(children: [
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      alignment: Alignment.center,
                      child: PageView(
                        scrollDirection: Axis.horizontal,
                        controller: _controller,
                        onPageChanged: (value) {
                          // _painter.changeIndex(value);
                          setState(() {
                            currentOnBoardingScreenIndex = value;
                          });
                          // notifyListeners();
                        },
                        children: TutorialDataList.screen_list.map((e) => ExplanationPage(screen: e)).toList(),
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
                                children: List.generate(
                                    TutorialDataList.screen_list.length, (index) => createCircle(index: index)),
                              )),
                          TutorialBottomButtons(
                            currentIndex: currentOnBoardingScreenIndex,
                            dataLength: TutorialDataList.screen_list.length,
                            controller: _controller,
                          )
                        ],
                      ))
                ],
              ),
            )
          ]),
        )));
  }
}

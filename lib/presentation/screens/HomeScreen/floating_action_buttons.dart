import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import '../../../business_logic/cubits/FloatingActionButtonCubit.dart';
import '../../tab_item.dart';

class MyFloatingActionButtons extends StatefulWidget {
  const MyFloatingActionButtons({Key? key}) : super(key: key);

  @override
  State<MyFloatingActionButtons> createState() => _MyFloatingActionButtonsState();
}

class _MyFloatingActionButtonsState extends State<MyFloatingActionButtons> {
  @override
  Widget build(BuildContext context) {
    final FloatingActionButtonCubit _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return BlocBuilder<FloatingActionButtonCubit, bool>(
              bloc: _homeScreen,
              builder: (_, trig) {
                if ((_homeScreen.currentTab == TabItem.feed) &&
                    (_homeScreen.currentScreen[TabItem.feed] == ScreenItem.feedScreen)) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 0.0),
                    child: FloatingActionButton.small(
                      child: const Icon(Icons.add),
                      heroTag: "btn1",
                      tooltip: "Feed Ekle",
                      backgroundColor: Color(0xFF0353EF),
                      onPressed: () {
                        _homeScreen.navigatorKeys[TabItem.feed]!.currentState!.pushNamed('/addFeed');
                      },
                    ),
                  );
                } else if (_homeScreen.currentTab == TabItem.notifications &&
                    _homeScreen.currentScreen[TabItem.notifications] == ScreenItem.notificationScreen) {
                  /*
                return Container(
                  height: 30,
                  child: FittedBox(
                    child: FloatingActionButton.extended(
                      onPressed: () {},
                      backgroundColor: Color(0xFF0353EF),
                      extendedPadding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      extendedIconLabelSpacing: 0,
                      label: Text(
                        "Tümünü Sil",
                        style: GoogleFonts.rubik(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ),
                );
                 */
                  return const SizedBox.shrink();
                } else {
                  return const SizedBox.shrink();
                }
              });
        });
  }
}

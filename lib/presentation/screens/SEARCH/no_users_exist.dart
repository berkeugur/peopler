import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/core/constants/enums/screen_item_enum.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../business_logic/cubits/FloatingActionButtonCubit.dart';
import '../../../others/classes/dark_light_mode_controller.dart';
import '../../../others/locator.dart';

import 'city_nearby_buttons.dart';

class NoUsersExistInNearby extends StatefulWidget {
  const NoUsersExistInNearby({Key? key}) : super(key: key);

  @override
  _NoUsersExistInNearbyState createState() => _NoUsersExistInNearbyState();
}

class _NoUsersExistInNearbyState extends State<NoUsersExistInNearby> {
  final Mode _mode = locator<Mode>();
  late final FloatingActionButtonCubit _homeScreen;

  @override
  void initState() {
    _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CityNearbyButtons _cityNearbyButtons = Provider.of<CityNearbyButtons>(context);
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Etrafında Kimse Yok",
                    textScaleFactor: 1,
                    style: GoogleFonts.rubik(fontSize: 24, fontWeight: FontWeight.w800, color: const Color(0xFF0353EF)),
                  ),
                  Center(
                    child: Text(
                      """Aynı ortamı paylaştığınız peopler kullanıcısı yok. Topluluğumuzu büyütmek için çalışmaya devam ediyoruz.""",
                      textScaleFactor: 1,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rubik(fontSize: 18, fontWeight: FontWeight.normal, color: _mode.blackAndWhiteConversion()),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () {
                          _cityNearbyButtons.isNearby = false;
                          _homeScreen.currentScreen = {_homeScreen.currentTab: ScreenItem.searchCityScreen};
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          margin: const EdgeInsets.only(bottom: 10, top: 10),
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(width: 1, color: const Color(0xFF0353EF)),
                            color: Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              "Şehrimi Keşfet",
                              textScaleFactor: 1,
                              style: GoogleFonts.rubik(color: const Color(0xFF0353EF), fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () async {
                          final box = context.findRenderObject() as RenderBox?;
                          await Share.share("peopler.app",
                              subject: "Yakınındaki insanları keşfet ve kaydet. Harika insanlardan oluşan peopler topluluğuna katıl!",
                              sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
                        },
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(width: 1, color: const Color(0xFF0353EF)),
                            color: Colors.transparent,
                          ),
                          child: Center(
                            child: Text(
                              "Çevrenle Paylaş",
                              textScaleFactor: 1,
                              style: GoogleFonts.rubik(color: const Color(0xFF0353EF), fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import '../../../../business_logic/blocs/UserBloc/bloc.dart';
import '../../../../core/constants/navigation/navigation_constants.dart';
import '../../../../core/system_ui_service.dart';
import '../../../../data/repository/location_repository.dart';
import '../../../../others/locator.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
    final Timer timer = Timer.periodic(const Duration(seconds: 10), (Timer t) => _userBloc.add(waitForVerificationEvent()));

    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return BlocListener<UserBloc, UserState>(
            bloc: _userBloc,
            listener: (context, UserState state) async {
              if (state is SignedInState) {
                timer.cancel();
                final LocationRepository _locationRepository = locator<LocationRepository>();
                LocationPermission _permission = await _locationRepository.checkPermissions();
                if (_permission == LocationPermission.always) {
                  /// Set theme mode before Home Screen
                  SystemUIService().setSystemUIforThemeMode();

                  Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.HOME_SCREEN, (Route<dynamic> route) => false);
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.BEG_FOR_PERMISSION_SCREEN, (Route<dynamic> route) => false);
                }
              }
            },
            child: SafeArea(
              child: Scaffold(
                backgroundColor: const Color(0xFFFFFFFF),
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: screenWidth / 5 * 5,
                      color: const Color(0xFF0353EF),
                      height: 5,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Mail kutunu",
                            textScaleFactor: 1,
                            style: PeoplerTextStyle.normal.copyWith(
                                color: const Color(0xFF0353EF),
                                fontSize: screenWidth < 360 || screenHeight < 480 ? 36 : 48,
                                fontWeight: FontWeight.w300),
                          ),
                          Text(
                            "kontrol et!",
                            textScaleFactor: 1,
                            style: PeoplerTextStyle.normal.copyWith(
                                color: const Color(0xFF000000),
                                fontSize: screenWidth < 360 || screenHeight < 480 ? 36 : 48,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: screenHeight < 630 ? 30 : 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                      child: Center(
                          child: Text(
                        "Mail adresine bir doğrulama bağlantısı gönderdik. Mail kutunu kontrol et ve bağlantıya tıklayarak profilini doğrula.\n\nProfilini doğruladıktan sonra uygulamaya doğrudan yönlendirileceksin.",
                        textScaleFactor: 1,
                        style: PeoplerTextStyle.normal.copyWith(color: const Color(0xFF000000), fontSize: 16, fontWeight: FontWeight.w300),
                      )),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: Text(
                        "Doğrulama kodu gelmediyse;",
                        textScaleFactor: 1,
                        style: PeoplerTextStyle.normal.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () => _userBloc.add(resendVerificationLink()),
                        child: const Card(
                            color: Color(0xFF0353EF),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'tekrar gönder',
                                textScaleFactor: 1,
                                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.white),
                              ),
                            )),
                      ),
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Center(
                      child: TextButton(
                        onPressed: () => _buildReturnToRegisterScreen(context),
                        child: Text(
                          "Kayıt Ekranına Dön",
                          textScaleFactor: 1,
                          style: PeoplerTextStyle.normal.copyWith(
                            color: const Color(0xFF0353EF),
                            fontSize: 20,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 40,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _buildReturnToRegisterScreen(context) {
    final UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                'Kayıt Ekranına Dönmek İstediğine Emin Misin?',
                textScaleFactor: 1,
              ),
              content: const Text(
                'Eğer mailini veya başka bir bilgini yanlış girdiğini düşünüyorsan en baştan kayıt olabilirsin.',
                textScaleFactor: 1,
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'vazgeç',
                    textScaleFactor: 1,
                    style: PeoplerTextStyle.normal.copyWith(color: const Color(0xFF0353EF)),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
                    await _userBloc.restartApp();
                  },
                  child: Text(
                    'Evet',
                    textScaleFactor: 1,
                    style: PeoplerTextStyle.normal.copyWith(color: const Color(0xFF0353EF)),
                  ),
                )
              ],
            ));
  }
}

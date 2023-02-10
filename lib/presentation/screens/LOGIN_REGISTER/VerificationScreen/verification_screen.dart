import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/presentation/screens/LOGIN_REGISTER/VerificationScreen/widgets/hello_title.dart';
import '../../../../business_logic/blocs/UserBloc/bloc.dart';
import '../../../../core/constants/navigation/navigation_constants.dart';
import '../../../../core/system_ui_service.dart';
import '../../../../data/repository/location_repository.dart';
import '../../../../others/locator.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late Timer _timer;
  final ValueNotifier<int> second = ValueNotifier(11);
  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (second.value == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          second.value--;
          print(second.value);
        }
      },
    );
  }

  @override
  void initState() {
    startTimer();

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
    final Timer timer = Timer.periodic(const Duration(seconds: 10), (Timer t) => _userBloc.add(waitForVerificationEvent()));
    SystemUIService.setTopBlueBottomWhite;
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
                  Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.HOME_SCREEN, (Route<dynamic> route) => false);
                } else {
                  Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.BEG_FOR_PERMISSION_SCREEN, (Route<dynamic> route) => false);
                }
              }
            },
            child: SafeArea(
              child: Scaffold(
                backgroundColor: const Color(0xFF0353EF),
                body: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              IconButton(
                                onPressed: () {
                                  _buildReturnToRegisterScreen(context);
                                },
                                icon: const Icon(
                                  Icons.arrow_back,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  size: 32,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: HelloTitle(
                                  userName: UserBloc.user?.displayName,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),
                              color: Colors.white,
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(35, 20, 35, 0),
                                  child: Column(
                                    children: [
                                      RichText(
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 3,
                                        text: TextSpan(
                                          text: "${UserBloc.user?.email} ",
                                          style: PeoplerTextStyle.normal.copyWith(
                                            color: const Color(0xFF0353EF),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: "adresine bir doğrulama bağlantısı gönderdik. Bağlantıya tıkla ve profilini onayla",
                                              style: PeoplerTextStyle.normal.copyWith(
                                                color: Colors.grey[600],
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ValueListenableBuilder(
                                    valueListenable: second,
                                    builder: (context, int value, _) {
                                      if (value == 0) {
                                        return InkWell(
                                          onTap: () {
                                            _userBloc.add(resendVerificationLink());
                                            second.value = 900;
                                            startTimer();
                                            SnackBars(context: context).simple("Dorğulama bağlantısı gönderildi.");
                                          },
                                          child: Container(
                                              height: 50,
                                              margin: const EdgeInsets.fromLTRB(40, 20, 40, 0),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF0353EF),
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        'Tekrar Gönder',
                                                        textScaleFactor: 1,
                                                        style: GoogleFonts.dmSans(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 16,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              )),
                                        );
                                      } else {
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                                          child: Text(
                                            '${value ~/ 60 == 0 ? "00" : value ~/ 60}:${(value % 60) < 10 ? "0${(value % 60)}" : (value % 60)}',
                                            textScaleFactor: 1,
                                            style: GoogleFonts.dmSans(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 24,
                                              color: const Color(0xFF0353EF),
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Bir sorun olduğunu düşünüyorsan",
                            style: GoogleFonts.dmSans(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                              fontSize: 16.0,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                print("sadasdsadsa");
                              });
                            },
                            child: Text(
                              "support@peopler.app",
                              style: GoogleFonts.dmSans(
                                color: const Color(0xFF0353EF),
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ],
                      ),
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
                    _userBloc.add(deleteUser());
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

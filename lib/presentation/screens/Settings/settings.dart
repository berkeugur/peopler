import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:peopler/presentation/screens/Settings/settings_page_functions.dart';

import '../../../others/classes/dark_light_mode_controller.dart';
import '../../../others/locator.dart';
import 'components/about_field.dart';
import 'components/change_password_setting.dart';
import 'components/ppl_name.dart';
import 'components/ppl_photo.dart';
import 'components/toggle_switches.dart';
import 'components/top_menu.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

// ignore: non_constant_identifier_names
bool is_selected_in_the_same_environment = true;
// ignore: non_constant_identifier_names
bool is_selected_in_the_same_city = false;

// ignore: non_constant_identifier_names
bool is_selected_profile_close_to_everyone = false;
// ignore: non_constant_identifier_names
bool is_selected_profile_open_to_everyone = true;

class _SettingsScreenState extends State<SettingsScreen> {
  final Mode _mode = locator<Mode>();

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ValueListenableBuilder(
          valueListenable: Mode.isEnableDarkModeNotifier,
          builder: (context, x, u) {
            return Scaffold(
              backgroundColor: _mode.homeScreenScaffoldBackgroundColor(),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  topMenu(context),
                  Expanded(
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width > 400 ? 400 : MediaQuery.of(context).size.width,
                        child: ListView(
                          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            ppl_photo(context),
                            ppl_user_name(context),
                            const SizedBox(
                              height: 30,
                            ),
                            toggleSwitches(context, setState: setState),
                            changePasswordField(context),
                            about_field(context),
                            const SizedBox(
                              height: 30,
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            SizedBox.square(dimension: 50, child: Image.asset("assets/ic_launcher.png")),
                            Text(
                              "version: ${_packageInfo.version}",
                              textScaleFactor: 1,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.rubik(
                                color: Color(0xFF0353EF),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(5),
                                onTap: () {
                                  showPlatformDialog(
                                      context: context,
                                      builder: (context) {
                                        return PlatformAlertDialog(
                                          title: Text(
                                            "Bu İşlem Geri Alınamaz!",
                                            textScaleFactor: 1,
                                            style: GoogleFonts.rubik(),
                                          ),
                                          content: Text(
                                            "Hesabınızı kalıcı olarak silmek istediğinize emin misiniz?",
                                            textScaleFactor: 1,
                                            style: GoogleFonts.rubik(),
                                          ),
                                          actions: [
                                            PlatformDialogAction(
                                              onPressed: () {
                                                op_delete_account(context);
                                              },
                                              child: Text(
                                                "Hesabı Sil",
                                                textScaleFactor: 1,
                                                style: GoogleFonts.rubik(
                                                  color: Color(0xFF0353EF),
                                                ),
                                              ),
                                            ),
                                            PlatformDialogAction(
                                              material: (_, __) => MaterialDialogActionData(),
                                              cupertino: (_, __) => CupertinoDialogActionData(),
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: Text(
                                                "Vazgeç",
                                                textScaleFactor: 1,
                                                style: GoogleFonts.rubik(
                                                  color: Color(0xFF0353EF),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      });
                                  print("tapped");
                                },
                                child: Container(
                                  padding: EdgeInsets.all(13),
                                  decoration: BoxDecoration(boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Color.fromARGB(255, 233, 233, 233).withOpacity(1),
                                      blurRadius: 0.5,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 0),
                                    ),
                                  ], color: Colors.white, borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Hesabı Sil",
                                        textScaleFactor: 1,
                                        style: GoogleFonts.rubik(color: Colors.grey[600], fontSize: 15),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

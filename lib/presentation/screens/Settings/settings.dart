import 'package:flutter/material.dart';

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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                      changePasswordField(),
                      about_field(context),
                      const SizedBox(
                        height: 30,
                      ),
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
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:peopler/business_logic/blocs/OtherUserBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/components/CustomWidgets/PROFILE/hobby_field.dart';
import 'package:peopler/components/FlutterWidgets/app_bars.dart';
import 'package:peopler/components/FlutterWidgets/dialogs.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/enums/send_req_button_status_enum.dart';
import 'package:peopler/core/constants/reloader/reload.dart';
import 'package:peopler/data/model/activity.dart';
import 'package:peopler/data/model/report.dart';
import 'package:peopler/data/model/user.dart';
import 'package:peopler/others/functions/guest_login_alert_dialog.dart';
import 'package:peopler/components/FlutterWidgets/drawer.dart';
import 'package:peopler/presentation/screen_services/report_service.dart';
import 'package:peopler/presentation/screens/PROFILE/MyProfile/ProfileScreen/profile_screen_components.dart';
import 'package:peopler/presentation/screens/PROFILE/OthersProfile/functions.dart';
import 'package:peopler/presentation/screens/PROFILE/OthersProfile/profile/profile_screen_components.dart';
import 'package:peopler/presentation/screens/PROFILE/OthersProfile/profile/report_bottom_sheet.dart';
import '../../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../../others/locator.dart';
import '../../../../../others/strings.dart';

Widget titles4OtherProfiles(MyUser otherUser) {
  if (otherUser.company == "" && otherUser.currentJobName != "") {
    return Text(otherUser.currentJobName, textScaleFactor: 1, style: PeoplerTextStyle.normal.copyWith(color: Mode().blackAndWhiteConversion()));
  } else if (otherUser.company != "" && otherUser.currentJobName != "") {
    return Text(otherUser.company + " şirketinde " + otherUser.currentJobName,
        textScaleFactor: 1, style: PeoplerTextStyle.normal.copyWith(color: Mode().blackAndWhiteConversion()));
  } else if (otherUser.company != "" && otherUser.currentJobName == "") {
    return Text(otherUser.company + " şirketinde çalışıyor.",
        textScaleFactor: 1, style: PeoplerTextStyle.normal.copyWith(color: Mode().blackAndWhiteConversion()));
  } else {
    return const SizedBox.shrink();
  }
}

class OthersProfileScreen extends StatefulWidget {
  final userID;
  final SendRequestButtonStatus status;

  const OthersProfileScreen({Key? key, required this.userID, required this.status}) : super(key: key);

  @override
  _OthersProfileScreenState createState() => _OthersProfileScreenState();
}

class _OthersProfileScreenState extends State<OthersProfileScreen> with TickerProviderStateMixin {
  late final OtherUserBloc _otherUserBloc;
  final Mode _mode = locator<Mode>();
  late final AnimationController _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _otherUserBloc = OtherUserBloc();
    _otherUserBloc.add(GetInitialDataEvent(userID: widget.userID, status: widget.status));
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiValueListenableBuilder(
        valueListenables: [
          setTheme,
          Reloader.otherUserProfileReload,
        ],
        builder: (context, x, y) {
          return WillPopScope(
            onWillPop: () => popOtherUserScreen(context),
            child: BlocProvider<OtherUserBloc>(
              create: (context) => _otherUserBloc,
              child: Builder(builder: (BuildContext context) {
                return ScaffoldMessenger(
                  child: Scaffold(
                    appBar: PeoplerAppBars(context: context).OTHER_PROFILE(
                      function: () async {
                        await ReportOrBlockUser(context: context, otherUserBloc: _otherUserBloc, controller: _controller);
                      },
                    ),
                    backgroundColor: Mode().homeScreenScaffoldBackgroundColor(),
                    body: _buildBody(),
                  ),
                );
              }),
            ),
          );
        });
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: BlocBuilder<OtherUserBloc, OtherUserState>(
        bloc: _otherUserBloc,
        builder: (context, state) {
          if (state is InitialOtherUserState) {
            return _initialOtherUserStateWidget(context);
          } else if (state is OtherUserLoadedState) {
            return _userLoadedStateWidget(context, state.otherUser, state.mutualConnectionUserIDs, state.myActivities, state.status);
          } else {
            return const Text("Impossible");
          }
        },
      ),
    );
  }

  Column _userLoadedStateWidget(
      context, MyUser otherUser, List<String> mutualConnectionUserIDs, List<MyActivity> myActivities, SendRequestButtonStatus status) {
    ProfileScreenComponentsOthersProfile _profileScreenComponents =
        ProfileScreenComponentsOthersProfile(profileData: otherUser, mutualConnectionUserIDs: mutualConnectionUserIDs, myActivities: myActivities);

    return Column(
      children: [
        ProfileScreenComponentsMyProfile().photos(context, otherUser.photosURL, otherUser.profileURL),
        _profileScreenComponents.nameField(status),
        const SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 40,
              child: Text(
                otherUser.schoolName,
                textScaleFactor: 1,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                textAlign: TextAlign.center,
                softWrap: false,
                style: PeoplerTextStyle.normal.copyWith(
                  fontSize: 14,
                  color: _mode.blackAndWhiteConversion(),
                ),
              ),
            ),
            //_profileScreenComponents.schoolName(context),
            //const Text(" / "),
            //_profileScreenComponents.currentJob(context),
          ],
        ),
        otherUser.schoolName != "" && otherUser.currentJobName != "" ? const SizedBox(height: 5) : const SizedBox.shrink(),

        titles4OtherProfiles(otherUser),
        //_profileScreenComponents.companyName(),

        otherUser.company != "" ? const SizedBox(height: 5) : const SizedBox.shrink(),

        _profileScreenComponents.mutualFriends(context),
        mutualConnectionUserIDs.isNotEmpty ? const SizedBox(height: 5) : const SizedBox.shrink(),
        _profileScreenComponents.sendRequestButton(context, status, otherUser),
        const SizedBox(height: 10),
        _profileScreenComponents.locationText(),
        const SizedBox(height: 15),
        ProfileScreenComponentsMyProfile().biographyField(context, otherUser.biography),
        const SizedBox(height: 10),

        ///123321 MyUser Profile kısmında UserBloc.myActivites işe yarıyor
        ///ancak Others Userda OtherUserBloc().myActivities late hatası veriyor
        ProfileScreenComponentsOthersProfile(
          profileData: _otherUserBloc.otherUser!,
          mutualConnectionUserIDs: _otherUserBloc.mutualConnectionUserIDs,
          myActivities: _otherUserBloc.activities,
        ).activityList(context),
        const SizedBox(height: 10),
        ProfileHobbyField(profileData: _otherUserBloc.otherUser!),
        //_profileScreenComponents.experiencesList(context),
      ],
    );
  }

  Column _initialOtherUserStateWidget(context) {
    return Column(children: [
      SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const Center(
            child: CircularProgressIndicator(),
          )),
    ]);
  }
}

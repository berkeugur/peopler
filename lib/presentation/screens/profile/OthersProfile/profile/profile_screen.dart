import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/OtherUserBloc/bloc.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/data/model/activity.dart';
import 'package:peopler/data/model/user.dart';
import 'package:peopler/presentation/screens/profile/OthersProfile/functions.dart';
import 'package:peopler/presentation/screens/profile/OthersProfile/profile/profile_screen_components.dart';
import '../../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../../others/locator.dart';
import '../../../../../others/strings.dart';

Widget titles4OtherProfiles(MyUser otherUser) {
  if (otherUser.company == "" && otherUser.currentJobName != "") {
    return Text(otherUser.currentJobName,
        textScaleFactor: 1, style: GoogleFonts.rubik(color: Mode().blackAndWhiteConversion()));
  } else if (otherUser.company != "" && otherUser.currentJobName != "") {
    return Text(otherUser.company + " şirketinde " + otherUser.currentJobName,
        textScaleFactor: 1, style: GoogleFonts.rubik(color: Mode().blackAndWhiteConversion()));
  } else if (otherUser.company != "" && otherUser.currentJobName == "") {
    return Text(otherUser.company + " şirketinde çalışıyor.",
        textScaleFactor: 1, style: GoogleFonts.rubik(color: Mode().blackAndWhiteConversion()));
  } else {
    return SizedBox.shrink();
  }
}

class OthersProfileScreen extends StatefulWidget {
  final userID;
  final SendRequestButtonStatus status;

  const OthersProfileScreen({Key? key, required this.userID, required this.status}) : super(key: key);

  @override
  _OthersProfileScreenState createState() => _OthersProfileScreenState();
}

class _OthersProfileScreenState extends State<OthersProfileScreen> {
  late final OtherUserBloc _otherUserBloc;
  final Mode _mode = locator<Mode>();

  @override
  void initState() {
    _otherUserBloc = OtherUserBloc();
    _otherUserBloc.add(GetInitialDataEvent(userID: widget.userID, status: widget.status));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return WillPopScope(
            onWillPop: () => popOtherUserScreen(context),
            child: BlocProvider<OtherUserBloc>(
              create: (context) => _otherUserBloc,
              child: Builder(
                builder: (BuildContext context) {
                  return Scaffold(
                    backgroundColor: Mode().homeScreenScaffoldBackgroundColor(),
                    body: SafeArea(
                      child: _buildBody(widget.status),
                    ),
                  );
                },
              ),
            ),
          );
        });
  }

  Widget _buildBody(SendRequestButtonStatus status) {
    return Container(
      child: SingleChildScrollView(
        child: BlocBuilder<OtherUserBloc, OtherUserState>(
          bloc: _otherUserBloc,
          builder: (context, state) {
            if (state is InitialOtherUserState) {
              return _initialOtherUserStateWidget(context);
            } else if (state is OtherUserLoadedState) {
              return _userLoadedStateWidget(
                  context, state.otherUser, state.mutualConnectionUserIDs, state.myActivities, state.status);
            } else {
              return const Text("Impossible");
            }
          },
        ),
      ),
    );
  }

  Column _userLoadedStateWidget(context, MyUser otherUser, List<String> mutualConnectionUserIDs,
      List<MyActivity> myActivities, SendRequestButtonStatus status) {
    ProfileScreenComponentsOthersProfile _profileScreenComponents = ProfileScreenComponentsOthersProfile(
        profileData: otherUser, mutualConnectionUserIDs: mutualConnectionUserIDs, myActivities: myActivities);

    return Column(
      children: [
        header(context),
        _profileScreenComponents.photos(context),
        _profileScreenComponents.nameField(),
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
                style: GoogleFonts.rubik(
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
        otherUser.schoolName != "" && otherUser.currentJobName != ""
            ? const SizedBox(height: 5)
            : const SizedBox.shrink(),

        titles4OtherProfiles(otherUser),
        //_profileScreenComponents.companyName(),

        otherUser.company != "" ? const SizedBox(height: 5) : const SizedBox.shrink(),

        _profileScreenComponents.mutualFriends(context),
        mutualConnectionUserIDs.isNotEmpty ? const SizedBox(height: 5) : const SizedBox.shrink(),
        _profileScreenComponents.sendRequestButton(context, status, otherUser),
        const SizedBox(height: 10),
        _profileScreenComponents.locationText(),
        const SizedBox(height: 15),
        _profileScreenComponents.biographyField(context),
        const SizedBox(height: 10),
        _profileScreenComponents.activityList(context),
        const SizedBox(height: 10),
        _profileScreenComponents.experiencesList(context),
      ],
    );
  }

  Column _initialOtherUserStateWidget(context) {
    return Column(children: [
      header(context),
      SizedBox(
          height: MediaQuery.of(context).size.height,
          child: const Center(
            child: CircularProgressIndicator(),
          )),
    ]);
  }

  Widget header(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _mode.bottomMenuBackground(),
      ),
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => popOtherUserScreen(context),
            child: SvgPicture.asset(
              txt.backArrowSvgTXT,
              width: 25,
              height: 25,
              color: _mode.homeScreenIconsColor(),
              fit: BoxFit.contain,
            ),
          ),
          Text(
            txt.peoplerTXT,
            textScaleFactor: 1,
            style: GoogleFonts.spartan(color: _mode.homeScreenTitleColor(), fontWeight: FontWeight.w800, fontSize: 24),
          ),
          const SizedBox.square(
            dimension: 25,
          )
        ],
      ),
    );
  }
}

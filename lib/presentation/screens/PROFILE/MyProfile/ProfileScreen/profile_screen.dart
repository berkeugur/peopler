import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/components/CustomWidgets/PROFILE/hobby_field.dart';
import 'package:peopler/components/FlutterWidgets/app_bars.dart';
import 'package:peopler/data/model/user.dart';
import 'package:peopler/others/widgets/drawer.dart';
import 'package:peopler/presentation/screens/PROFILE_EDIT/Home/profile_edit_home.dart';
import 'package:peopler/presentation/screens/FEEDS/FeedScreen/feed_functions.dart';
import 'package:peopler/presentation/screens/PROFILE/MyProfile/ProfileScreen/profile_screen_components.dart';
import '../../../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../../../others/locator.dart';
import '../../../../../../others/strings.dart';
import '../../../../../business_logic/blocs/UserBloc/user_bloc.dart';

//tam bir profil için olması gerekenler
//En az 1 tane deneyim eklenmeli.
//En az 1 tane bağlantınız olsun
//En az 2 tane fotoğraf paylaşın.
//En az 1 tane feed paylaşın.
//Mesleğinizi ekleyin

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

ValueNotifier<bool> setStateProfileScreen = ValueNotifier(false);

class _ProfileScreenState extends State<ProfileScreen> {
  final Mode _mode = locator<Mode>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return Scaffold(
            appBar: PeoplerAppBars(context: context).FEEDandPROFILE(
                titleFunction: () {},
                leadingFunction: () {
                  op_settings_icon(context);
                }),
            backgroundColor: Mode().homeScreenScaffoldBackgroundColor(),

            //profile edit ekranındaki değişiklikleri uygulamak için kaydet butonuna basıldığında.
            //profil ekranını set state etmek amacıyla valuelistenable builder koyup kaydete tıkladığında
            // true yapıp future delayed ile biraz bekledikten sonra false yapıyorum ve böylece
            //valuelistenable builder tetiklenmiş oluyor ilerde burayı daha iyi bir yöntemle
            //değiştirebiliriz.

            body: ValueListenableBuilder(
                valueListenable: setStateProfileScreen,
                builder: (context, xbool, xwidget) {
                  return SafeArea(
                    child: _buildBody(),
                  );
                }),
          );
        });
  }

  Widget _buildBody() {
    final MyUser profileData = UserBloc.user!;
    ProfileScreenComponentsMyProfile _profileScreenComponents = ProfileScreenComponentsMyProfile();
    return SingleChildScrollView(
      child: Column(
        children: [
          //header(context),

          _profileScreenComponents.photos(context, profileData.photosURL, profileData.profileURL),
          _profileScreenComponents.nameField(),

          SizedBox(
            height: UserBloc.user!.schoolName != "" ? 5 : 0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width - 40,
                child: Text(
                  UserBloc.user!.schoolName,
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
              /*_profileScreenComponents.schoolName(context),
              UserBloc.user!.company.isEmpty || UserBloc.user!.currentJobName.isEmpty
                  ? SizedBox.shrink()
                  : const Text(" / "),
              _profileScreenComponents.currentJob(context),
              */
            ],
          ),
          UserBloc.user!.schoolName != "" && UserBloc.user!.currentJobName != "" ? const SizedBox(height: 5) : const SizedBox.shrink(),
//(UserBloc.user!.schoolName.isEmpty || UserBloc.user!.currentJobName.isEmpty ? "" : " / ") +UserBloc.user!.currentJobName
          _titles(),
          //_profileScreenComponents.companyName(),
          UserBloc.user!.company != "" ? const SizedBox(height: 0) : const SizedBox.shrink(),
          _profileScreenComponents.connections(context),
          UserBloc.user!.connectionUserIDs.isNotEmpty ? const SizedBox(height: 5) : const SizedBox.shrink(),
          _profileScreenComponents.profileEditButton(context),
          const SizedBox(height: 10),
          _profileScreenComponents.locationText(),
          const SizedBox(height: 15),
          _profileScreenComponents.biographyField(context, profileData.biography),
          const SizedBox(height: 15),
          _profileScreenComponents.activityList(context, UserBloc.myActivities),
          const SizedBox(height: 10),
          ProfileHobbyField(profileData: profileData),
          const SizedBox(height: 30),
          //_profileScreenComponents.experiencesList(context),
        ],
      ),
    );
  }

  Widget _titles() {
    if (UserBloc.user!.company == "" && UserBloc.user!.currentJobName != "") {
      return Text(UserBloc.user!.currentJobName, textScaleFactor: 1, style: GoogleFonts.rubik(color: Mode().blackAndWhiteConversion()));
    } else if (UserBloc.user!.company != "" && UserBloc.user!.currentJobName != "") {
      return Text(UserBloc.user!.company + " şirketinde " + UserBloc.user!.currentJobName,
          textScaleFactor: 1, style: GoogleFonts.rubik(color: Mode().blackAndWhiteConversion()));
    } else if (UserBloc.user!.company != "" && UserBloc.user!.currentJobName == "") {
      return Text(UserBloc.user!.company + " şirketinde çalışıyor.", textScaleFactor: 1, style: GoogleFonts.rubik(color: Mode().blackAndWhiteConversion()));
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget header(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _mode.bottomMenuBackground(),
      ),
      padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const DrawerMenuWidget(),
          Text(
            "peopler",
            textScaleFactor: 1,
            style: GoogleFonts.spartan(color: _mode.homeScreenTitleColor(), fontWeight: FontWeight.w900, fontSize: 32),
          ),
          const SizedBox.square(
            dimension: 25,
          ),
          /*
          InkWell(
            onTap: () => op_message_icon(context),
            child: SvgPicture.asset(
              "assets/images/svg_icons/message_icon.svg",
              width: 25,
              height: 25,
              color: _mode.homeScreenIconsColor(),
              fit: BoxFit.contain,
            ),
          ),
          */
        ],
      ),
    );
  }
}

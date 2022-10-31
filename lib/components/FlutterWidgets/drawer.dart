import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/length/max_length_constants.dart';
import 'package:peopler/core/system_ui_service.dart';
import 'package:peopler/data/model/user.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/others/functions/guest_login_alert_dialog.dart';
import 'package:peopler/presentation/screens/FEEDS/FeedScreen/feed_functions.dart';
import 'package:peopler/presentation/screens/FEEDS/FeedScreen/feed_screen.dart';
import 'package:peopler/presentation/screens/HOME/home_screen.dart';
import 'package:peopler/presentation/screens/SUBSCRIPTIONS/subscriptions_functions.dart';
import '../../presentation/screens/PROFILE/MyProfile/ProfileScreen/profile_screen.dart';
import '../../presentation/screens/SETTINGS/settings.dart';

class CircularImage extends StatelessWidget {
  final double _width, _height;
  final ImageProvider image;

  CircularImage(this.image, {double width = 40, double height = 40})
      : _width = width,
        _height = height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _width,
      height: _height,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: image),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black45,
            )
          ]),
    );
  }
}

class DrawerMenuWidget extends StatelessWidget {
  const DrawerMenuWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () => ZoomDrawer.of(context)!.toggle(),
      onTap: () => op_settings_icon(context),
      child: SvgPicture.asset(
        "assets/images/svg_icons/sort.svg",
        color: Mode().disabledBottomMenuItemAssetColor(),
        fit: BoxFit.contain,
      ),
    );
  }
}

class MenuPage extends StatefulWidget {
  const MenuPage({Key? key}) : super(key: key);

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    final _themeCubit = BlocProvider.of<ThemeCubit>(context);
    return Scaffold(
      backgroundColor: const Color(0xFF0353EF),
      body: Padding(
        padding: EdgeInsets.only(
            top: _height * 0.1, bottom: _height * 0.1, left: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                profilePhoto(context),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  UserBloc.user?.displayName ?? "null display name",
                  textScaleFactor: 1,
                  style: PeoplerTextStyle.normal.copyWith(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 15,
                ),
                //theme_change_buttons(_themeCubit),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Divider(
                    color: Colors.white,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () async {
                      await FirebaseFirestore.instance
                          .collection("eventsbutton")
                          .doc()
                          .set({
                        "createdAt": Timestamp.now(),
                        "cretedMonth": Timestamp.now().toDate().month,
                        "cretedYear": Timestamp.now().toDate().year,
                        "cretedDay": Timestamp.now().toDate().day,
                        "isNeedEmailNotification": false,
                        "createdFromUserID": UserBloc.user?.userID,
                      });
                      await showDialog(
                        context: context,
                        builder: (contextSD) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(32.0))),
                          contentPadding: EdgeInsets.only(
                              top: 20.0, bottom: 5, left: 25, right: 25),
                          content: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Etkinlikler Bölümü Deneme Aşamasındadır.",
                                textAlign: TextAlign.center,
                                style: PeoplerTextStyle.normal.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(),
                              const SizedBox(
                                height: 10,
                              ),
                              InkWell(
                                onTap: () async {
                                  await FirebaseFirestore.instance
                                      .collection("eventsbutton")
                                      .doc()
                                      .set({
                                    "createdAt": Timestamp.now(),
                                    "cretedMonth":
                                        Timestamp.now().toDate().month,
                                    "cretedYear": Timestamp.now().toDate().year,
                                    "cretedDay": Timestamp.now().toDate().day,
                                    "createdFromUserID": UserBloc.user?.userID,
                                    "isNeedEmailNotification": true,
                                    "createdFromUserEmail":
                                        UserBloc.user?.email,
                                  }).then((value) {
                                    Navigator.of(context).pop();
                                  });
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(999),
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    "E-Posta İle Haber Ver",
                                    style: PeoplerTextStyle.normal.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(
                                  "KAPAT",
                                  style: PeoplerTextStyle.normal.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                            size: 25,
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Etkinlikler",
                            textScaleFactor: 1,
                            style: PeoplerTextStyle.normal.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  //MenuItems(context: context, svgiconpath: "assets/images/svg_icons/home.svg", itemtext: "Ana Sayfa"),
                  //MenuItems(context: context, svgiconpath: "assets/images/svg_icons/notification.svg", itemtext: "Bildirimler"),
                  //MenuItems(context: context, svgiconpath: "assets/images/svg_icons/search.svg", itemtext: "Keşfet"),
                  //MenuItems(context: context, svgiconpath: "assets/images/svg_icons/message_icon.svg", itemtext: "Mesajlar"),
                  //MenuItems(context: context, svgiconpath: "assets/images/svg_icons/profile_icon.svg", itemtext: "Profil"),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Divider(
                  color: Colors.white,
                ),
                MenuItems(
                  context: context,
                  svgiconpath: "assets/images/svg_icons/settings.svg",
                  itemtext: "Ayarlar",
                  function: () {
                    UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
                    if (UserBloc.user != null) {
                      ZoomDrawer.of(context)!.toggle();
                      _userBloc.mainKey.currentState?.push(
                        MaterialPageRoute(
                            builder: (context) => const SettingsScreen()),
                      );
                    } else {
                      GuestAlert.dialog(context);
                      /*
    _userBloc.mainKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => const GuestLoginScreen(),
      ),
    );*/
                    }
                  },
                ),
                MenuItems(
                    context: context,
                    itemtext: "Destek",
                    icon: Icons.support_agent,
                    function: () {
                      TextEditingController _controller =
                          TextEditingController();
                      showDialog(
                        context: context,
                        builder: (_ctx) {
                          return AlertDialog(
                            title: const Text("Destek"),
                            content: Container(
                              alignment: Alignment.center,
                              height: 50,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0353EF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: TextFormField(
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context).unfocus();
                                },
                                autofocus: true,
                                keyboardType: TextInputType.text,
                                cursorColor: Colors.white,
                                maxLength: MaxLengthConstants.SUGGEST,
                                controller: _controller,
                                textInputAction: TextInputAction.send,
                                autocorrect: true,
                                decoration: const InputDecoration(
                                  counterText: "",
                                  contentPadding:
                                      EdgeInsets.fromLTRB(0, 13, 0, 10),
                                  hintMaxLines: 1,
                                  border: InputBorder.none,
                                  hintText: 'Mesajınız',
                                  hintStyle: TextStyle(
                                      color: Color(0xFF9ABAF9), fontSize: 16),
                                ),
                                style: const TextStyle(
                                  color: Color(0xFFFFFFFF),
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: const Text("iptal"),
                              ),
                              TextButton(
                                onPressed: () async {
                                  if (_controller.text.isNotEmpty) {
                                    await FirebaseFirestore.instance
                                        .collection("supports")
                                        .doc()
                                        .set({
                                      "message": _controller.text,
                                      "fromUserID": UserBloc.user?.userID,
                                      "fromUserEmail": UserBloc.user?.email,
                                      "createdAt": Timestamp.now(),
                                    }).then((value) {
                                      Navigator.of(context).pop();
                                      showDialog(
                                        context: context,
                                        builder: (contextSD) => AlertDialog(
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(32.0))),
                                          contentPadding: EdgeInsets.only(
                                              top: 20.0,
                                              bottom: 5,
                                              left: 25,
                                              right: 25),
                                          content: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "En kısa sürede e-posta yoluyla iletişime geçeceğiz",
                                                textAlign: TextAlign.center,
                                                style: PeoplerTextStyle.normal
                                                    .copyWith(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Divider(),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            999),
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  ),
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 30,
                                                    vertical: 10,
                                                  ),
                                                  child: Text(
                                                    "TAMAM",
                                                    style: PeoplerTextStyle
                                                        .normal
                                                        .copyWith(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 15,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                                  } else {
                                    SnackBars(context: context)
                                        .simple("boş bırakmayınız");
                                  }
                                },
                                child: const Text("Gönder"),
                              ),
                            ],
                          );
                        },
                      );
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }

  Stack profilePhoto(BuildContext context) {
    final MyUser? profileData = UserBloc.user;
    final _size = MediaQuery.of(context).size;
    final _screenWidth = _size.width;
    final _photoSize = _screenWidth / 4.2;
    return Stack(
      children: [
        Container(
          height: _photoSize,
          width: _photoSize,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(width: 5, color: Colors.white)),
          child: const CircleAvatar(
            backgroundColor: Color(0xFF0353EF),
            child: Text(
              "ppl",
              textScaleFactor: 1,
            ),
          ),
        ),
        Container(
          height: _photoSize,
          width: _photoSize,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(width: 3, color: Colors.white)),
          child: //_userBloc != null ?
              CachedNetworkImage(
            imageUrl: profileData!.profileURL,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: CircularProgressIndicator(
                        value: downloadProgress.progress)),
            errorWidget: (context, url, error) => const Icon(Icons.error),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ignore: non_constant_identifier_names
  Row theme_change_buttons(ThemeCubit _themeCubit) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            if (Mode.isEnableDarkMode) {
              _themeCubit.openLightMode();
            } else {
              _themeCubit.openDarkMode();
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Mode.isEnableDarkMode == false
                  ? Colors.white
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/images/svg_icons/light_mode.svg",
                    width: 15,
                    height: 15,
                    color: Mode.isEnableDarkMode == false
                        ? const Color(0xFF0353EF)
                        : Colors.white,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Aydınlık",
                    textScaleFactor: 1,
                    style: PeoplerTextStyle.normal.copyWith(
                      color: Mode.isEnableDarkMode == false
                          ? const Color(0xFF0353EF)
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.045,
        ),
        InkWell(
          onTap: () => _themeCubit.openDarkMode(),
          child: Container(
            decoration: BoxDecoration(
              color: Mode.isEnableDarkMode == true
                  ? Colors.white
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
              child: Row(
                children: [
                  SvgPicture.asset(
                    "assets/images/svg_icons/dark_mode.svg",
                    width: 15,
                    height: 15,
                    color: Mode.isEnableDarkMode == true
                        ? const Color(0xFF0353EF)
                        : Colors.white,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Karanlık",
                    textScaleFactor: 1,
                    style: PeoplerTextStyle.normal.copyWith(
                      color: Mode.isEnableDarkMode == true
                          ? const Color(0xFF0353EF)
                          : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget MenuItems(
      {required BuildContext context,
      String? svgiconpath,
      required String itemtext,
      IconData? icon,
      void Function()? function}) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: function ?? printf("null menu items function"),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon != null
                  ? Icon(
                      icon,
                      size: 25,
                      color: Colors.white,
                    )
                  : svgiconpath != null
                      ? SvgPicture.asset(
                          svgiconpath,
                          width: 25,
                          color: Colors.white,
                          fit: BoxFit.contain,
                        )
                      : const SizedBox.square(
                          dimension: 25,
                        ),
              const SizedBox(
                width: 30,
              ),
              Text(
                itemtext,
                textScaleFactor: 1,
                textAlign: TextAlign.left,
                style: PeoplerTextStyle.normal.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerHomePage extends StatefulWidget {
  //final GlobalKey<FeedScreenState> feedListKey;
  const DrawerHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<DrawerHomePage> createState() => _DrawerHomePageState();
}

class _DrawerHomePageState extends State<DrawerHomePage> {
  ZoomDrawerController controller = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, _, __) {
          return ZoomDrawer(
            controller: controller,
            shadowLayer1Color:
                Mode().homeScreenScaffoldBackgroundColor()!.withOpacity(0.25),
            shadowLayer2Color:
                Mode().homeScreenScaffoldBackgroundColor()!.withOpacity(0.70),
            showShadow: true,
            mainScreenTapClose: true,
            borderRadius: 24.0,
            angle: 0,
            style: DrawerStyle.defaultStyle,
            // showShadow: true,
            openCurve: Curves.fastOutSlowIn,
            slideWidth: MediaQuery.of(context).size.width * 0.70,
            duration: const Duration(milliseconds: 500),
            // angle: 0.0,
            menuBackgroundColor: const Color(0xFF0353EF),

            mainScreen: const HomeScreen(),
            menuScreen: const MenuPage(),
          );
        });
  }
}

/*
class DrawerProfilePage extends StatefulWidget {
  const DrawerProfilePage({Key? key}) : super(key: key);

  @override
  State<DrawerProfilePage> createState() => _DrawerProfilePageState();
}

class _DrawerProfilePageState extends State<DrawerProfilePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      shadowLayer1Color: Mode().homeScreenScaffoldBackgroundColor()!.withOpacity(0.25),
      shadowLayer2Color: Mode().homeScreenScaffoldBackgroundColor()!.withOpacity(0.70),
      showShadow: true,
      mainScreenTapClose: true,
      borderRadius: 24.0,
      angle: 0,
      style: DrawerStyle.defaultStyle,
      // showShadow: true,
      openCurve: Curves.fastOutSlowIn,
      slideWidth: MediaQuery.of(context).size.width * 0.70,
      duration: const Duration(milliseconds: 500),
      // angle: 0.0,
      menuBackgroundColor: const Color(0xFF0353EF),

      mainScreen: const ProfileScreen(),
      menuScreen: const MenuPage(),
    );
  }
}
 */

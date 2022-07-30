import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_zoom_drawer/config.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/presentation/screens/feeds/FeedScreen/feed_functions.dart';
import 'package:peopler/presentation/screens/feeds/FeedScreen/feed_screen.dart';
import 'package:peopler/presentation/screens/profile/MyProfile/ProfileScreen/profile_screen_components.dart';
import 'package:flutter/material.dart';

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
      decoration: BoxDecoration(shape: BoxShape.circle, image: DecorationImage(image: image), boxShadow: [
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
    return IconButton(
        onPressed: () {
          ZoomDrawer.of(context)!.toggle();
          // Navigator.of(context).push(MaterialPageRoute(builder: ((context) => Zoom())));
        },
        icon: Icon(
          Icons.menu,
          size: 32,
          color: Color(0xFF0353EF),
        ));
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
    return Container(
      child: Scaffold(
        backgroundColor: Color(0xFF0353EF),
        body: Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 40, left: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ProfileScreenComponentsMyProfile().profilePhoto(context),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    UserBloc.user?.displayName ?? "null display name",
                    textScaleFactor: 1,
                    style: GoogleFonts.rubik(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MenuItems(context: context, svgiconpath: "assets/images/svg_icons/home.svg", itemtext: "Ana Sayfa"),
                  MenuItems(context: context, svgiconpath: "assets/images/svg_icons/notification.svg", itemtext: "Bildirimler"),
                  MenuItems(context: context, svgiconpath: "assets/images/svg_icons/search.svg", itemtext: "Keşfet"),
                  MenuItems(context: context, svgiconpath: "assets/images/svg_icons/message_icon.svg", itemtext: "Mesajlar"),
                  MenuItems(context: context, svgiconpath: "assets/images/svg_icons/profile_icon.svg", itemtext: "Profil"),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  MenuItems(context: context, svgiconpath: "assets/images/svg_icons/settings.svg", itemtext: "Ayarlar"),
                  MenuItems(context: context, itemtext: "Destek", icon: Icons.support_agent),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget MenuItems({
    required BuildContext context,
    String? svgiconpath,
    required String itemtext,
    IconData? icon,
  }) {
    return Container(
      margin: EdgeInsets.only(top: 20),
      child: InkWell(
        onTap: () => op_settings_icon(context),
        child: Row(
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
                    : SizedBox.square(
                        dimension: 25,
                      ),
            SizedBox(
              width: 40,
            ),
            Text(
              itemtext,
              textScaleFactor: 1,
              textAlign: TextAlign.left,
              style: GoogleFonts.rubik(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500),
            )
          ],
        ),
      ),
    );
  }
}

class DrawerHomePage extends StatefulWidget {
  final GlobalKey<FeedScreenState> feedListKey;
  DrawerHomePage({Key? key, required this.feedListKey}) : super(key: key);

  @override
  State<DrawerHomePage> createState() => _DrawerHomePageState();
}

class _DrawerHomePageState extends State<DrawerHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ZoomDrawer(
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
        menuBackgroundColor: Color(0xFF0353EF),

        mainScreen: FeedScreen(
          key: widget.feedListKey,
        ),
        menuScreen: MenuPage(),
      ),
    );
  }
}

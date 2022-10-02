import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/presentation/screens/PROFILE/OthersProfile/profile/profile_screen_components.dart';
import '../../../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../../../others/locator.dart';
import '../../../../../../others/strings.dart';

/*
class AllExperienceListMyProfile extends StatefulWidget {
  const AllExperienceListMyProfile({Key? key}) : super(key: key);

  @override
  _AllExperienceListMyProfileState createState() => _AllExperienceListMyProfileState();
}

class _AllExperienceListMyProfileState extends State<AllExperienceListMyProfile> {
  final double _photoSize = 50;

  final Mode _mode = locator<Mode>();

  @override
  Widget build(BuildContext context) {
    final Mode _mode = locator<Mode>();

    return Scaffold(
      backgroundColor: _mode.search_peoples_scaffold_background(),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: _mode.bottomMenuBackground(),
            ),
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop;
                  },
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
                  style: GoogleFonts.rubik(
                      color: _mode.homeScreenTitleColor(),
                      fontWeight: FontWeight.w800,
                      fontSize: 24),
                ),
                const SizedBox.square(
                  dimension: 25,
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Text(
                      "Deneyimler",
                      textScaleFactor: 1,
                      style: GoogleFonts.rubik(
                        color: _mode.blackAndWhiteConversion(),
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      //i use +1 because last index for less more see more widget
                      itemCount: profileData.experiences.length,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(
                        parent: NeverScrollableScrollPhysics(),
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                          decoration: BoxDecoration(
                            color: _mode.bottomMenuBackground(),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Color(0xFF939393).withOpacity(0.6),
                                  blurRadius: 0.5,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 0))
                            ],
                            //border: Border.symmetric(horizontal: BorderSide(color: _mode.blackAndWhiteConversion() as Color,width: 0.2, style: BorderStyle.solid,))
                          ),
                          child: Row(
                            children: [
                              MediaQuery.of(context).size.width < 320
                                  ? SizedBox.shrink()
                                  : Stack(
                                      children: [
                                        Container(
                                          height: _photoSize,
                                          width: _photoSize,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                              border: Border.all(
                                                width: 1,
                                                color: _mode
                                                        .homeScreenScaffoldBackgroundColor()
                                                    as Color,
                                              )),
                                          child: CircleAvatar(
                                            backgroundColor: Color(0xFF0353EF),
                                            child: Text("ppl$index",
                                                textScaleFactor: 1,
                                                style: GoogleFonts.rubik(
                                                    fontSize: 12)),
                                          ),
                                        ),
                                        Container(
                                          height: _photoSize,
                                          width: _photoSize,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(999),
                                              border: Border.all(
                                                width: 1,
                                                color: _mode
                                                        .search_peoples_scaffold_background()
                                                    as Color,
                                              )),
                                          child: //_userBloc != null ?
                                              CircleAvatar(
                                            radius: 999,
                                            backgroundImage: NetworkImage(
                                              Hobby().photo(profileData
                                                  .experiences.keys
                                                  .elementAt(index)),
                                            ),
                                            backgroundColor: Colors.transparent,
                                          ),
                                        ),
                                      ],
                                    ),
                              const SizedBox(
                                width: 5,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Hobby().name(profileData.experiences.keys
                                        .elementAt(index)),
                                    textScaleFactor: 1,
                                    style: GoogleFonts.rubik(
                                        color: _mode.blackAndWhiteConversion(),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        intToMonthName(
                                                DateTime.parse(profileData
                                                        .experiences.values
                                                        .elementAt(index)[0])
                                                    .month,
                                                context) +
                                            " " +
                                            DateTime.parse(profileData.experiences.values.elementAt(index)[0])
                                                .year
                                                .toString() +
                                            " - " +
                                            (profileData.experiences.values
                                                        .elementAt(index)
                                                        .length ==
                                                    1
                                                ? "Halen"
                                                : intToMonthName(DateTime.parse(profileData.experiences.values.elementAt(index)[1]).month, context) +
                                                    " " +
                                                    DateTime.parse(profileData
                                                            .experiences.values
                                                            .elementAt(index)[1])
                                                        .year
                                                        .toString()) +
                                            " ~ " +
                                            hobbyDateRange(index),
                                        textScaleFactor: 1,
                                        style: GoogleFonts.rubik(
                                            color:
                                                _mode.blackAndWhiteConversion(),
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      })
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
*/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/length/max_length_constants.dart';
import 'package:peopler/core/constants/navigation/navigation_constants.dart';
import 'package:peopler/presentation/screens/SUBSCRIPTIONS/subscriptions_functions.dart';
import '../../../../data/repository/location_repository.dart';
import '../../../../others/classes/variables.dart';
import '../../../../others/locator.dart';
import '../../../../others/functions/image_picker_functions.dart';
import '../../../../others/functions/search_functions.dart';

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({Key? key}) : super(key: key);

  @override
  _CreateProfileScreenState createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  late final UserBloc _userBloc;

  @override
  void initState() {
    items.addAll(duplicateItems);
    _userBloc = BlocProvider.of<UserBloc>(context);
    super.initState();
  }

  FixedExtentScrollController scrollController = FixedExtentScrollController(initialItem: 0);
  FixedExtentScrollController scrollController2 = FixedExtentScrollController(initialItem: 0);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double safePadding = MediaQuery.of(context).padding.top;

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: screenWidth / 5 * 3,
                color: const Color(0xFF0353EF),
                height: 5,
              ),
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 500,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                backButton(context),
                                const SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Profilini",
                                  textScaleFactor: 1,
                                  style: PeoplerTextStyle.normal.copyWith(
                                      color: const Color(0xFF000B21), fontSize: screenWidth < 360 || screenHeight < 670 ? 24 : 36, fontWeight: FontWeight.w300),
                                ),
                                Text(
                                  "Oluşturalım",
                                  textScaleFactor: 1,
                                  style: PeoplerTextStyle.normal.copyWith(
                                      color: const Color(0xFF000B21), fontSize: screenWidth < 360 || screenHeight < 670 ? 24 : 36, fontWeight: FontWeight.w300),
                                ),
                                SizedBox(
                                  height: screenHeight < 630 ? 30 : 60,
                                ),
                                Center(
                                  child: Text(
                                    "Profil fotoğrafını seç",
                                    textScaleFactor: 1,
                                    style: PeoplerTextStyle.normal.copyWith(
                                        color: const Color(0xFF000B21),
                                        fontSize: screenWidth < 360 || screenHeight < 670 ? 12 : 18,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(99),
                                    onTap: () async {
                                      printf("deneme çalıştı");
                                      debugPrint("asdasd");

                                      await showPicker(context, stateSetter: setState).then((value) => FocusScope.of(context).unfocus());
                                    },
                                    child: CircleAvatar(
                                      radius: 55,
                                      backgroundColor: const Color(0xFF8E9BB4),
                                      child: (UserBloc.user?.profileURL != null) && (UserBloc.user?.profileURL != '')
                                          ? ClipRRect(
                                              borderRadius: BorderRadius.circular(60),
                                              child: Image.network(
                                                UserBloc.user!.profileURL,
                                                width: 120,
                                                height: 120,
                                                fit: BoxFit.fitHeight,
                                              ),
                                            )
                                          : (image != null
                                              ? ClipRRect(
                                                  borderRadius: BorderRadius.circular(60),
                                                  child: Image.file(
                                                    image!,
                                                    width: 120,
                                                    height: 120,
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                )
                                              : Container(
                                                  decoration: BoxDecoration(
                                                      border: Border.all(width: 4, color: const Color(0xFF0353EF)),
                                                      color: Colors.grey[200],
                                                      borderRadius: BorderRadius.circular(60)),
                                                  width: 120,
                                                  height: 120,
                                                  child: const Icon(
                                                    Icons.photo_camera_outlined,
                                                    color: Color(0xFF0353EF),
                                                    size: 60,
                                                  ))),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 50,
                                ),
                                Center(
                                  child: Text(
                                    "Kendini anlat",
                                    textScaleFactor: 1,
                                    style: PeoplerTextStyle.normal.copyWith(
                                        color: const Color(0xFF000B21),
                                        fontSize: screenWidth < 360 || screenHeight < 670 ? 12 : 18,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                bioField(screenWidth),
                                const SizedBox(
                                  height: 40,
                                ),
                                Center(
                                  child: Text(
                                    "Şehir",
                                    textScaleFactor: 1,
                                    style: PeoplerTextStyle.normal.copyWith(
                                        color: const Color(0xFF000B21),
                                        fontSize: screenWidth < 360 || screenHeight < 670 ? 12 : 18,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                                selectCityButton(screenWidth, context, screenHeight, safePadding),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: screenHeight < 550 ? 0 : 20,
                          ),
                          continueButton(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Center continueButton(BuildContext context) {
    return Center(
      child: TextButton(
        onPressed: () async {
          if (UserBloc.user?.city != "" && bioController.text.isNotEmpty) {
            UserBloc.user?.biography = bioController.text;

            if (_userBloc.state == SignedInMissingInfoState()) {
              UserBloc.user?.missingInfo = false;
              _userBloc.add(updateUserInfoForLinkedInEvent());

              final LocationRepository _locationRepository = locator<LocationRepository>();
              LocationPermission _permission = await _locationRepository.checkPermissions();
              if (_permission == LocationPermission.always) {
                Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.HOME_SCREEN, (Route<dynamic> route) => false);
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(NavigationConstants.BEG_FOR_PERMISSION_SCREEN, (Route<dynamic> route) => false);
              }
            } else if (_userBloc.state == SignedOutState()) {
              Navigator.pushNamed(context, NavigationConstants.EMAIL_AND_PASSWORD_SCREEN);
            }
          } else if (UserBloc.user?.city == "" && bioController.text.isEmpty) {
            SnackBars(context: context).simple("Boşlukları Doldurunuz");
          } else if (UserBloc.user?.city == "" && bioController.text.isNotEmpty) {
            SnackBars(context: context).simple("Şehir seçmeniz gerekiyor.");
          } else if (UserBloc.user?.city != "" && bioController.text.isEmpty) {
            SnackBars(context: context).simple("Biyogrofi alanını doldurunuz!");
          }
        },
        child: Text(
          "Devam",
          textScaleFactor: 1,
          style: PeoplerTextStyle.normal.copyWith(
              color: UserBloc.user?.gender == "" ? const Color(0xFF0353EF) : const Color(0xFF0353EF),
              fontSize: 22,
              fontWeight: nameController.text.isEmpty || UserBloc.user?.city == "" ? FontWeight.w300 : FontWeight.w500),
        ),
      ),
    );
  }

  Center selectCityButton(double screenWidth, BuildContext context, double screenHeight, safePadding) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
        height: 40,
        width: 220,
        decoration: BoxDecoration(color: const Color(0xFF0353EF), borderRadius: BorderRadius.circular(20)),
        child: TextButton(
            onPressed: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  context: context,
                  builder: (BuildContext context) {
                    double keybHeight = MediaQuery.of(context).viewInsets.bottom;
                    final ScrollController _jumpToBottomScrollController = ScrollController();
                    return Container(
                      color: Colors.transparent,
                      height: 435 + keybHeight,
                      margin: EdgeInsets.only(bottom: keybHeight, top: safePadding),
                      child: StatefulBuilder(builder: (context, setStateBottomSheet) {
                        return SingleChildScrollView(
                          controller: _jumpToBottomScrollController,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 0.0),
                                child: Container(
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                  height: 350,
                                  width: MediaQuery.of(context).size.width - 40,
                                  child: Column(
                                    children: [
                                      Container(
                                        height: 90,
                                        padding: const EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: CupertinoSearchTextField(
                                          onTap: () async {
                                            /*
                                            Future.delayed(const Duration(milliseconds: 500), () {
                                              _jumpToBottomScrollController.animateTo(_jumpToBottomScrollController.position.maxScrollExtent - 50,
                                                  duration: const Duration(milliseconds: 500), curve: Curves.ease);
                                            });
                                            */
                                            setState(() {});
                                            setStateBottomSheet(() {});
                                          },
                                          placeholder: "Arama yapabilirsiniz...",
                                          style: PeoplerTextStyle.normal.copyWith(),
                                          autocorrect: true,
                                          backgroundColor: CupertinoColors.extraLightBackgroundGray,
                                          controller: editingController,
                                          onChanged: (String value) {
                                            filterSearchResults(value.replaceAll(" ", ""), setStateBottomSheet);
                                          },
                                          onSubmitted: (String value) {
                                            print('Submitted text: $value');
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 260,
                                        child: ListView.builder(
                                          itemCount: items.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return Container(
                                              margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                                              decoration: BoxDecoration(
                                                color: UserBloc.user?.city == items[index] ? const Color(0xFF0353EF) : Colors.white,
                                                borderRadius: BorderRadius.circular(15),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(10),
                                                child: Center(
                                                  child: InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        UserBloc.user?.city = items[index];
                                                        editingController.clear();
                                                        filterSearchResults("", setStateBottomSheet);
                                                        // DİKKAT - Yorum satırına alındı. 08/07/2022 MERT
                                                        /*
                                                            Strings.cityData.forEach((x) {
                                                              if (x[0][0] == UserBloc.user!.city) {
                                                                items2 = x[1];
                                                                print(items2);
                                                              }
                                                            });
                                                             */
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                      items[index],
                                                      textScaleFactor: 1,
                                                      style: UserBloc.user!.city == items[index]
                                                          ? const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF000B21))
                                                          : const TextStyle(fontSize: 18),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 0.0),
                                child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                  child: TextButton(
                                    child: const Text(
                                      "Vazgeç",
                                      textScaleFactor: 1,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    );
                  });
            },
            child: Text(
              UserBloc.user?.city != "" ? UserBloc.user?.city ?? "null" : "Şehir Seçin",
              textScaleFactor: 1,
              style: PeoplerTextStyle.normal
                  .copyWith(color: const Color(0xFFFFFFFF), fontSize: screenWidth < 360 || screenHeight < 670 ? 12 : 16, fontWeight: FontWeight.w300),
            )),
      ),
    );
  }

  Container bioField(double screenWidth) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(screenWidth < 300 ? 10 : 40, 0, 20, 0),
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
      height: 40,
      decoration: BoxDecoration(color: const Color(0xFF0353EF), borderRadius: BorderRadius.circular(20)),
      child: TextField(
        autofocus: false,
        keyboardType: TextInputType.name,
        cursorColor: const Color(0xFFB3CBFA),
        onEditingComplete: () {},
        onSubmitted: (_) => FocusScope.of(context).unfocus(),
        maxLength: MaxLengthConstants.BIOGRAPHY,
        controller: bioController,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          counterText: "",
          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          hintMaxLines: 1,
          border: InputBorder.none,
          hintText: 'Ahmetleri Severim',
          hintStyle: TextStyle(color: Color(0xFFB3CBFA), fontSize: 14),
        ),
        style: const TextStyle(color: Color(0xFFFFFFFF)),
      ),
    );
  }

  IconButton backButton(BuildContext context) {
    return IconButton(
      onPressed: () {
        Navigator.pop(context);
      },
      icon: const Icon(
        Icons.arrow_back_ios_outlined,
        color: Color(0xFF000B21),
        size: 32,
      ),
    );
  }
}

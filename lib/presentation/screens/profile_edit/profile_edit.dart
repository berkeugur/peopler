import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/others/functions/search_functions.dart';
import 'package:peopler/presentation/screens/profile/MyProfile/ProfileScreen/profile_screen.dart';
import 'package:peopler/presentation/screens/profile_edit/drag_drop_gridview.dart';
import 'package:peopler/presentation/screens/profile_edit/image_functions.dart';
import 'package:peopler/presentation/screens/profile_edit/profile_edit_function.dart';

ValueNotifier<bool> setStateEditProfile = ValueNotifier(false);

class EditProfileData {
  final double photoSize;
  final String fullName;
  final String schoolName;
  final String currentJobName;
  final String companyName;
  final String bio;

  EditProfileData({
    required this.schoolName,
    required this.currentJobName,
    required this.companyName,
    required this.photoSize,
    required this.fullName,
    required this.bio,
  });
}

class PhotoData {
  dynamic image;
  int number;

  PhotoData({required this.image, required this.number});
}

List<PhotoData> images = [
  //PhotoData(url: "https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg",number: 4,),
];

List<dynamic> images2 = [];

/// fepd => fake edit profile data
/// company, currentJobName ve school name kısımları boş olduğunda "" şeklinde
/// boş bir string döndürelim.
EditProfileData fepd = EditProfileData(
  photoSize: 100,
  fullName: UserBloc.user!.displayName,
  schoolName: UserBloc.user!.schoolName,
  currentJobName: UserBloc.user!.currentJobName,
  companyName: UserBloc.user!.company,
  bio: UserBloc.user!.biography,
);

TextEditingController nameController = TextEditingController(text: fepd.fullName);

TextEditingController bioController = TextEditingController(text: fepd.bio);

TextEditingController schoolNameController = TextEditingController(text: fepd.schoolName);

TextEditingController currentJobNameController = TextEditingController(text: fepd.currentJobName);

TextEditingController companyNameController = TextEditingController(text: fepd.companyName);

class ProfileEditScreen extends StatefulWidget {
  const ProfileEditScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditScreen> createState() => _ProfileEditScreenState();
}

int numberOfNewPhotos = 0;

class _ProfileEditScreenState extends State<ProfileEditScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    int _length = UserBloc.user!.photosURL.length;

    List.generate(_length, (index) {
      print(index);
      if (images2.length - numberOfNewPhotos != _length) {
        print("user bloc photos url = $_length ve images.length = ${images2.length}");
        images2.add(UserBloc.user!.photosURL[index]);
      }
      setState(() {});
    });
  }

  String changedCity = "";

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double safePadding = MediaQuery.of(context).padding.top;
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return SafeArea(
            child: Scaffold(
              backgroundColor: Mode().search_peoples_scaffold_background(),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _header(context),
                  Expanded(
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        _editProfilePhoto(fepd.photoSize),
                        _fullName(),
                        _bio(),
                        _schoolName(),
                        _currentJobName(),
                        _companyName(),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0, left: 40, right: 20),
                              child: Text(
                                "Yaşadığınız İl",
                                textAlign: TextAlign.left,
                                textScaleFactor: 1,
                                style: GoogleFonts.rubik(
                                    fontSize: 15, fontWeight: FontWeight.w600, color: Mode().blackAndWhiteConversion()),
                              ),
                            ),
                          ],
                        ),
                        selectCityButton(screenWidth, context, screenHeight, safePadding),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(20, 5, 5, 5),
                                child: Text(
                                  "Fotoğraflarınız",
                                  textScaleFactor: 1,
                                  style: GoogleFonts.rubik(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Mode().blackAndWhiteConversion()),
                                ),
                              ),
                              const DragDropGridView(),
                            ],
                          ),
                        )
                      ],
                    )),
                  )
                ],
              ),
            ),
          );
        });
  }

  Center selectCityButton(double screenWidth, BuildContext context, double screenHeight, safePadding) {
    return Center(
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
        height: 45,
        decoration: BoxDecoration(color: const Color(0xFF0353EF), borderRadius: BorderRadius.circular(20)),
        child: TextButton(
            onPressed: () {
              filterSearchResults("".replaceAll(" ", ""), setState);
              print("deney başarılı");

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
                                  decoration:
                                      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                                            await Future.delayed(const Duration(milliseconds: 500), () {
                                              _jumpToBottomScrollController.animateTo(
                                                  _jumpToBottomScrollController.position.maxScrollExtent - 50,
                                                  duration: const Duration(milliseconds: 500),
                                                  curve: Curves.ease);
                                            });
                                            setState(() {});
                                            setStateBottomSheet(() {});
                                          },
                                          placeholder: "Arama yapabilirsiniz...",
                                          style: GoogleFonts.rubik(),
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
                                                    color: UserBloc.user?.city == items[index]
                                                        ? const Color(0xFF0353EF)
                                                        : Colors.white,
                                                    borderRadius: BorderRadius.circular(99),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(10),
                                                    child: Center(
                                                      child: InkWell(
                                                        onTap: () {
                                                          changedCity = items[index];
                                                          setState(() {
                                                            cityItemButton(items[index], setStateBottomSheet);
                                                          });
                                                          Navigator.pop(context);
                                                        },
                                                        child: Text(
                                                          items[index],
                                                          style: UserBloc.user!.city == items[index]
                                                              ? const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight: FontWeight.w600,
                                                                  color: Color.fromARGB(255, 255, 255, 255))
                                                              : const TextStyle(fontSize: 18),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              })),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0, top: 0.0),
                                child: Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width,
                                  decoration:
                                      BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                                  child: TextButton(
                                    child: Text("Vazgeç"),
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
              changedCity != "" ? changedCity : UserBloc.user!.city,
              style: GoogleFonts.rubik(
                  color: const Color(0xFFFFFFFF),
                  fontSize: screenWidth < 360 || screenHeight < 670 ? 12 : 16,
                  fontWeight: FontWeight.w300),
            )),
      ),
    );
  }

  EdgeInsets _textFieldMargin() => const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10);

  Container _fullName() {
    return Container(
        alignment: Alignment.center,
        margin: _textFieldMargin(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Tam Adınız",
                textScaleFactor: 1,
                style: GoogleFonts.rubik(
                    fontSize: 15, fontWeight: FontWeight.w600, color: Mode().blackAndWhiteConversion()),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                  color: Color(0xFF0353EF).withOpacity(1), borderRadius: const BorderRadius.all(Radius.circular(99))),
              child: TextField(
                autocorrect: true,
                controller: nameController,
                style: const TextStyle(color: Color.fromARGB(255, 203, 220, 255)),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  hintMaxLines: 1,
                  border: InputBorder.none,
                  hintText: fepd.fullName,
                  hintStyle: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ));
  }

  Container _bio() {
    return Container(
        alignment: Alignment.center,
        margin: _textFieldMargin(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Kendinizi Tanıtın",
                textScaleFactor: 1,
                style: GoogleFonts.rubik(
                    fontSize: 15, fontWeight: FontWeight.w600, color: Mode().blackAndWhiteConversion()),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                  color: Color(0xFF0353EF).withOpacity(1), borderRadius: const BorderRadius.all(Radius.circular(99))),
              child: TextField(
                autocorrect: true,
                controller: bioController,
                style: const TextStyle(color: Color.fromARGB(255, 203, 220, 255)),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  hintMaxLines: 1,
                  border: InputBorder.none,
                  hintText: fepd.bio,
                  hintStyle: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ));
  }

  Container _schoolName() {
    return Container(
        alignment: Alignment.center,
        margin: _textFieldMargin(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Üniversite",
                textScaleFactor: 1,
                style: GoogleFonts.rubik(
                    fontSize: 15, fontWeight: FontWeight.w600, color: Mode().blackAndWhiteConversion()),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                  color: Color(0xFF0353EF).withOpacity(1), borderRadius: const BorderRadius.all(Radius.circular(99))),
              child: TextField(
                autocorrect: true,
                controller: schoolNameController,
                style: const TextStyle(color: Color.fromARGB(255, 203, 220, 255)),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  hintMaxLines: 1,
                  border: InputBorder.none,
                  hintText: fepd.schoolName,
                  hintStyle: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ));
  }

  Container _currentJobName() {
    return Container(
        alignment: Alignment.center,
        margin: _textFieldMargin(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Mesleğiniz (zorunlu değil)",
                textScaleFactor: 1,
                style: GoogleFonts.rubik(
                    fontSize: 15, fontWeight: FontWeight.w600, color: Mode().blackAndWhiteConversion()),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                  color: Color(0xFF0353EF).withOpacity(1), borderRadius: const BorderRadius.all(Radius.circular(99))),
              child: TextField(
                autocorrect: true,
                controller: currentJobNameController,
                style: const TextStyle(color: Color.fromARGB(255, 203, 220, 255)),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  hintMaxLines: 1,
                  border: InputBorder.none,
                  hintText: fepd.currentJobName,
                  hintStyle: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ));
  }

  Container _companyName() {
    return Container(
        alignment: Alignment.center,
        margin: _textFieldMargin(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                "Çalıştığınız Şirket (zorunlu değil)",
                textScaleFactor: 1,
                style: GoogleFonts.rubik(
                    fontSize: 15, fontWeight: FontWeight.w600, color: Mode().blackAndWhiteConversion()),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                  color: Color(0xFF0353EF).withOpacity(1), borderRadius: const BorderRadius.all(Radius.circular(99))),
              child: TextField(
                autocorrect: true,
                controller: companyNameController,
                style: const TextStyle(color: Color.fromARGB(255, 203, 220, 255)),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  hintMaxLines: 1,
                  border: InputBorder.none,
                  hintText: fepd.companyName,
                  hintStyle: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
          ],
        ));
  }

  Widget _editProfilePhoto(double _photoSize) {
    return ValueListenableBuilder(
        valueListenable: setStateEditProfile,
        builder: (context, snapshot, _) {
          return Stack(
            children: [
              Stack(
                children: [
                  Container(
                    height: _photoSize,
                    width: _photoSize,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          width: 5,
                          color: Mode().search_peoples_scaffold_background() as Color,
                        )),
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
                        border: Border.all(
                          width: 5,
                          color: Mode().search_peoples_scaffold_background() as Color,
                        )),
                    child: //_userBloc != null ?
                        ValueListenableBuilder(
                            valueListenable: setStateEditProfile,
                            builder: (context, x, y) {
                              return CircleAvatar(
                                radius: 999,
                                backgroundImage: newProfileimage != null
                                    ? FileImage(
                                        newProfileimage!,
                                      )
                                    : NetworkImage(
                                        UserBloc.user!.profileURL.toString(),
                                      ) as ImageProvider,
                                backgroundColor: Colors.transparent,
                              );
                            }),
                  ),
                ],
              ),

              //bu profil fotoğrafının üstünde olan ve tıklanmasını sağlayan bölüm.
              InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () {
                  showPickerForChangeProfilePhoto(context, stateSetter: setState);
                },
                child: Container(
                  height: _photoSize,
                  width: _photoSize,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        width: 5,
                        color: Mode().search_peoples_scaffold_background() as Color,
                      )),
                  child: CircleAvatar(
                      backgroundColor: Color(0xFF0353EF).withOpacity(0.3), child: const Icon(Icons.photo_camera)),
                ),
              ),
            ],
          );
        });
  }

  Container _header(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15, top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            width: 80,
            child: Align(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  int numberOfFile = 0;
                  List.generate(images2.length, (index) {
                    images2[index].runtimeType.toString() != "String" ? numberOfFile++ : numberOfFile = numberOfFile;
                  });

                  if (numberOfFile != 0) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: const Text('Emin Misiniz?'), // App Permission Settings
                              content: const Text(
                                  'Kaydetmediğiniz değişikliklikler var. Devam ederseniz değişiklikleriniz kaybolacak.'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('İptal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    numberOfNewPhotos = 0;

                                    List.generate(images2.length, (index) {
                                      if (images2[index].runtimeType.toString() != "String") {
                                        images2.removeAt(index);
                                      }
                                    });
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                  child: const Text('Devam Et'),
                                )
                              ],
                            ));
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: SvgPicture.asset(
                  "assets/images/svg_icons/back_arrow.svg",
                  width: 25,
                  height: 25,
                  color: Mode().homeScreenIconsColor(),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Text(
            "Profili Düzenle",
            textScaleFactor: 1,
            style: GoogleFonts.rubik(color: Mode().homeScreenTitleColor(), fontWeight: FontWeight.w600, fontSize: 18),
          ),
          InkWell(
            onTap: () async {
              await saveButtonFunction(changedCity);

              Future.delayed(const Duration(milliseconds: 500), (() {
                setStateValue.value = false;
              })).then((value) => setStateValue.value = true);
              numberOfNewPhotos = 0;
              Navigator.of(context).pop();
            },
            child: SizedBox(
              width: 80,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Kaydet",
                  textScaleFactor: 1,
                  style: GoogleFonts.rubik(fontSize: 16, color: Mode().homeScreenTitleColor()),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<dynamic> customDialog99(BuildContext context, String title, String content) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              textScaleFactor: 1,
            ),
            content: Text(
              content,
              textScaleFactor: 1,
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Kapat',
                    textScaleFactor: 1,
                  )),
            ],
          );
        });
  }
}

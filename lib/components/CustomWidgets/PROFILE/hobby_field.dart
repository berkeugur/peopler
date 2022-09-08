import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/data/model/user.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/others/classes/hobbies.dart';

import '../../../data/model/hobbymodel.dart';
import '../../../presentation/screens/PROFILE/MyProfile/ProfileScreen/profile_screen.dart';
import '../../../presentation/screens/PROFILE_EDIT/Home/profile_edit_home.dart';

class ProfileHobbyField extends StatefulWidget {
  final MyUser profileData;
  ProfileHobbyField({Key? key, required this.profileData}) : super(key: key);

  @override
  State<ProfileHobbyField> createState() => _ProfileHobbyFieldState();
}

class _ProfileHobbyFieldState extends State<ProfileHobbyField> {
  bool isHobbyHas(String selectedHobbyName) {
    //selectedHobbyName = "Yemek Yapmak";
    int counter = 0;
    List.generate(UserBloc.user!.hobbies.length, (index) {
      HobbyModel hobbyItem = HobbyModel.fromJson(UserBloc.user!.hobbies[index]);
      hobbyItem.title == selectedHobbyName ? counter++ : null;
    });
    if (counter == 0) {
      return false;
    } else {
      return true;
    }
  }

  PageController controller = PageController();
  late int _currentPage;
  @override
  void initState() {
    _currentPage = 0;
    controller.addListener(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.hasClients) {
          setState(() {
            _currentPage = controller.page!.toInt();
          });
        } else {
          SnackBars(context: context).simple(controller.hasClients.toString());
        }
      });
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 40,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Deneyimler",
                  textScaleFactor: 1,
                  style: GoogleFonts.rubik(
                    color: Mode().blackAndWhiteConversion(),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      String? selectedValue;

                      List<int> selectedSubHobbyIndex = [];

                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (controller.hasClients) {
                          setState(() {
                            _currentPage != 0 ? controller.jumpToPage(0) : null;
                            _currentPage = 0;
                          });
                        } else {
                          SnackBars(context: context).simple(controller.hasClients.toString() + _currentPage.toString());
                        }
                      });

                      //
                      //
                      double _marginValue = 20;
                      BoxDecoration _decoration = BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      );
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
                        backgroundColor: Colors.transparent,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setStatebs) {
                            return Column(
                              children: [
                                Container(
                                  decoration: _decoration,
                                  margin: EdgeInsets.all(_marginValue),
                                  child: Column(
                                    children: [
                                      SizedBox(
                                        height: 50,
                                        child: Padding(
                                          padding: const EdgeInsets.only(top: 8, left: 15, right: 15, bottom: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "DENEYİM EKLE",
                                                style: GoogleFonts.rubik(fontSize: 18, fontWeight: FontWeight.w500, color: Color(0xFF0353EF)),
                                              ),
                                              InkWell(
                                                borderRadius: BorderRadius.circular(99),
                                                onTap: () => Navigator.of(context).pop(),
                                                child: Container(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF0353EF),
                                                    borderRadius: BorderRadius.circular(999),
                                                  ),
                                                  child: Center(
                                                      child: Text(
                                                    "kapat",
                                                    style: GoogleFonts.rubik(color: Colors.white),
                                                  )),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        height: 1,
                                      ),
                                      SizedBox(
                                        height: (MediaQuery.of(context).size.height * 0.7) - (_marginValue * 3) - (1 + 60 + 50),
                                        child: PageView(
                                          controller: controller,
                                          children: [
                                            SingleChildScrollView(
                                              child: Column(
                                                children: Hobby().hobbiesNameList().map(
                                                  (value) {
                                                    return Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        RadioListTile<String>(
                                                          secondary: CircleAvatar(
                                                            child: SvgPicture.asset(
                                                              "assets/images/hobby_badges/${Hobby().stringToHobbyTypes(value)}.svg",
                                                              fit: BoxFit.contain,
                                                            ),
                                                          ),
                                                          value: value,
                                                          groupValue: selectedValue,
                                                          title: Text(value),
                                                          onChanged: (value) => setStatebs(() => selectedValue = value!),
                                                        ),
                                                        Divider(),
                                                      ],
                                                    );
                                                  },
                                                ).toList(),
                                              ),
                                            ),
                                            SingleChildScrollView(
                                              child: Padding(
                                                padding: const EdgeInsets.all(15.0),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: OutlinedButton(
                                                            onPressed: () {},
                                                            child: Text("Yeni Öneride Bulun"),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 15,
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: OutlinedButton(
                                                            onPressed: () {
                                                              setStatebs(() {
                                                                selectedSubHobbyIndex.clear();
                                                              });
                                                            },
                                                            child: Text("temizle"),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    selectedValue == null
                                                        ? Text("null error ")
                                                        : Wrap(
                                                            children: List.generate(
                                                              Hobby().subHobby(Hobby().stringToHobbyTypesModel(selectedValue!))?.length ?? 0,
                                                              (index) => Padding(
                                                                padding: const EdgeInsets.all(5.0),
                                                                child: ChoiceChip(
                                                                  avatar: selectedSubHobbyIndex.contains(index)
                                                                      ? Icon(
                                                                          Icons.done,
                                                                          color: Colors.white,
                                                                        )
                                                                      : null,
                                                                  label: Text(
                                                                    Hobby().subHobby(Hobby().stringToHobbyTypesModel(selectedValue!))![index],
                                                                    style: GoogleFonts.rubik(color: Colors.white),
                                                                  ),
                                                                  selected: selectedSubHobbyIndex.contains(index),
                                                                  selectedColor: Color(0xFF0353EF),
                                                                  disabledColor: Colors.grey[500],
                                                                  backgroundColor: Colors.grey[500],
                                                                  onSelected: (value) {
                                                                    setStatebs(() {
                                                                      if (selectedSubHobbyIndex.contains(index)) {
                                                                        selectedSubHobbyIndex.removeAt(index);
                                                                      } else {
                                                                        if (selectedSubHobbyIndex.length < 5) {
                                                                          selectedSubHobbyIndex.add(index);
                                                                        } else {
                                                                          SnackBars(context: context).simple("En fazla 5 adet ekleyebilirsiniz");
                                                                        }
                                                                      }
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                InkWell(
                                  borderRadius: BorderRadius.circular(99),
                                  onTap: () async {
                                    if (_currentPage == 0) {
                                      if (selectedValue != null) {
                                        if (isHobbyHas(selectedValue!)) {
                                          SnackBars(context: context)
                                              .simple("Bu hobiyi zaten daha önce eklemişsiniz. İsterseniz güncelleyebilir veya silip tekrar ekleyebilirsiniz.");
                                        } else {
                                          if (controller.hasClients) {
                                            print(UserBloc.user!.hobbies);
                                            print(UserBloc.user!.hobbies.runtimeType);
                                            controller.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.bounceIn);
                                            print(Hobby().subHobby(Hobby().stringToHobbyTypesModel(selectedValue!))?.length ?? 0);
                                          } else {
                                            SnackBars(context: context).simple(controller.hasClients.toString());
                                          }
                                        }
                                      } else {
                                        SnackBars(context: context).simple("Bir hobi seçiniz");
                                      }
                                    } else if (_currentPage == 1) {
                                      await FirebaseFirestore.instance.collection("users").doc(UserBloc.user!.userID).update({
                                        "hobbies": FieldValue.arrayUnion(
                                          [
                                            HobbyModel(
                                              title: selectedValue,
                                              subtitles: List.generate(
                                                selectedSubHobbyIndex.length,
                                                (index) => Subtitles(
                                                  subtitle: Hobby().subHobby(Hobby().stringToHobbyTypesModel(selectedValue!))![selectedSubHobbyIndex[index]],
                                                ),
                                              ),
                                            ).toJson(),
                                          ],
                                        ),
                                      }).then((value) {
                                        Navigator.of(context).pop();
                                        setStateProfileScreen.value = !setStateProfileScreen.value;
                                        Future.delayed(const Duration(milliseconds: 500), () {
                                          setStateProfileScreen.value = !setStateProfileScreen.value;
                                        });
                                      });
                                      SnackBars(context: context).simple("page 2");
                                    } else {
                                      SnackBars(context: context).simple("error");
                                    }
                                  },
                                  child: Container(
                                      decoration: _decoration,
                                      height: 50,
                                      margin: EdgeInsets.symmetric(horizontal: _marginValue),
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            _currentPage == 0 ? "DEVAM" : "KAYDET",
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.rubik(fontWeight: FontWeight.w500, color: Color(0xFF0353EF), fontSize: 18),
                                          ),
                                        ],
                                      )),
                                ),
                                SizedBox(
                                  height: _marginValue,
                                ),
                              ],
                            );
                          });
                        },
                      );
                      /*FirebaseFirestore.instance.collection("users").doc(profileData.userID).update({
                        "hobbies": FieldValue.arrayUnion([
                          HobbyModel(title: "Kitap Okumak", subtitles: [
                            Subtitles(subtitle: "Kişisel Gelişim"),
                          ]).toJson()
                        ])
                      }); */
                    },
                    // ignore: prefer_const_constructors
                    icon: Icon(Icons.add_box)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 1, child: Divider()),
        SizedBox(
          height: 2000,
          child: MasonryGridView.count(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: widget.profileData.hobbies.length,
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            itemBuilder: (context, index) {
              HobbyModel hobby = HobbyModel.fromJson(widget.profileData.hobbies[index]);
              List<Widget> subtitles = List.generate(
                hobby.subtitles?.length ?? 0,
                (index) {
                  Subtitles _subtitles = Subtitles(level: hobby.subtitles![index].level, subtitle: hobby.subtitles![index].subtitle);
                  return Column(
                    children: [
                      const Divider(),
                      Text(
                        _subtitles.subtitle.toString() + (_subtitles.level == null ? "" : (" (" + _subtitles.level.toString() + ")")),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.rubik(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  );
                },
              );
              return Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.withOpacity(0.5))),
                margin: const EdgeInsets.all(4),
                padding: const EdgeInsets.all(10),
                width: (MediaQuery.of(context).size.width - 48) / 2,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: CircleAvatar(
                        radius: 40,
                        child: SvgPicture.asset(
                          "assets/images/hobby_badges/${Hobby().stringToHobbyTypes(hobby.title ?? "Kamp Yapmak")}.svg",
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Text(
                      hobby.title ?? "null",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.rubik(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    ...subtitles,
                  ],
                ),
              );
            },
          ),
        ),
        const Text("hop nereye hemşerim")
      ],
    );
  }
}

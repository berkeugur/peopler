import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/core/constants/length/max_length_constants.dart';
import 'package:peopler/data/model/HobbyModels/hobbies.dart';
import 'package:peopler/data/model/HobbyModels/hobbymodel.dart';
import 'package:peopler/data/model/user.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/presentation/screen_services/hobby_add_service.dart';

class ProfileHobbyField extends StatefulWidget {
  final MyUser profileData;
  const ProfileHobbyField({Key? key, required this.profileData}) : super(key: key);

  @override
  State<ProfileHobbyField> createState() => _ProfileHobbyFieldState();
}

class _ProfileHobbyFieldState extends State<ProfileHobbyField> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late final AnimationController animationController;
  PageController controller = PageController();
  late int _currentPage;

  String? selectedValue;

  List<int> selectedSubHobbyIndex = [];
  @override
  void initState() {
    animationController = AnimationController(vsync: this);
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
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    _controller.dispose();
    controller.dispose();
    super.dispose();
  }

  ValueNotifier<bool> isEditModeActive = ValueNotifier(false);

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
                widget.profileData.hobbies.length == 0 && widget.profileData.userID != UserBloc.user?.userID ? const SizedBox.shrink() : _buildHeaderTitle(),
                widget.profileData.userID != UserBloc.user!.userID
                    ? const SizedBox.shrink()
                    : Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                isEditModeActive.value = !isEditModeActive.value;
                              },
                              icon: Icon(
                                Icons.edit,
                                color: Mode().blackAndWhiteConversion(),
                              )),
                          IconButton(
                              onPressed: () async {
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
                                  builder: (contextSMBS) {
                                    return StatefulBuilder(builder: (contextSB, setStatebs) {
                                      return SingleChildScrollView(
                                        child: Column(
                                          children: [
                                            Container(
                                              decoration: _decoration,
                                              margin: EdgeInsets.all(_marginValue),
                                              child: Column(
                                                children: [
                                                  _bottomSheetHeader(context),
                                                  Divider(
                                                    height: 1,
                                                  ),
                                                  SizedBox(
                                                    height: (MediaQuery.of(context).size.height * 0.7) - (_marginValue * 3) - (1 + 60 + 50),
                                                    child: PageView(
                                                      physics: const NeverScrollableScrollPhysics(),
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
                                                                      title: Text(
                                                                        value,
                                                                      ),
                                                                      onChanged: (value) => setStatebs(() => selectedValue = value!),
                                                                    ),
                                                                    const Divider(),
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
                                                                    _buildNewSuggestion(),
                                                                    const SizedBox(
                                                                      width: 15,
                                                                    ),
                                                                    _buildClearAllButton(setStatebs, selectedSubHobbyIndex),
                                                                  ],
                                                                ),
                                                                selectedValue == null
                                                                    ? const Text("null error ")
                                                                    : Wrap(
                                                                        children: List.generate(
                                                                          Hobby().subHobby(Hobby().stringToHobbyTypesModel(selectedValue!))?.length ?? 0,
                                                                          (index) => Padding(
                                                                            padding: const EdgeInsets.all(5.0),
                                                                            child: ChoiceChip(
                                                                              avatar: selectedSubHobbyIndex.contains(index)
                                                                                  ? const Icon(
                                                                                      Icons.done,
                                                                                      color: Colors.white,
                                                                                    )
                                                                                  : null,
                                                                              label: Text(
                                                                                Hobby().subHobby(Hobby().stringToHobbyTypesModel(selectedValue!))![index],
                                                                                style: GoogleFonts.rubik(
                                                                                  color: Colors.white,
                                                                                ),
                                                                              ),
                                                                              selected: selectedSubHobbyIndex.contains(index),
                                                                              selectedColor: const Color(0xFF0353EF),
                                                                              disabledColor: Colors.grey[500],
                                                                              backgroundColor: Colors.grey[500],
                                                                              onSelected: (value) {
                                                                                setStatebs(
                                                                                  () {
                                                                                    if (selectedSubHobbyIndex.contains(index)) {
                                                                                      selectedSubHobbyIndex.remove(index);
                                                                                    } else {
                                                                                      if (selectedSubHobbyIndex.length < 5) {
                                                                                        selectedSubHobbyIndex.add(index);
                                                                                      } else {
                                                                                        SnackBars(context: context).simple("En fazla 5 adet ekleyebilirsiniz");
                                                                                      }
                                                                                    }
                                                                                  },
                                                                                );
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
                                                    if (Hobby().isHobbyHas(selectedValue!)) {
                                                      SnackBars(context: context).simple(
                                                          "Bu hobiyi zaten daha önce eklemişsiniz. İsterseniz güncelleyebilir veya silip tekrar ekleyebilirsiniz.");
                                                    } else {
                                                      if (controller.hasClients) {
                                                        controller.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.linear);
                                                      } else {
                                                        SnackBars(context: context).simple(controller.hasClients.toString());
                                                      }
                                                    }
                                                  } else {
                                                    SnackBars(context: context).simple("Bir hobi seçiniz");
                                                  }
                                                } else if (_currentPage == 1 && selectedValue != null) {
                                                  HobbyService()
                                                      .addNew(
                                                    context: context,
                                                    selectedValue: selectedValue!,
                                                    selectedSubHobbyIndex: selectedSubHobbyIndex,
                                                  )
                                                      .then((value) {
                                                    selectedSubHobbyIndex = [];
                                                    selectedValue = null;
                                                  });
                                                  SnackBars(context: context).simple("Başarıyla eklendi");
                                                } else {
                                                  SnackBars(context: context).simple("error");
                                                }
                                              },
                                              child: _buildBottomButton(
                                                _decoration,
                                                _marginValue,
                                              ),
                                            ),
                                            SizedBox(
                                              height: _marginValue,
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                                  },
                                );
                              },
                              icon: Icon(
                                Icons.add_box,
                                color: Mode().blackAndWhiteConversion(),
                              )),
                        ],
                      ),
              ],
            ),
          ),
        ),
        widget.profileData.hobbies.isEmpty ? const SizedBox.shrink() : const SizedBox(height: 1, child: Divider()),
        SizedBox(
          child: MasonryGridView.count(
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            itemCount: widget.profileData.hobbies.length,
            crossAxisCount: 2,
            mainAxisSpacing: 4,
            shrinkWrap: true,
            crossAxisSpacing: 4,
            itemBuilder: (context, index) {
              HobbyModel hobby = HobbyModel.fromJson(
                widget.profileData.hobbies[index],
              );
              List<Widget> subtitles = List.generate(
                hobby.subtitles?.length ?? 0,
                (index) {
                  Subtitles _subtitles = Subtitles(
                    level: hobby.subtitles![index].level,
                    subtitle: hobby.subtitles![index].subtitle,
                  );
                  return Column(
                    children: [
                      Divider(
                        color: Mode().blackAndWhiteConversion()!.withOpacity(0.5),
                      ),
                      Text(
                        _subtitles.subtitle.toString() + (_subtitles.level == null ? "" : (" (" + _subtitles.level.toString() + ")")),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.rubik(
                          fontSize: 14,
                          color: Mode().blackAndWhiteConversion(),
                        ),
                      ),
                    ],
                  );
                },
              );
              return _buildHobbyItem(context, hobby, subtitles);
            },
          ),
        ),
      ],
    );
  }

  Expanded _buildClearAllButton(StateSetter setStatebs, List<int> selectedSubHobbyIndex) {
    return Expanded(
      flex: 1,
      child: OutlinedButton(
        onPressed: () {
          setStatebs(() {
            selectedSubHobbyIndex.clear();
          });
        },
        child: const Text("temizle"),
      ),
    );
  }

  Expanded _buildNewSuggestion() {
    return Expanded(
      flex: 2,
      child: OutlinedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Yeni deneyim önerisi"),
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
                      HobbyService().addSuggestion(
                        controller: _controller,
                        selectedValue: selectedValue ?? "null error #hfs error ",
                        context: context,
                        animationController: animationController,
                      );
                    },
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.white,
                    maxLength: MaxLengthConstants.HOBBY_SUGGEST,
                    controller: _controller,
                    textInputAction: TextInputAction.send,
                    autocorrect: true,
                    decoration: const InputDecoration(
                      counterText: "",
                      contentPadding: EdgeInsets.fromLTRB(0, 13, 0, 10),
                      hintMaxLines: 1,
                      border: InputBorder.none,
                      hintText: 'Öneriniz',
                      hintStyle: TextStyle(color: Color(0xFF9ABAF9), fontSize: 16),
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
                    onPressed: () {
                      HobbyService().addSuggestion(
                        controller: _controller,
                        selectedValue: selectedValue ?? "null error #hfs error ",
                        context: context,
                        animationController: animationController,
                      );
                    },
                    child: const Text("Gönder"),
                  ),
                ],
              );
            },
          );
        },
        child: const Text("Yeni Öneride Bulun"),
      ),
    );
  }

  SizedBox _bottomSheetHeader(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 15, right: 15, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "DENEYİM EKLE",
              style: GoogleFonts.rubik(fontSize: 18, fontWeight: FontWeight.w500, color: const Color(0xFF0353EF)),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(99),
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0353EF),
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
    );
  }

  Text _buildHeaderTitle() {
    return Text(
      "Deneyimler",
      textScaleFactor: 1,
      style: GoogleFonts.rubik(
        color: Mode().blackAndWhiteConversion(),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Container _buildBottomButton(BoxDecoration _decoration, double _marginValue) {
    return Container(
        decoration: _decoration,
        height: 50,
        margin: EdgeInsets.symmetric(horizontal: _marginValue),
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              _currentPage == 0 ? "DEVAM" : "KAYDET",
              textAlign: TextAlign.center,
              style: GoogleFonts.rubik(fontWeight: FontWeight.w500, color: const Color(0xFF0353EF), fontSize: 18),
            ),
          ],
        ));
  }

  Widget _buildHobbyItem(BuildContext context, HobbyModel hobby, List<Widget> subtitles) {
    return ValueListenableBuilder(
        valueListenable: isEditModeActive,
        builder: (context, _, __) {
          return Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.withOpacity(0.5))),
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.all(10),
            width: (MediaQuery.of(context).size.width - 48) / 2,
            child: Column(
              children: [
                _buildHobbyAsset(hobby),
                _buildHobbyName(hobby),
                ...subtitles,
                Visibility(
                    visible: isEditModeActive.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(
                          color: Mode().blackAndWhiteConversion()!.withOpacity(0.5),
                        ),
                        OutlinedButton(
                          onPressed: () async {
                            await HobbyService().delete(context, hobby);
                          },
                          child: const Text("KALDIR"),
                        ),
                      ],
                    ))
              ],
            ),
          );
        });
  }

  Padding _buildHobbyAsset(HobbyModel hobby) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: CircleAvatar(
        radius: 40,
        child: SvgPicture.asset(
          "assets/images/hobby_badges/${Hobby().stringToHobbyTypes(hobby.title ?? "Kamp Yapmak")}.svg",
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Text _buildHobbyName(HobbyModel hobby) {
    return Text(
      hobby.title ?? "null",
      textAlign: TextAlign.center,
      style: GoogleFonts.rubik(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Mode().blackAndWhiteConversion(),
      ),
    );
  }
}

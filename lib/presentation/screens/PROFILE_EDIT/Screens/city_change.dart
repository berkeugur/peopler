import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/length/max_length_constants.dart';
import 'package:peopler/components/FlutterWidgets/app_bars.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/presentation/screens/PROFILE_EDIT/Service/city_change_service.dart';

import '../../../../core/constants/enums/subscriptions_enum.dart';
import '../../../../others/functions/search_functions.dart';
import '../../../../others/widgets/snack_bars.dart';

class ProfileEditCityChangeScreen extends StatefulWidget {
  const ProfileEditCityChangeScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditCityChangeScreen> createState() => _ProfileEditCityChangeScreenState();
}

class _ProfileEditCityChangeScreenState extends State<ProfileEditCityChangeScreen> with TickerProviderStateMixin {
  TextEditingController cityController = TextEditingController(text: UserBloc.user!.city);
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mode().homeScreenScaffoldBackgroundColor(),
      appBar: PeoplerAppBars(context: context).PROFILE_EDIT_ITEMS(
          title: "Şehir",
          function: () async {
            await CityChangeService.saveChanges(context, cityController, _controller);
          }),
      body: Column(
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //const name_surname_title(),
                EditField(controller: cityController),
                const Explanation(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditField extends StatefulWidget {
  const EditField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  State<EditField> createState() => _EditFieldState();
}

class _EditFieldState extends State<EditField> {
  String changedCity = "";
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF0353EF).withOpacity(1),
        borderRadius: const BorderRadius.all(
          Radius.circular(99),
        ),
      ),
      child: InkWell(
        onTap: () {
          if (UserBloc.entitlement != SubscriptionTypes.premium) {
            showCityChangeWarning(context);
            return;
          }

          filterSearchResults("".replaceAll(" ", ""), setState);

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
                  margin: EdgeInsets.only(bottom: keybHeight),
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
                                        await Future.delayed(const Duration(milliseconds: 500), () {
                                          _jumpToBottomScrollController.animateTo(_jumpToBottomScrollController.position.maxScrollExtent - 50,
                                              duration: const Duration(milliseconds: 500), curve: Curves.ease);
                                        });
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
                                        debugPrint('Submitted text: $value');
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                      height: 260,
                                      child: ListView.builder(
                                          itemCount: items.length,
                                          itemBuilder: (BuildContext context, int index) {
                                            return InkWell(
                                              onTap: () {
                                                widget.controller.text = items[index];
                                                setState(() {
                                                  cityItemButton(String item, setStateBottomSheet) {
                                                    editingController.clear();
                                                    filterSearchResults("", setStateBottomSheet);
                                                  }

                                                  cityItemButton(items[index], setStateBottomSheet);
                                                });
                                                setStateBottomSheet(() {});
                                                Navigator.pop(context);
                                              },
                                              child: Container(
                                                margin: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                                                decoration: BoxDecoration(
                                                  color: (widget.controller.text.isNotEmpty
                                                          ? (widget.controller.text == items[index])
                                                          : (UserBloc.user!.city == items[index]))
                                                      ? const Color(0xFF0353EF)
                                                      : Colors.white,
                                                  borderRadius: BorderRadius.circular(99),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(10),
                                                  child: Center(
                                                    child: Text(
                                                      items[index],
                                                      style: (widget.controller.text.isNotEmpty
                                                              ? widget.controller.text == items[index]
                                                              : UserBloc.user!.city == items[index])
                                                          ? const TextStyle(
                                                              fontSize: 20, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 255, 255, 255))
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
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                              child: TextButton(
                                child: const Text("Vazgeç"),
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
        child: TextField(
          enabled: false,
          autocorrect: true,
          controller: widget.controller,
          maxLength: MaxLengthConstants.BIOGRAPHY,
          minLines: 1,
          maxLines: 2,
          style: const TextStyle(color: Color.fromARGB(255, 203, 220, 255)),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 20,
            ),
            border: InputBorder.none,
            hintText: UserBloc.user!.city == "" ? "Hangi Şehirde Yaşıyorsunuz?" : UserBloc.user!.city,
            hintStyle: UserBloc.user!.city == ""
                ? PeoplerTextStyle.normal.copyWith(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 16,
                  )
                : PeoplerTextStyle.normal.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                  ),
          ),
        ),
      ),
    );
  }
}

class Explanation extends StatefulWidget {
  const Explanation({
    Key? key,
  }) : super(key: key);

  @override
  State<Explanation> createState() => _ExplanationState();
}

class _ExplanationState extends State<Explanation> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Şehrimdekiler bölümünde şehrinizdeki diğer insanlarla bağlantı kurabilirsiniz.\n\n",
            style: PeoplerTextStyle.normal.copyWith(
              fontSize: 14,
              color: Mode().homeScreenTitleColor(),
            ),
          ),
          Text(
            "", //"#beXXXX\n#beYYYY\n#beZZZZ",
            style: PeoplerTextStyle.normal.copyWith(
              fontSize: 15,
              color: Mode().homeScreenTitleColor(),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

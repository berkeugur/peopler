import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/length/max_length_constants.dart';
import 'package:peopler/components/FlutterWidgets/app_bars.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/presentation/screens/PROFILE_EDIT/Service/biography_change_service.dart';
import 'package:peopler/presentation/screens/PROFILE_EDIT/Service/company_change_service.dart';
import 'package:peopler/presentation/screens/PROFILE_EDIT/Service/education_change_service.dart';

class ProfileEditCompanyChangeScreen extends StatefulWidget {
  const ProfileEditCompanyChangeScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditCompanyChangeScreen> createState() => _ProfileEditCompanyChangeScreenState();
}

class _ProfileEditCompanyChangeScreenState extends State<ProfileEditCompanyChangeScreen> with TickerProviderStateMixin {
  TextEditingController companyController = TextEditingController(text: UserBloc.user!.company);
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
          title: "Meslek",
          function: () async {
            await CompanyChangeService.saveChanges(context, companyController, _controller);
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
                EditField(controller: companyController),
                const Explanation(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EditField extends StatelessWidget {
  const EditField({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

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
      child: TextField(
        autocorrect: true,
        controller: controller,
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
          hintText: UserBloc.user!.company == "" ? "Çalıştığınız Şirket" : UserBloc.user!.company,
          hintStyle: UserBloc.user!.company == ""
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
    );
  }
}

class Explanation extends StatelessWidget {
  const Explanation({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Mesleğinizi paylaşabilirsiniz..\n\n",
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

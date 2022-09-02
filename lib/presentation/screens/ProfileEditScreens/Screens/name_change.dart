import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/others/classes/AppBars.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/presentation/screens/ProfileEditScreens/Home/profile_edit_home.dart';
import 'package:peopler/presentation/screens/ProfileEditScreens/Service/name_change_service.dart';
import 'package:peopler/presentation/screens/profile/MyProfile/ProfileScreen/profile_screen.dart';
import 'package:peopler/ui/dialogs.dart';

class ProfileEditNameChangeScreen extends StatefulWidget {
  const ProfileEditNameChangeScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditNameChangeScreen> createState() => _ProfileEditNameChangeScreenState();
}

class _ProfileEditNameChangeScreenState extends State<ProfileEditNameChangeScreen> with TickerProviderStateMixin {
  TextEditingController nameController = TextEditingController(text: UserBloc.user!.displayName);
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
      appBar: PeoplerAppBars(context: context).PROFILE_EDIT_ITEMS(
          title: "İsim Soyisim",
          function: () async {
            await NameChangeService.saveChanges(context, nameController, _controller);
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
                EditField(nameController: nameController),
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
    required this.nameController,
  }) : super(key: key);

  final TextEditingController nameController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      decoration: BoxDecoration(color: const Color(0xFF0353EF).withOpacity(1), borderRadius: const BorderRadius.all(Radius.circular(99))),
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
          hintText: UserBloc.user!.displayName,
          hintStyle: const TextStyle(color: Colors.white, fontSize: 18),
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
            "Eğer profiliniz gizli ise diğer kullanıcılar sizi #${UserBloc.user?.pplName ?? "ppl1923"} şeklinde görecektir.\n\n",
            style: GoogleFonts.rubik(fontSize: 14, color: Colors.grey[850]),
          ),
          Text(
            "Peopler gizliliğinizi önemser.",
            style: GoogleFonts.rubik(fontSize: 15, color: Colors.grey[850], fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class NameSurnameTitle extends StatelessWidget {
  const NameSurnameTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0),
      child: Text(
        "İsim Soyisim",
        textScaleFactor: 1,
        style: GoogleFonts.rubik(fontSize: 15, fontWeight: FontWeight.w600, color: Mode().blackAndWhiteConversion()),
      ),
    );
  }
}

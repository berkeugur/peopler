import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/core/constants/length/max_length_constants.dart';
import 'package:peopler/components/AppBars.dart';
import 'package:peopler/presentation/screens/ProfileEditScreens/Service/biography_change_service.dart';
import 'package:peopler/presentation/screens/ProfileEditScreens/Service/education_change_service.dart';

class ProfileEditEducationChangeScreen extends StatefulWidget {
  const ProfileEditEducationChangeScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditEducationChangeScreen> createState() => _ProfileEditEducationChangeScreenState();
}

class _ProfileEditEducationChangeScreenState extends State<ProfileEditEducationChangeScreen> with TickerProviderStateMixin {
  TextEditingController educationController = TextEditingController(text: UserBloc.user!.schoolName);
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
          title: "Eğitim",
          function: () async {
            await EducationChangeService.saveChanges(context, educationController, _controller);
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
                EditField(controller: educationController),
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
          hintText: UserBloc.user!.schoolName == "" ? "Gittiğiniz okul" : UserBloc.user!.schoolName,
          hintStyle: UserBloc.user!.schoolName == ""
              ? GoogleFonts.rubik(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 16,
                )
              : GoogleFonts.rubik(
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
            "Hangi üniversiteye veya okula gittiğinizi paylaşabilirsiniz..\n\n",
            style: GoogleFonts.rubik(fontSize: 14, color: Colors.grey[850]),
          ),
          Text(
            "#bestudent\n#beteacher\n#beastronaut",
            style: GoogleFonts.rubik(fontSize: 15, color: Colors.grey[850], fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

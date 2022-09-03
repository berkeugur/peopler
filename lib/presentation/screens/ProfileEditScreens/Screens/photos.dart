import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/others/classes/AppBars.dart';
import 'package:peopler/presentation/screens/ProfileEditScreens/Service/company_change_service.dart';
import 'package:peopler/presentation/screens/ProfileEditScreens/Service/photos_service.dart';
import 'package:peopler/presentation/screens/profile_edit/drag_drop_gridview.dart';

class ProfileEditPhotosScreen extends StatefulWidget {
  const ProfileEditPhotosScreen({Key? key}) : super(key: key);

  @override
  State<ProfileEditPhotosScreen> createState() => _ProfileEditPhotosScreenState();
}

class _ProfileEditPhotosScreenState extends State<ProfileEditPhotosScreen> with TickerProviderStateMixin {
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
      appBar: PeoplerAppBars(context: context).PROFILE_EDIT_ITEMS(
          title: "Fotoğraflar",
          function: () async {
            await PhotoService.saveChanges(context, _controller);
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
                DragDropGridView(),
                const Explanation(),
              ],
            ),
          ),
        ],
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
            "Fotoğraf paylaşarak profilinizi tamamlayın.\n\n",
            style: GoogleFonts.rubik(fontSize: 14, color: Colors.grey[850]),
          ),
          Text(
            "#beXXXX\n#beYYYY\n#beZZZZ",
            style: GoogleFonts.rubik(fontSize: 15, color: Colors.grey[850], fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

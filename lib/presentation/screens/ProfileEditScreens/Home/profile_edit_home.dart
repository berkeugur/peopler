import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/others/classes/AppBars.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/others/widgets/snack_bars.dart';
import 'package:peopler/presentation/screens/ProfileEditScreens/Home/menu_item.dart';
import 'package:peopler/presentation/screens/ProfileEditScreens/Home/profile_photo.dart';
import 'package:peopler/presentation/screens/profile/MyProfile/ProfileScreen/profile_screen.dart';

ValueNotifier<bool> setStateEditProfile = ValueNotifier(false);

class ProfileEditHome extends StatefulWidget {
  const ProfileEditHome({Key? key}) : super(key: key);

  @override
  State<ProfileEditHome> createState() => _ProfileEditHomeState();
}

class _ProfileEditHomeState extends State<ProfileEditHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Mode().homeScreenScaffoldBackgroundColor(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {});
        },
        child: const Icon(Icons.refresh),
      ),
      appBar: PeoplerAppBars(context: context).PROFILE_EDIT(),
      body: SingleChildScrollView(
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const ProfilePhotoEdit(),
              HomeItem(context: context, title: UserBloc.user!.displayName, subtitle: "Adınız", emptyText: "Adınız"),
              HomeItem(context: context, title: UserBloc.user!.biography, subtitle: "Kendiniz hakkında birkaç kelime ekleyin", emptyText: "Kendinizi Tanıtın"),
              HomeItem(context: context, title: UserBloc.user!.schoolName, subtitle: "Hangi okulda okuduğunuzdan bahsedin", emptyText: "Eğitim"),
              HomeItem(context: context, title: UserBloc.user!.currentJobName, subtitle: "Kısaca mesleğinizden bahsedin", emptyText: "Meslek"),
              HomeItem(context: context, title: UserBloc.user!.company, subtitle: "Çalıştığınız şirket", emptyText: "Şirket"),
              HomeItem(context: context, title: UserBloc.user!.city, subtitle: "Yaşadığınız şehir", emptyText: "Şehir"),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names

}

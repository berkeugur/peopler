import 'package:flutter/material.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/components/FlutterWidgets/app_bars.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/presentation/screens/PROFILE_EDIT/Home/menu_item.dart';
import 'package:peopler/presentation/screens/PROFILE_EDIT/Home/profile_photo.dart';
import 'package:peopler/presentation/screens/PROFILE_EDIT/Screens/biography_change.dart';
import 'package:peopler/presentation/screens/PROFILE_EDIT/Screens/city_change.dart';
import 'package:peopler/presentation/screens/PROFILE_EDIT/Screens/company_change.dart';
import 'package:peopler/presentation/screens/PROFILE_EDIT/Screens/education_change.dart';
import 'package:peopler/presentation/screens/PROFILE_EDIT/Screens/job_change.dart';
import 'package:peopler/presentation/screens/PROFILE_EDIT/Screens/name_change.dart';
import 'package:peopler/presentation/screens/PROFILE_EDIT/Screens/photos.dart';

ValueNotifier<bool> setStateEditProfile = ValueNotifier(false);

class ProfileEditHome extends StatefulWidget {
  const ProfileEditHome({Key? key}) : super(key: key);

  @override
  State<ProfileEditHome> createState() => _ProfileEditHomeState();
}

class _ProfileEditHomeState extends State<ProfileEditHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: setStateEditProfile,
        builder: (context, _, __) {
          return Scaffold(
            backgroundColor: Mode().homeScreenScaffoldBackgroundColor(),
            appBar: PeoplerAppBars(context: context).PROFILE_EDIT,
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const ProfilePhotoEdit(),
                  HomeItem(
                    context: context,
                    title: UserBloc.user!.displayName,
                    subtitle: "Adınız",
                    emptyText: "Adınız",
                    targetPage: const ProfileEditNameChangeScreen(),
                  ),
                  HomeItem(
                    context: context,
                    title: UserBloc.user!.biography,
                    subtitle: "Kendiniz hakkında birkaç kelime ekleyin",
                    emptyText: "Kendinizi Tanıtın",
                    targetPage: const ProfileEditBiographyChangeScreen(),
                  ),
                  HomeItem(
                    context: context,
                    title: UserBloc.user!.schoolName,
                    subtitle: "Hangi okulda okuduğunuzdan bahsedin",
                    emptyText: "Eğitim",
                    targetPage: const ProfileEditEducationChangeScreen(),
                  ),
                  HomeItem(
                    context: context,
                    title: UserBloc.user!.currentJobName,
                    subtitle: "Kısaca mesleğinizden bahsedin",
                    emptyText: "Meslek",
                    targetPage: const ProfileEditJobChangeScreen(),
                  ),
                  HomeItem(
                    context: context,
                    title: UserBloc.user!.company,
                    subtitle: "Çalıştığınız şirket",
                    emptyText: "Şirket",
                    targetPage: const ProfileEditCompanyChangeScreen(),
                  ),
                  HomeItem(
                    context: context,
                    title: UserBloc.user!.city,
                    subtitle: "Yaşadığınız şehir",
                    emptyText: "Şehir",
                    targetPage: const ProfileEditCityChangeScreen(),
                  ),
                  HomeItem(
                    context: context,
                    title: "Fotoğraflar",
                    subtitle: "Profilinize fotoğraflar ekleyin",
                    emptyText: "Fotoğraflar",
                    targetPage: const ProfileEditPhotosScreen(),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

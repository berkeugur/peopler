import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/presentation/screens/PROFILE_EDIT/Home/profile_edit_home.dart';
import 'package:peopler/presentation/screens/PROFILE/MyProfile/ProfileScreen/profile_screen.dart';
import 'package:peopler/components/FlutterWidgets/dialogs.dart';

class CompanyChangeService {
  static Future saveChanges(context, controller, _controller) async {
    FocusScope.of(context).unfocus();
    if (UserBloc.user != null) {
      if (UserBloc.user!.company != controller.text) {
        await FirebaseFirestore.instance.collection("users").doc(UserBloc.user!.userID).update({
          "company": controller.text,
        }).then((value) {
          UserBloc.user!.company = controller.text;
          Future.delayed(const Duration(milliseconds: 500), () {
            setStateEditProfile.value = !setStateEditProfile.value;
            setStateProfileScreen.value = !setStateProfileScreen.value;
          }).then(
            (value) {
              setStateEditProfile.value = !setStateEditProfile.value;
              setStateProfileScreen.value = !setStateProfileScreen.value;
            },
          );
          PeoplerDialogs.showSuccessfulDialog(context, _controller).then((value) => Navigator.of(context).pop());
        });
      } else {
        SnackBars(context: context).simple("Herhangi bir değişiklik yapmadınız!");
      }
    } else {
      SnackBars(context: context).simple("Hata Kodu: #00237855, support@peopler.app mail adresimize durumu açıklayan bir mail atarak yardım alabilirsiniz.");
    }
  }
}

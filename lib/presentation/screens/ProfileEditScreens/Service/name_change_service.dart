import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/presentation/screens/ProfileEditScreens/Home/profile_edit_home.dart';
import 'package:peopler/presentation/screens/profile/MyProfile/ProfileScreen/profile_screen.dart';
import 'package:peopler/ui/dialogs.dart';

class NameChangeService {
  static Future saveChanges(context, nameController, _controller) async {
    FocusScope.of(context).unfocus();
    if (UserBloc.user != null) {
      if (UserBloc.user!.displayName != nameController.text) {
        await FirebaseFirestore.instance.collection("users").doc(UserBloc.user!.userID).update({
          "displayName": nameController.text,
        }).then((value) {
          UserBloc.user!.displayName = nameController.text;
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
        print("değişen birşey yok");
      }
    } else {
      print("null user");
    }
  }
}

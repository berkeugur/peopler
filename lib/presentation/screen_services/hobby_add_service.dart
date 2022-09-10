import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:peopler/components/FlutterWidgets/dialogs.dart';
import 'package:peopler/data/model/HobbyModels/hobbies.dart';
import 'package:peopler/data/model/HobbyModels/hobby_suggest_model.dart';
import 'package:peopler/data/model/HobbyModels/hobbymodel.dart';
import 'package:peopler/presentation/screens/PROFILE/MyProfile/ProfileScreen/profile_screen.dart';

import '../../business_logic/blocs/UserBloc/user_bloc.dart';

class HobbyService {
  addNew({required BuildContext context, required String selectedValue, required List selectedSubHobbyIndex}) async {
    await FirebaseFirestore.instance.collection("users").doc(UserBloc.user!.userID).update(
      {
        "hobbies": FieldValue.arrayUnion(
          [
            HobbyModel(
              title: selectedValue,
              subtitles: List.generate(
                selectedSubHobbyIndex.length,
                (index) => Subtitles(
                  subtitle: Hobby().subHobby(Hobby().stringToHobbyTypesModel(selectedValue))![selectedSubHobbyIndex[index]],
                ),
              ),
            ).toJson(),
          ],
        ),
      },
    ).then(
      (value) {
        Navigator.of(context).pop();
        setStateProfileScreen.value = !setStateProfileScreen.value;
        Future.delayed(
          const Duration(milliseconds: 500),
          () {
            setStateProfileScreen.value = !setStateProfileScreen.value;
          },
        );
      },
    );
  }

  delete(BuildContext context, HobbyModel hobby) async {
    await FirebaseFirestore.instance.collection("users").doc(UserBloc.user!.userID).update({
      "hobbies": FieldValue.arrayRemove([hobby.toJson()])
    }).then(
      (value) {
        setStateProfileScreen.value = !setStateProfileScreen.value;
        Future.delayed(
          const Duration(milliseconds: 500),
          () {
            setStateProfileScreen.value = !setStateProfileScreen.value;
          },
        );
      },
    );
    ;
  }

  addSuggestion(
      {required TextEditingController controller,
      required String selectedValue,
      required BuildContext context,
      required AnimationController animationController}) async {
    DateFormat? dateFormat;
    DateFormat? timeFormat;
    if (dateFormat == null) {
      print("dateformat null");
      await initializeDateFormatting().then(
        (value) {
          dateFormat = DateFormat.yMMMMd('tr');
          timeFormat = DateFormat.Hms('tr');
        },
      );
    }

    if (controller.text.isNotEmpty) {
      await FirebaseFirestore.instance
          .collection("subhobbysuggestions")
          .doc()
          .set(
            HobbySuggestion(
              suggest: controller.text,
              createdDate: "${dateFormat?.format(Timestamp.now().toDate())} ~ ${timeFormat?.format(Timestamp.now().toDate())}",
              fromUserID: UserBloc.user?.userID.toString(),
              primaryHobby: selectedValue,
            ).toJson(),
          )
          .then((value) {
        controller.clear();
        Navigator.of(context).pop();
        PeoplerDialogs().showSuccessfulDialog(context, animationController);
      });
    }
  }
}

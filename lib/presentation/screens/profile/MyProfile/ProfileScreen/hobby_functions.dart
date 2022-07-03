import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/others/widgets/snack_bars.dart';
import 'package:peopler/presentation/screens/profile/MyProfile/ProfileScreen/profile_screen.dart';

addHobbyWithJustStartDate(context, selectedHobbyName, selectedStartYear, selectedStartMonth) async {
  // ignore: avoid_single_cascade_in_expression_statements
  FirebaseFirestore.instance.collection("users").doc(UserBloc.user!.userID)
    ..update({
      "hobbies": FieldValue.arrayUnion(["$selectedHobbyName%$selectedStartMonth%$selectedStartYear"])
    }).then((value) async {
      UserBloc.user!.hobbies.add("$selectedHobbyName%$selectedStartMonth%$selectedStartYear");

      Future.delayed(const Duration(milliseconds: 500), () {
        setStateValue.value = !setStateValue.value;
      }).then(
        (value) => setStateValue.value = !setStateValue.value,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
            context: context,
            title: "Başarıyla eklendi.",
            icon: Icons.done,
            textColor: const Color(0xFFFFFFFF),
            bgColor: Mode.isEnableDarkMode == true ? Color(0xFF0353EF) : const Color(0xFF000B21)),
      );
      Navigator.pop(context);
    }).onError(
      (error, stackTrace) {
        if (kDebugMode) {
          print("$error");
        }
      },
    );
}

addHobbyWithStartAndFinishDate(
    context, selectedHobbyName, selectedStartYear, selectedStartMonth, selectedFinishYear, selectedFinishMonth) {
  // ignore: avoid_single_cascade_in_expression_statements
  FirebaseFirestore.instance.collection("users").doc(UserBloc.user!.userID)
    ..update({
      "hobbies": FieldValue.arrayUnion(
          ["$selectedHobbyName%$selectedStartMonth%$selectedStartYear%$selectedFinishMonth%$selectedFinishYear"])
    }).then((value) async {
      UserBloc.user!.hobbies
          .add("$selectedHobbyName%$selectedStartMonth%$selectedStartYear%$selectedFinishMonth%$selectedFinishYear");
      Future.delayed(const Duration(milliseconds: 500), () {
        setStateValue.value = !setStateValue.value;
      }).then(
        (value) => setStateValue.value = !setStateValue.value,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
            context: context,
            title: "Başarıyla eklendi.",
            icon: Icons.done,
            textColor: const Color(0xFFFFFFFF),
            bgColor: Mode.isEnableDarkMode == true ? Color(0xFF0353EF) : const Color(0xFF000B21)),
      );
      Navigator.pop(context);
    }).onError(
      (error, stackTrace) {
        if (kDebugMode) {
          print("$error");
        }
      },
    );
}

int monthToInt(String month) {
  month = month.toLowerCase();
  switch (month) {
    case "ocak":
      return 1;
    case "şubat":
      return 2;
    case "mart":
      return 3;
    case "nisan":
      return 4;
    case "mayıs":
      return 5;
    case "haziran":
      return 6;
    case "temmuz":
      return 7;
    case "ağustos":
      return 8;
    case "eylül":
      return 9;
    case "ekim":
      return 10;
    case "kasım":
      return 11;
    case "aralık":
      return 12;
    default:
      return 99;
  }
}

deleteHobby(context, index, StateSetter setStateEditHobbyBottomSheet) {
  // ignore: avoid_single_cascade_in_expression_statements
  FirebaseFirestore.instance.collection("users").doc(UserBloc.user!.userID)
    ..update({
      "hobbies": FieldValue.arrayRemove([UserBloc.user!.hobbies[index]])
    }).then((value) async {
      UserBloc.user!.hobbies.removeAt(index);

      Future.delayed(const Duration(milliseconds: 500), () {
        setStateValue.value = !setStateValue.value;
      }).then(
        (value) => setStateValue.value = !setStateValue.value,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        customSnackBar(
            context: context,
            title: "Başarıyla silindi.",
            icon: Icons.done,
            textColor: const Color(0xFFFFFFFF),
            bgColor: Mode.isEnableDarkMode == true ? Color(0xFF0353EF) : const Color(0xFF000B21)),
      );

      setStateEditHobbyBottomSheet(() {});
    }).onError(
      (error, stackTrace) {
        if (kDebugMode) {
          print("$error");
        }
      },
    );
}

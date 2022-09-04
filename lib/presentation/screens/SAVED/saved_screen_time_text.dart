import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/data/model/saved_user.dart';
import '../../../business_logic/blocs/SavedBloc/saved_bloc.dart';
import '../../../others/classes/dark_light_mode_controller.dart';
import '../../../others/locator.dart';

Widget timeText(context, int index) {
  final Mode _mode = locator<Mode>();
  final SavedBloc _savedBloc = BlocProvider.of<SavedBloc>(context);

  SavedUser _savedUser = _savedBloc.allRequestList[index];
  if (_savedUser.isCountdownFinished == false) {
    DateTime countDownFinishTime = _savedUser.createdAt!.add(Duration(minutes: _savedUser.countDownDurationMinutes));
    Duration remainingTime = countDownFinishTime.difference(DateTime.now()); // 2880 minutes = 48 hours

    int remainingHour = remainingTime.inHours;
    int remainingMinute = remainingTime.inMinutes;

    return RichText(
        text: TextSpan(children: [
      TextSpan(
          style: const TextStyle(color: Color(0xFF0353EF), fontWeight: FontWeight.w400, fontFamily: "Roboto", fontStyle: FontStyle.normal, fontSize: 12.0),
          text: remainingMinute < 60 ? (remainingMinute).toStringAsFixed(0) + " dakika " : (remainingHour).toStringAsFixed(0) + " saat "),
      TextSpan(
          style:
              TextStyle(color: _mode.blackAndWhiteConversion(), fontWeight: FontWeight.w400, fontFamily: "Roboto", fontStyle: FontStyle.normal, fontSize: 12.0),
          text: "sonra aktif olur")
    ]));
  } else {
    DateTime countDownFinishTime = _savedUser.createdAt!.add(Duration(minutes: _savedUser.countDownDurationMinutes));
    DateTime deleteTime = countDownFinishTime.add(const Duration(minutes: 2880)); // 2880 minutes = 48 hours after countdown finished
    Duration remainingTime = deleteTime.difference(DateTime.now());

    int remainingHour = remainingTime.inHours;
    int remainingMinute = remainingTime.inMinutes;

    return RichText(
        text: TextSpan(children: [
      TextSpan(
          style: const TextStyle(color: Color(0xFFFF0000), fontWeight: FontWeight.w400, fontFamily: "Roboto", fontStyle: FontStyle.normal, fontSize: 12.0),
          text: remainingMinute < 60 ? (remainingMinute).toStringAsFixed(0) + " dakika " : (remainingHour).toStringAsFixed(0) + " saat "),
      TextSpan(
          style:
              TextStyle(color: _mode.blackAndWhiteConversion(), fontWeight: FontWeight.w400, fontFamily: "Roboto", fontStyle: FontStyle.normal, fontSize: 12.0),
          text: "içinde silinir")
    ]));
  }
}

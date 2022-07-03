import 'package:flutter/material.dart';

TextEditingController nameController = TextEditingController();
TextEditingController registerEmailController = TextEditingController();
TextEditingController registerPasswordController = TextEditingController();
TextEditingController registerPasswordCheckController = TextEditingController();
TextEditingController bioController = TextEditingController();
TextEditingController loginEmailController = TextEditingController();
TextEditingController loginPasswordController = TextEditingController();
TextEditingController resetPasswordController = TextEditingController();
TextEditingController verificationEMailController = TextEditingController();
TextEditingController feedController = TextEditingController();

bool isRememberMe = false;
bool isVisiblePassword = true;
bool isVisibleLoginPassword = true;
bool isVisibleCheckPassword = true;

var selectedCityIndex = 0;
bool isSelectedCityIndex = false;
var selectedCityIndex2 = 0;
bool isSelectedCityIndex2 = false;

int selectedIndex = 1;

double bottomMenuHeight = 50;
double menuItemHeight = 38;
double menuItemWidth = 54;
double menuItemBorderRadius = 19;

///feed share screen text field length
int customMaxLength = 140;

class Variables {
  static ValueNotifier<double> animatedContainerHeight = ValueNotifier(30);
  static ValueNotifier<double> animatedAppBarHeight = ValueNotifier(70);

  static ValueNotifier<double> animatedSearchPeopleHeaderHeight = ValueNotifier(80);

  static ValueNotifier<double> animatedNotificationsHeaderTop = ValueNotifier(70);
  static ValueNotifier<double> animatedNotificationHeaderBottom = ValueNotifier(50);
}

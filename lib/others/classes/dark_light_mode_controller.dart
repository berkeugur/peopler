import 'package:flutter/material.dart';

class Mode {
  static bool isEnableDarkMode = false;
  Color? alertColor = Colors.redAccent[700];

  ///dark mode => white
  ///light mode => black
  Color? blackAndWhiteConversion() {
    switch (isEnableDarkMode) {
      case false:
        {
          return Colors.black;
        }
      case true:
        {
          return Colors.white;
        }
    }
    return alertColor;
    /*
Mode().blackAndWhiteConversion()
    */
  }

  Color? whiteAndBlackConversion() {
    switch (isEnableDarkMode) {
      case false:
        {
          return Colors.black;
        }
      case true:
        {
          return Colors.white;
        }
    }
    return alertColor;
  }

  /*------------------------ScaffoldBackgroundColors------------------------*/
  Color? homeScreenScaffoldBackgroundColor() {
    switch (isEnableDarkMode) {
      case false:
        {
          return Colors.white;
        }
      case true:
        {
          return const Color(0xFF000B21);
        }
    }
    return alertColor;
  }

  Color? feedShareScreenScaffoldBackgroundColor() {
    switch (isEnableDarkMode) {
      case false:
        {
          return Colors.white;
        }
      case true:
        {
          return const Color(0xFF000B21);
        }
    }
    return alertColor;
  }

  // ignore: non_constant_identifier_names
  Color? search_peoples_scaffold_background() {
    switch (isEnableDarkMode) {
      case false:
        {
          return Colors.white;
        }
      case true:
        {
          return const Color(0xFF000B21);
        }
    }
    return alertColor;
  }
  /*------------------------ScaffoldBackgroundColors------------------------*/

  /*------------------------Bottom Menu Colors------------------------*/
  Color? bottomMenuBackground() {
    switch (isEnableDarkMode) {
      case false:
        {
          return Colors.white;
        }
      case true:
        {
          return const Color(0xFF000B21);
        }
    }
    return alertColor;
  }

  Color? enabledMenuItemBackground() {
    switch (isEnableDarkMode) {
      case false:
        {
          return const Color(0xFF0353EF);
        }
      case true:
        {
          return const Color(0xFF0353EF);
        }
    }
    return alertColor;
  }

  Color? disabledSelectedMenuItemBackground() {
    switch (isEnableDarkMode) {
      case false:
        {
          return Colors.transparent;
        }
      case true:
        {
          return Colors.transparent;
        }
    }
    return alertColor;
  }

  Color? enabledBottomMenuItemAssetColor() {
    switch (isEnableDarkMode) {
      case false:
        {
          return Colors.white;
        }
      case true:
        {
          return Colors.white;
        }
    }
    return alertColor;
  }

  Color? disabledBottomMenuItemAssetColor() {
    switch (isEnableDarkMode) {
      case false:
        {
          return const Color(0xFF0353EF);
        }
      case true:
        {
          return Colors.white;
        }
    }
    return alertColor;
  }

  Color? inActiveColor() {
    switch (isEnableDarkMode) {
      case false:
        {
          return const Color(0xFFC4C4C4);
        }
      case true:
        {
          return const Color(0xFFC4C4C4);
        }
    }
    return alertColor;
  }
  /*------------------------Bottom Menu Colors------------------------*/

  /*------------------------Home Screen Colors------------------------*/
  Color? homeScreenTitleColor() {
    switch (isEnableDarkMode) {
      case false:
        {
          return const Color(0xFF0353EF);
        }
      case true:
        {
          return Colors.white;
        }
    }
    return alertColor;
  }

  Color? homeScreenIconsColor() {
    switch (isEnableDarkMode) {
      case false:
        {
          return const Color(0xFF0353EF);
        }
      case true:
        {
          return Colors.white;
        }
    }
    return alertColor;
  }

  Color? homeScreenFeedBackgroundColor() {
    switch (isEnableDarkMode) {
      case false:
        {
          return Colors.white;
        }
      case true:
        {
          return const Color(0xFF000B21);
        }
    }
    return alertColor;
  }
  /*------------------------Home Screen Colors------------------------*/

  /*-----------------------------Feed Share Screen-----------------------------*/
  Color? feedShareScreenHintTextColor() {
    switch (isEnableDarkMode) {
      case false:
        {
          return const Color(0xFF000000);
        }
      case true:
        {
          return const Color(0xFFB3CBFA);
        }
    }
    return alertColor;
  }

  Color? feedShareScreenSnackBarBackground() {
    switch (isEnableDarkMode) {
      case false:
        {
          return const Color(0xFF0353EF);
        }
      case true:
        {
          return const Color(0xFFFFFFFF);
        }
    }
    return alertColor;
  }

  Color? feedShareScreenSnackBarTextColor() {
    switch (isEnableDarkMode) {
      case true:
        {
          return const Color(0xFF000B21);
        }
      case false:
        {
          return const Color(0xFFFFFFFF);
        }
    }
    return alertColor;
  }
  /*-----------------------------Feed Share Screen-----------------------------*/

/*-----------------------------------Settings screen-----------------------------------*/
  // ignore: non_constant_identifier_names
  Color? settings_ppl_photo_background() {
    switch (isEnableDarkMode) {
      case false:
        {
          return const Color(0xFF0353EF);
        }
      case true:
        {
          return Colors.white;
        }
    }
    return alertColor;
  }

  // ignore: non_constant_identifier_names
  Color? settings_ppl_photo_text() {
    switch (isEnableDarkMode) {
      case false:
        {
          return Colors.white;
        }
      case true:
        {
          return const Color(0xFF0353EF);
        }
    }
    return alertColor;
  }

  // ignore: non_constant_identifier_names
  Color? settings_ppl_user_name_text() {
    switch (isEnableDarkMode) {
      case false:
        {
          return const Color(0xFF000000);
        }
      case true:
        {
          return Colors.white;
        }
    }
    return alertColor;
  }

  // ignore: non_constant_identifier_names
  Color? settings_setting_title() {
    switch (isEnableDarkMode) {
      case false:
        {
          return const Color(0xFF000000);
        }
      case true:
        {
          return Colors.white;
        }
    }
    return alertColor;
  }

  // ignore: non_constant_identifier_names
  Color? settings_custom_1() {
    switch (isEnableDarkMode) {
      case false:
        {
          return const Color(0xFF0353EF);
        }
      case true:
        {
          return Colors.white;
        }
    }
    return alertColor;
  }

  // ignore: non_constant_identifier_names
  Color? settings_custom_2() {
    switch (isEnableDarkMode) {
      case false:
        {
          return const Color(0xFF000000);
        }
      case true:
        {
          return Colors.white;
        }
    }
    return alertColor;
  }

/*-----------------------------------Settings screen-----------------------------------*/
  Color? searchHeaderItemText() {
    switch (isEnableDarkMode) {
      case false:
        {
          return const Color(0xFF0353EF);
        }
      case true:
        {
          return const Color(0xFFFFFFFF);
        }
    }
    return alertColor;
  }

  Color searchItemGradientBgTop() {
    switch (isEnableDarkMode) {
      case false:
        {
          return const Color(0xFFD3E1FC);
        }
      case true:
        {
          return const Color(0xFF0353EF);
        }
    }
    return alertColor as Color;
  }

  Color searchItemGradientBgBottom() {
    switch (isEnableDarkMode) {
      case false:
        {
          return const Color(0xFFFFFFFF);
        }
      case true:
        {
          return const Color(0xFF000B21);
        }
    }
    return alertColor as Color;
  }

  Color? searchPageSavedIconBgColor() {
    switch (isEnableDarkMode) {
      case false:
        {
          return const Color(0xFF0353EF);
        }
      case true:
        {
          return const Color(0xFFFFFFFF);
        }
    }
    return alertColor;
  }

  Color searchPageCloseIconBorderColor() {
    switch (isEnableDarkMode) {
      case false:
        {
          return const Color(0xFF0353EF);
        }
      case true:
        {
          return const Color(0xFFFFFFFF);
        }
    }
    return alertColor as Color;
  }
}

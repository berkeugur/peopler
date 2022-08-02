import 'package:flutter/material.dart';
import 'package:peopler/presentation/screens/Settings/components/search_settings_field.dart';
import 'package:peopler/presentation/screens/Settings/components/security_settings_field.dart';
import 'package:peopler/presentation/screens/Settings/components/theme_settings_field.dart';

toggleSwitches(context, {required StateSetter setState}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20.0),
    child: Column(
      children: [
        //search_settings_field(context),
        //SizedBox(height: 20,),
        //security_settings_field(context),
        //SizedBox(height:20,),
        theme_settings_field(context),
      ],
    ),
  );
}

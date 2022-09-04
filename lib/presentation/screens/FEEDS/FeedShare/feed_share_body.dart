import 'package:flutter/material.dart';
import '../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../others/locator.dart';
import 'components/feed_share_text_field.dart';
import 'components/feed_share_max_line_error_text.dart';
import 'components/feed_share_header.dart';
import 'components/feed_share_profile_photo_and_name.dart';

SizedBox feedShareBody({required BuildContext context, required StateSetter setState}) {
  double safePadding = MediaQuery.of(context).padding.top;

  final Mode _mode = locator<Mode>();

  return SizedBox(
    height: MediaQuery.of(context).size.height - safePadding - 50,
    child: Column(
      children: [
        header(context),
        Divider(
          color: _mode.blackAndWhiteConversion()?.withOpacity(0.5),
          height: 0.2,
          thickness: 0.1,
        ),
        profilePhotoAndName(context),
        maxLineError(),
        TextFieldArea(setState, context),
      ],
    ),
  );
}

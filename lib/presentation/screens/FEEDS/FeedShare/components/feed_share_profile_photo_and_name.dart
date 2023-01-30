import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../../others/classes/responsive_size.dart';
import '../../../../../others/locator.dart';
import '../../../../../others/widgets/cached_network_error_image.dart';
import '../feed_share_functions.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';

Padding profilePhotoAndName(context) {
  final Mode _mode = locator<Mode>();
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(
      children: [
        InkWell(
          onTap: () => feed_share_profile_photo_on_pressed(),
          child: CachedNetworkImage(
            width: 60,
            height: 60,
            imageUrl: UserBloc.user!.profileURL,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                ClipRRect(borderRadius: BorderRadius.circular(999), child: CircularProgressIndicator(value: downloadProgress.progress)),
            errorWidget: (context, url, error) => cachedNetworkErrorImageWidget(UserBloc.user!.gender),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        LimitedBox(
          maxWidth: MediaQuery.of(context).size.width - 120,
          child: Text(
            UserBloc.user!.displayName,
            textScaleFactor: 1,
            style: PeoplerTextStyle.normal.copyWith(
              color: _mode.blackAndWhiteConversion(),
              fontSize: ResponsiveSize().fs4(context),
            ),
          ),
        ),
      ],
    ),
  );
}

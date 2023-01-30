import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/MessageBloc/bloc.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import '../../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../../others/locator.dart';
import '../../../../others/widgets/cached_network_error_image.dart';
import '../../SETTINGS/settings_page_functions.dart';
import '../message_screen_functions.dart';

Container messageScreenTopMenu(BuildContext context, AnimationController controller, String userID) {
  double _imageSize = 34;

  final Mode _mode = locator<Mode>();

  return Container(
    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
    color: _mode.bottomMenuBackground(),
    height: 60,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildBackArrow(context, _mode),
        const SizedBox(
          width: 15,
        ),
        Expanded(
          child: Row(
            children: [
              _buildProfilePhoto(_imageSize, context),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDisplayName(_mode, context),

                  //_buildOnlineStatus()
                ],
              ),
            ],
          ),
        ),
        _buildMoreIcon(_mode, context, controller, userID),
      ],
    ),
  );
}

Row _buildOnlineStatus() {
  return Row(
    children: [
      Container(
        height: 10,
        width: 10,
        margin: const EdgeInsets.only(right: 5),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(99),
        ),
      ),
      Text(
        "online/offline",
        textScaleFactor: 1,
        style: PeoplerTextStyle.normal.copyWith(fontSize: 12),
      ),
    ],
  );
}

InkWell _buildDisplayName(Mode _mode, context) {
  final MessageBloc _messageBloc = BlocProvider.of<MessageBloc>(context);
  return InkWell(
    onTap: () => op_settings_peopler_title(context, _messageBloc.currentChat!.hostID),
    child: Text(
      _messageBloc.currentChat!.hostUserName,
      textScaleFactor: 1,
      style: PeoplerTextStyle.normal.copyWith(color: _mode.homeScreenTitleColor(), fontWeight: FontWeight.w600, fontSize: 16),
    ),
  );
}

InkWell _buildProfilePhoto(double _imageSize, context) {
  final MessageBloc _messageBloc = BlocProvider.of<MessageBloc>(context);
  return InkWell(
    onTap: () => op_settings_ppl_photo(context, _messageBloc.currentChat!.hostID),
    child: Container(
        height: _imageSize,
        width: _imageSize,
        margin: const EdgeInsets.only(right: 15, left: 10),
        child: CachedNetworkImage(
          imageUrl: _messageBloc.currentChat!.hostUserProfileUrl,
          progressIndicatorBuilder: (context, url, downloadProgress) =>
              ClipRRect(borderRadius: BorderRadius.circular(999), child: CircularProgressIndicator(value: downloadProgress.progress)),
          errorWidget: (context, url, error) => cachedNetworkErrorImageWidget(_messageBloc.currentChat!.hostGender),
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
        )),
  );
}

InkWell _buildMoreIcon(Mode _mode, BuildContext context, AnimationController controller, String userID) {
  return InkWell(
    onTap: () => op_settings_message_icon(context, controller, userID),
    child: Icon(
      Icons.more_vert_outlined,
      size: 25,
      color: _mode.homeScreenIconsColor(),
    ),
  );
}

InkWell _buildBackArrow(context, Mode _mode) {
  final MessageBloc _messageBloc = BlocProvider.of<MessageBloc>(context);
  return InkWell(
    onTap: () async {
      // If virtual keyboard is visible
      if (MediaQuery.of(context).viewInsets.bottom != 0) {
        // Then, hide it
        FocusManager.instance.primaryFocus?.unfocus();
      } else {
        await popMessageScreen(context, _messageBloc.currentChat!.hostID);
      }
    },
    child: SizedBox(
      width: 20,
      height: 20,
      child: SvgPicture.asset(
        "assets/images/svg_icons/back_arrow.svg",
        width: 20,
        height: 20,
        color: _mode.homeScreenIconsColor(),
        fit: BoxFit.contain,
      ),
    ),
  );
}

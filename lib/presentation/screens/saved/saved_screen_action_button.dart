import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import '../../../business_logic/blocs/SavedBloc/saved_bloc.dart';
import '../../../business_logic/blocs/SavedBloc/saved_event.dart';
import '../../../data/send_notification_service.dart';
import '../../../data/services/db/firestore_db_service_users.dart';
import '../../../others/classes/dark_light_mode_controller.dart';
import '../../../others/locator.dart';
import '../../../others/strings.dart';

Widget actionButton(context, index, showWidgetsKeySaved) {
  final Mode _mode = locator<Mode>();
  final SavedBloc _savedBloc = BlocProvider.of<SavedBloc>(context);

  final SendNotificationService _sendNotificationService = locator<SendNotificationService>();
  final FirestoreDBServiceUsers _firestoreDBServiceUsers = locator<FirestoreDBServiceUsers>();

  Size _size = MediaQuery.of(context).size;

  if (_savedBloc.allRequestList[index].isCountdownFinished == false) {
    return Container(
      width: 104,
      height: 28,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: _mode.inActiveColor() as Color),
        color: Colors.transparent, //Colors.purple,
        borderRadius: const BorderRadius.all(Radius.circular(999)),
      ),
      child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                "assets/images/svg_icons/saved.svg",
                color: _mode.inActiveColor(),
                width: 12,
                height: 12,
                matchTextDirection: true,
                fit: BoxFit.contain,
              ),
              const SizedBox(
                width: 3,
              ),
              Text(
                "Bağlantı Kur",
                textScaleFactor: 1,
                style: GoogleFonts.rubik(
                  color: _mode.inActiveColor(),
                  fontSize: _size.width * 0.0391 > 12 ? 12 : _size.width * 0.0391,
                ),
              ),
            ],
          )),
    );
  } else {
    return   Container(
      width: 104,
      height: 28,
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: _mode.disabledBottomMenuItemAssetColor() as Color),
        color: Colors.transparent, //Colors.purple,
        borderRadius: const BorderRadius.all(Radius.circular(999)),
      ),
      child: Center(
          child: InkWell(
            onTap: () async {
              String _requestUserID = _savedBloc.allRequestList[index].userID;
              _savedBloc.add(ClickSendRequestButtonEvent(savedUser: _savedBloc.allRequestList[index], myUser: UserBloc.user!));
              _savedBloc.allRequestList.removeWhere((element) => element.userID == _requestUserID);
              showWidgetsKeySaved.currentState?.setState(() {

              });

              String _token = await _firestoreDBServiceUsers.getToken(_requestUserID);
              _sendNotificationService.sendNotification(Strings.sendRequest, _token, "", UserBloc.user!.displayName, UserBloc.user!.profileURL, UserBloc.user!.userID);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/svg_icons/saved.svg",
                  color: _mode.disabledBottomMenuItemAssetColor(),
                  width: 12,
                  height: 12,
                  matchTextDirection: true,
                  fit: BoxFit.contain,
                ),
                const SizedBox(
                  width: 3,
                ),
                Text(
                  "Bağlantı Kur",
                  textScaleFactor: 1,
                  style: GoogleFonts.rubik(
                    color: _mode.disabledBottomMenuItemAssetColor(),
                    fontSize: _size.width * 0.0391 > 12 ? 12 : _size.width * 0.0391,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}




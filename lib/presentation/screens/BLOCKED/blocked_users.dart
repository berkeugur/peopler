import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/components/FlutterWidgets/app_bars.dart';
import 'package:peopler/components/FlutterWidgets/dialogs.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/queries/queries.dart';
import 'package:peopler/core/constants/reloader/reload.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/others/classes/variables.dart';
import 'package:peopler/presentation/screen_services/report_service.dart';
import 'package:peopler/presentation/screens/SUBSCRIPTIONS/subscriptions_functions.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({Key? key}) : super(key: key);

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> getBlockedUsersData(List<String> blockedUserIDs) async {
    for (var blockedUserID in blockedUserIDs) {
      if (Variables.blockedUsersData.value.any((item) => item["userID"] == blockedUserID)) {
        printf("zaten bu kullanıcının verileri çekilmiş");
      } else {
        var blockedUserData = await FirebaseFirestore.instance.collection("users").doc(blockedUserID).get();
        Map<String, dynamic>? json = blockedUserData.data();
        if (json != null) {
          printf("kullanıcı bilgileri çekildi \nblockedUserData: ${Variables.blockedUsersData.value.toString().length}");
          Variables.blockedUsersData.value.add(json);
          printf("${json.toString().length} verileri blockedUsersData ya eklendi \nblockedUserData: ${Variables.blockedUsersData.value.toString().length}");
        } else {
          printf("kullanıcı bilgileri null ");
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Mode().homeScreenScaffoldBackgroundColor(),
        appBar: PeoplerAppBars(context: context).BLOCKED_USERS,
        body: ValueListenableBuilder(
            valueListenable: Reloader.isUnBlocked,
            builder: (context, _, __) {
              return FutureBuilder(
                future: getBlockedUsersData(UserBloc.user?.blockedUsers ?? []),
                builder: (context, snapshot) {
                  if (snapshot.hasData || snapshot.connectionState == ConnectionState.done) {
                    return (UserBloc.user?.blockedUsers.length == null || UserBloc.user?.blockedUsers.length == 0)
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(40.0),
                              child: Text(
                                "Engellenmiş kullanıcı bulunmamaktadır.",
                                textAlign: TextAlign.center,
                                textScaleFactor: 1,
                                style: PeoplerTextStyle.normal.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                        : ListView.separated(
                            separatorBuilder: (context, index) {
                              return Divider(
                                color: Mode().blackAndWhiteConversion(),
                              );
                            },
                            shrinkWrap: true,
                            itemCount: UserBloc.user?.blockedUsers.length ?? 0,
                            itemBuilder: (context, index) {
                              //Burada kaldık Userblock user blockuserdaki userları göstermemiz lazım sadece ama çektiğimiz her userı gösteriyor şu anda
                              //user block usredaki user id lerden biri eğer blockedUsersData içerisinde var ise blocked users data dan verileri çekip göstermemiz gerekiyor.
                              int customIndex =
                                  Variables.blockedUsersData.value.indexWhere((element) => element["userID"] == UserBloc.user?.blockedUsers[index]);
                              var data = Variables.blockedUsersData.value[customIndex];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0,
                                ),
                                child: ListTile(
                                  trailing: IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                          contentPadding: const EdgeInsets.only(top: 20.0, bottom: 5, left: 25, right: 25),
                                          content: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                "${data["displayName"]} kullanıcısının engelini kalırmak üzeresiniz.",
                                                textAlign: TextAlign.center,
                                                style: PeoplerTextStyle.normal.copyWith(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              const Divider(),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              InkWell(
                                                onTap: () async {
                                                  await BlockAndReportService().unblockUser(blockUserID: data["userID"]).then((values) async {
                                                    //Reloader.isUnBlocked.value = !Reloader.isUnBlocked.value;
                                                    Navigator.of(context).pop();
                                                    await PeoplerDialogs().showSuccessfulDialog(context, _controller);
                                                  });
                                                  //Reloader.isUnBlocked.value = !Reloader.isUnBlocked.value;
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(999),
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 30,
                                                    vertical: 10,
                                                  ),
                                                  child: Text(
                                                    "Engeli Kaldır",
                                                    style: PeoplerTextStyle.normal.copyWith(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () => Navigator.of(context).pop(),
                                                child: Text(
                                                  "İPTAL",
                                                  style: PeoplerTextStyle.normal.copyWith(
                                                    color: Theme.of(context).primaryColor,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(
                                      Icons.lock_open,
                                      color: Color(0xFF0353EF),
                                    ),
                                  ),
                                  subtitle: Text(
                                    data["biography"] ?? "error biography",
                                    style: PeoplerTextStyle.normal.copyWith(
                                      color: Mode().blackAndWhiteConversion(),
                                    ),
                                  ),
                                  title: Text(
                                    data["displayName"] ?? "error display name",
                                    style: PeoplerTextStyle.normal.copyWith(
                                      color: Mode().blackAndWhiteConversion(),
                                    ),
                                  ),
                                  leading: SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: CachedNetworkImage(
                                      imageUrl: data["profileURL"] ?? 'https://www.clipartmax.com/png/middle/296-2969961_no-image-user-profile-icon.png',
                                      progressIndicatorBuilder: (context, url, downloadProgress) => ClipRRect(
                                          borderRadius: BorderRadius.circular(999), child: CircularProgressIndicator(value: downloadProgress.progress)),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                      imageBuilder: (context, imageProvider) => Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            }));
  }
}

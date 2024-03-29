import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'package:peopler/components/FlutterWidgets/gallery.dart';
import 'package:peopler/components/FlutterWidgets/snack_bars.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/data/model/activity.dart';
import 'package:peopler/data/model/HobbyModels/hobbymodel.dart';
import 'package:peopler/data/model/HobbyModels/hobbies.dart';
import 'package:peopler/presentation/screens/CONNECTIONS/connections.dart';
import 'package:peopler/presentation/screens/PROFILE_EDIT/Home/profile_edit_home.dart';
import 'package:peopler/presentation/screens/PROFILE/MyProfile/AllActivityListScreen/all_activity_list.dart';
import 'package:peopler/presentation/screens/PROFILE/MyProfile/ProfileScreen/hobby_functions.dart';
import '../../../../../data/model/user.dart';
import '../../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../../others/locator.dart';
import '../../../../../others/strings.dart';

class ProfileScreenComponentsMyProfile {
  final Mode _mode = locator<Mode>();
  final MyUser profileData = UserBloc.user!;

  nameField() {
    return Text(
      profileData.isProfileVisible == true ? profileData.displayName : profileData.pplName!,
      textScaleFactor: 1,
      style: PeoplerTextStyle.normal.copyWith(color: _mode.blackAndWhiteConversion(), fontSize: 18, fontWeight: FontWeight.w500),
    );
  }

  biographyField(context, String biography) {
    double _width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: Text(
                  "Hakkında",
                  textScaleFactor: 1,
                  style: PeoplerTextStyle.normal.copyWith(
                    color: _mode.blackAndWhiteConversion(),
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: Mode().homeScreenScaffoldBackgroundColor(),
              boxShadow: <BoxShadow>[
                BoxShadow(color: const Color(0xFF939393).withOpacity(0.6), blurRadius: 0.5, spreadRadius: 0, offset: const Offset(0, 0))
              ],
            ),
            child: Text(
              biography,
              textScaleFactor: 1,
              style: PeoplerTextStyle.normal.copyWith(
                fontSize: 15,
                color: Mode().blackAndWhiteConversion(),
                fontWeight: FontWeight.w300,
              ),
            )

            //ExpandableText(text: profileData.biography, max: 0.5,),
            ),
      ],
    );
  }

  photos(context, List<String> photos, photoURL) {
    Size _size = MediaQuery.of(context).size;
    double _screenWidth = _size.width;

    double _photoHeight = photos.length >= 3 ? _screenWidth / 3.5 : _screenWidth / 2.8;
    double _photoRatio = 4 / 3;
    double _photoWidth = _photoHeight * _photoRatio;
    double _photoPadding = 2.5;

    double width = MediaQuery.of(context).size.width / 2;
    double height = MediaQuery.of(context).size.width / 2 / 4 * 3;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        photos.isEmpty
            ? Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () => PeoplerGallery().openGallery(
                            context: context,
                            images: ["assets/profile_banners/banner1.png", "assets/profile_banners/banner2.png"],
                            currentIndex: 0,
                            isNetworkImage: false),
                        child: Container(
                          height: _photoHeight,
                          width: _photoWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.5),
                            color: Colors.grey[400],
                          ),
                          margin: const EdgeInsets.only(left: 5, right: 2.5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7.5),
                            child: Image.asset(
                              "assets/profile_banners/banner1.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => PeoplerGallery().openGallery(
                            context: context,
                            images: ["assets/profile_banners/banner1.png", "assets/profile_banners/banner2.png"],
                            currentIndex: 1,
                            isNetworkImage: false),
                        child: Container(
                          height: _photoHeight,
                          width: _photoWidth,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.5),
                            color: Colors.grey[400],
                          ),
                          margin: const EdgeInsets.only(left: 2.5, right: 5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7.5),
                            child: Image.asset(
                              "assets/profile_banners/banner2.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox.square(
                    dimension: photos.length >= 3 ? _photoHeight / 2 : _photoHeight / 3,
                  ),
                ],
              )
            : photos.length == 1
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => PeoplerGallery().openGallery(context: context, images: photos, currentIndex: 0, isNetworkImage: true),
                            child: Container(
                              height: _photoHeight,
                              width: _photoWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.5),
                                color: Colors.grey[400],
                              ),
                              margin: const EdgeInsets.only(left: 5, right: 2.5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(7.5),
                                child: CachedNetworkImage(
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7.5),
                                      image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                    ),
                                  ),
                                  imageUrl: photos.first,
                                  progressIndicatorBuilder: (context, url, downloadProgress) => ClipRRect(
                                      borderRadius: BorderRadius.circular(7.5), child: LinearProgressIndicator(value: downloadProgress.progress)),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => PeoplerGallery().openGallery(
                                context: context, images: ["assets/profile_banners/banner1.png"], currentIndex: 0, isNetworkImage: false),
                            child: Container(
                              height: _photoHeight,
                              width: _photoWidth,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7.5),
                                color: Colors.grey[400],
                              ),
                              margin: const EdgeInsets.only(left: 2.5, right: 5),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(7.5),
                                child: Image.asset(
                                  "assets/profile_banners/banner1.png",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox.square(
                        dimension: photos.length >= 3 ? _photoHeight / 2 : _photoHeight / 3,
                      ),
                    ],
                  )
                : horizontalPhotoList(context, photos),
        profilePhoto(context, photoURL),
      ],
    );
  }

  profilePhoto(context, String photoURL) {
    Size _size = MediaQuery.of(context).size;
    double _screenWidth = _size.width;
    double _photoSize = _screenWidth / 3.4;
    return InkWell(
      onTap: () => PeoplerGallery().openGallery(context: context, images: [photoURL], currentIndex: 0, isNetworkImage: true),
      child: Stack(
        children: [
          Container(
            height: _photoSize,
            width: _photoSize,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  width: 5,
                  color: _mode.search_peoples_scaffold_background() as Color,
                )),
            child: const CircleAvatar(
              backgroundColor: Color(0xFF0353EF),
              child: Text(
                "ppl",
                textScaleFactor: 1,
              ),
            ),
          ),
          Container(
            height: _photoSize,
            width: _photoSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 5,
                color: _mode.search_peoples_scaffold_background() as Color,
              ),
            ),
            child: //_userBloc != null ?
                CachedNetworkImage(
              imageUrl: photoURL,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                ),
              ),
              progressIndicatorBuilder: (context, url, downloadProgress) => CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ],
      ),
    );
  }

  horizontalPhotoList(context, List<String> photos) {
    Size _size = MediaQuery.of(context).size;
    double _screenWidth = _size.width;

    double _photoHeight = photos.length >= 3 ? _screenWidth / 3.5 : _screenWidth / 2.8;
    double _photoRatio = 4 / 3;
    double _photoWidth = _photoHeight * _photoRatio;
    double _photoPadding = 2.5;

    int _numberOfPhoto = 4;
    ValueNotifier<int> _itemCount = ValueNotifier(photos.length > _numberOfPhoto ? _numberOfPhoto + 1 : photos.length);

    BorderRadius _customBorderRadius() => BorderRadius.circular(7.5);
    return ValueListenableBuilder(
        valueListenable: _itemCount,
        builder: (context, value, _) {
          return Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: _photoHeight,
                child: Align(
                  alignment: photos.length != 1 ? Alignment.center : Alignment.centerLeft,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    //i use +1 because last index for less more see more widget
                    itemCount: _itemCount.value,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    itemBuilder: (context, index) {
                      return index == _itemCount.value - 1 && _itemCount.value == _numberOfPhoto + 1
                          ? Container(
                              height: _photoHeight,
                              width: _photoWidth,
                              child: Center(
                                child: TextButton(
                                  onPressed: () {
                                    _itemCount.value == _numberOfPhoto + 1
                                        ? _itemCount.value = photos.length + 1
                                        : _itemCount.value = _numberOfPhoto + 1;
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.add,
                                        size: 21,
                                        color: _mode.blackAndWhiteConversion(),
                                      ),
                                      Text(
                                        "see more",
                                        textScaleFactor: 1,
                                        style: PeoplerTextStyle.normal.copyWith(
                                          color: _mode.blackAndWhiteConversion(),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ))
                          : index == _itemCount.value - 1 && _itemCount.value == photos.length + 1
                              ? Container(
                                  height: _photoHeight,
                                  width: _photoWidth,
                                  child: Center(
                                    child: TextButton(
                                      onPressed: () {
                                        _itemCount.value == _numberOfPhoto + 1
                                            ? _itemCount.value = photos.length + 1
                                            : _itemCount.value = _numberOfPhoto + 1;
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.add,
                                            size: 21,
                                            color: _mode.blackAndWhiteConversion(),
                                          ),
                                          Text(
                                            "less more",
                                            textScaleFactor: 1,
                                            style: PeoplerTextStyle.normal.copyWith(
                                              color: _mode.blackAndWhiteConversion(),
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ))
                              : InkWell(
                                  onTap: () =>
                                      PeoplerGallery().openGallery(context: context, images: photos, currentIndex: index, isNetworkImage: true),
                                  child: Container(
                                    height: _photoHeight,
                                    width: _photoWidth,
                                    decoration: BoxDecoration(
                                      borderRadius: _customBorderRadius(),
                                      color: Colors.grey[400],
                                    ),
                                    margin: EdgeInsets.only(
                                        left: index == 0 && photos.length >= 3
                                            ? 5
                                            : photos.length == 1
                                                ? 10
                                                : _photoPadding,
                                        right: _photoPadding),
                                    child: ClipRRect(
                                      borderRadius: _customBorderRadius(),
                                      child: CachedNetworkImage(
                                        imageBuilder: (context, imageProvider) => Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(7.5),
                                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                          ),
                                        ),
                                        imageUrl: photos[index],
                                        progressIndicatorBuilder: (context, url, downloadProgress) => ClipRRect(
                                            borderRadius: BorderRadius.circular(7.5),
                                            child: LinearProgressIndicator(value: downloadProgress.progress)),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                    ),
                                  ),
                                );
                    },
                  ),
                ),
              ),
              SizedBox.square(
                dimension: photos.length >= 3 ? _photoHeight / 2 : _photoHeight / 3,
              ),
            ],
          );
        });
  }

  locationText() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.location_on_outlined,
          size: 21,
          color: _mode.blackAndWhiteConversion(),
        ),
        Text(
          "${profileData.city}",
          textScaleFactor: 1,
          style: PeoplerTextStyle.normal.copyWith(
            color: _mode.blackAndWhiteConversion(),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  profileEditButton(context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      height: 30,
      child: Center(
        child: InkWell(
          onTap: () {
            UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
            _userBloc.mainKey.currentState?.push(MaterialPageRoute(builder: (context) => const ProfileEditHome()));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(2.5),
                child: SvgPicture.asset(
                  "assets/images/svg_icons/edit.svg",
                  color: Mode().blackAndWhiteConversion(),
                  matchTextDirection: true,
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                "Profili Düzenle",
                textScaleFactor: 1,
                style: PeoplerTextStyle.normal.copyWith(color: Mode().blackAndWhiteConversion(), fontSize: 14),
              ),
              const SizedBox.square(
                dimension: 5,
              )
            ],
          ),
        ),
      ),
    );
  }

  connections(context) {
    return Center(
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(99),
            onTap: () {
              UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
              _userBloc.mainKey.currentState?.push(MaterialPageRoute(builder: (context) => const ConnectionsScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 5,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people,
                    color: Colors.grey[500],
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  UserBloc.user!.connectionUserIDs.isNotEmpty
                      ? Text(
                          "${UserBloc.user!.connectionUserIDs.length} bağlantı",
                          textScaleFactor: 1,
                          style: PeoplerTextStyle.normal.copyWith(
                            color: Colors.grey[500],
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 3,
          ),

          /*
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                color: Colors.transparent, //Colors.pinkAccent,
                child: Center(
                  child: Stack(
                    children: [
                      profileData.mutualConnectionsProfilePhotos.length >= 3 ? mutualFriendProfilePhotoItem(context, 0, profileData.mutualConnectionsProfilePhotos[2]) : const SizedBox(),
                      profileData.mutualConnectionsProfilePhotos.length >= 2 ? mutualFriendProfilePhotoItem(context, 1, profileData.mutualConnectionsProfilePhotos[1]) : const SizedBox(),
                      profileData.mutualConnectionsProfilePhotos.isNotEmpty  ? mutualFriendProfilePhotoItem(context, 2, profileData.mutualConnectionsProfilePhotos[0]) : const SizedBox(),
                    ],
                  ),
                ),
              ),
              Text(
                profileData.mutualConnectionsProfilePhotos.length > 3 ? "  +${profileData.mutualConnectionsProfilePhotos.length-3}" : "", //+0 bağlantı hatasını önlemek için.
                textScaleFactor: 1,
                style: PeoplerTextStyle.normal.copyWith(fontSize: _customSmallTextSize(), color:  Color(0xFF0353EF)),
              ),
            ],
          ),
           */
        ],
      ),
    );
  }

  Row buildLike(index, List<MyActivity> activities) {
    return Row(
      children: [
        SvgPicture.asset(
          "assets/images/svg_icons/up_arrow.svg",
          color: Colors.green,
          fit: BoxFit.contain,
        ),
        //build   },
        //),
        const SizedBox(
          width: 5,
        ),

        Text(
          activities[index].liked.toString(),
          textScaleFactor: 1,
          style: PeoplerTextStyle.normal.copyWith(
            color: _mode.blackAndWhiteConversion(),
          ),
        )
      ],
    );
  }

  Row buildDislike(int index, List<MyActivity> activities) {
    return Row(
      children: [
        SizedBox(
            height: 20,
            width: 20,
            child: SvgPicture.asset(
              "assets/images/svg_icons/down_arrow.svg",
              color: _mode.blackAndWhiteConversion(),
              fit: BoxFit.contain,
            )),
        const SizedBox(
          width: 5,
        ),
        Text(
          activities[index].disliked.toString(),
          textScaleFactor: 1,
          style: PeoplerTextStyle.normal.copyWith(
            color: _mode.blackAndWhiteConversion(),
          ),
        ),
      ],
    );
  }

  activityList(BuildContext context, List<MyActivity> activities) {
    int minNumberOfActivity = 1;
    ValueNotifier<int> numberOfActivity = ValueNotifier(minNumberOfActivity + 1); //profileData.experiences.length+1;

    return activities.isEmpty
        ? const SizedBox.shrink()
        : ValueListenableBuilder(
            valueListenable: numberOfActivity,
            builder: (context, snapshot, _) {
              numberOfActivity.value;
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Text(
                      "Hareketler",
                      textScaleFactor: 1,
                      style: PeoplerTextStyle.normal.copyWith(
                        color: _mode.blackAndWhiteConversion(),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      //i use +1 because last index for less more see more widget
                      itemCount: numberOfActivity.value,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (index == numberOfActivity.value - 1) {
                          return InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (contextSD) => AlertDialog(
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(32.0))),
                                  contentPadding: const EdgeInsets.only(top: 20.0, bottom: 5, left: 25, right: 25),
                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Yakında...",
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
                                        onTap: () {
                                          Navigator.of(contextSD).pop();
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
                                            "TAMAM",
                                            style: PeoplerTextStyle.normal.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                              /*
                             
                              

                          
                              UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
                              _userBloc.mainKey.currentState?.push(
                                MaterialPageRoute(builder: (context) => AllActivityListMyProfile(profileData: profileData, myActivities: activities)),
                              );
 */
                              debugPrint("çalıştı .........");
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: _mode.bottomMenuBackground(),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: const Color(0xFF939393).withOpacity(0.6), blurRadius: 0.5, spreadRadius: 0, offset: const Offset(0, 0))
                                ],
                                //border: Border.symmetric(horizontal: BorderSide(color: _mode.blackAndWhiteConversion() as Color,width: 0.2, style: BorderStyle.solid,))
                              ),
                              child: Center(
                                  child: Text(
                                "Daha Fazla Göster",
                                textScaleFactor: 1,
                                style: PeoplerTextStyle.normal.copyWith(color: _mode.blackAndWhiteConversion(), fontSize: 16),
                              )),
                            ),
                          );
                        } else {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: _mode.bottomMenuBackground(),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: const Color(0xFF939393).withOpacity(0.6), blurRadius: 0.5, spreadRadius: 0, offset: const Offset(0, 0))
                              ],
                              //border: Border.symmetric(horizontal: BorderSide(color: _mode.blackAndWhiteConversion() as Color,width: 0.2, style: BorderStyle.solid,))
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      profileData.pplName!,
                                      textScaleFactor: 1,
                                      style: PeoplerTextStyle.normal
                                          .copyWith(fontSize: 14, color: _mode.blackAndWhiteConversion(), fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      " " + activityText(index, UserBloc.myActivities),
                                      textScaleFactor: 1,
                                      style: PeoplerTextStyle.normal
                                          .copyWith(fontSize: 14, color: _mode.blackAndWhiteConversion(), fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                ),
                                MediaQuery.of(context).size.width < 320
                                    ? const SizedBox.shrink()
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          buildDislike(index, activities),
                                          SizedBox(
                                            width: MediaQuery.of(context).size.width < 600 ? MediaQuery.of(context).size.width * 0.05 : 600 * 0.05,
                                          ),
                                          buildLike(index, activities),
                                        ],
                                      ),
                              ],
                            ),
                          );
                        }
                      }),
                ],
              );
            });
  }

  experiencesList(BuildContext context) {
    int minNumberOfExperience = 3;
    ValueNotifier<int> numberOfExperience = profileData.hobbies.length < ValueNotifier(minNumberOfExperience + 1).value
        ? ValueNotifier(profileData.hobbies.length)
        : ValueNotifier(minNumberOfExperience + 1); //profileData.experiences.length+1;
    double _photoSize = 50;

    return ValueListenableBuilder(
        valueListenable: numberOfExperience,
        builder: (context, snapshot, _) {
          numberOfExperience.value;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Deneyimler",
                      textScaleFactor: 1,
                      style: PeoplerTextStyle.normal.copyWith(
                        color: _mode.blackAndWhiteConversion(),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    addNewHobbyIconButton(context)
                  ],
                ),
              ),
              profileData.hobbies.isEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        color: _mode.bottomMenuBackground(),
                        boxShadow: <BoxShadow>[
                          BoxShadow(color: const Color(0xFF939393).withOpacity(0.6), blurRadius: 0.5, spreadRadius: 0, offset: const Offset(0, 0))
                        ],
                        //border: Border.symmetric(horizontal: BorderSide(color: _mode.blackAndWhiteConversion() as Color,width: 0.2, style: BorderStyle.solid,))
                      ),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                          child: Text("Hiç hobiniz bulunmuyor.\nHobilerinizi ekleyerek profilinizi tamamlayabilirsiniz.",
                              textScaleFactor: 1,
                              style: PeoplerTextStyle.normal
                                  .copyWith(fontSize: 16, color: Mode().blackAndWhiteConversion(), fontWeight: FontWeight.w300))),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.vertical,
                      //i use +1 because last index for less more see more widget
                      itemCount: numberOfExperience.value,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(parent: BouncingScrollPhysics()),
                      itemBuilder: (context, index) {
                        if (profileData.hobbies.length > numberOfExperience.value && index == numberOfExperience.value - 1) {
                          return InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  context: context,
                                  backgroundColor: Mode().homeScreenScaffoldBackgroundColor(),
                                  builder: (context) {
                                    return StatefulBuilder(builder: (context, setStateEditHobbyBottomSheet) {
                                      return ListView.builder(
                                          itemCount: UserBloc.user!.hobbies.length,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (BuildContext context, int index) {
                                            return ListTile(
                                              leading: MediaQuery.of(context).size.width < 320
                                                  ? const SizedBox.shrink()
                                                  : Stack(
                                                      children: [
                                                        Container(
                                                          height: 50,
                                                          width: 50,
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(999),
                                                              border: Border.all(
                                                                width: 1,
                                                                color: _mode.search_peoples_scaffold_background() as Color,
                                                              )),
                                                          child: CircleAvatar(
                                                            backgroundColor: const Color(0xFF0353EF),
                                                            child: Text("ppl$index",
                                                                textScaleFactor: 1, style: PeoplerTextStyle.normal.copyWith(fontSize: 12)),
                                                          ),
                                                        ),
                                                        Container(
                                                            height: 50,
                                                            width: 50,
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius.circular(999),
                                                                border: Border.all(
                                                                  width: 1,
                                                                  color: _mode.search_peoples_scaffold_background() as Color,
                                                                )),
                                                            child: hobbyItem(0, "da2332")),
                                                      ],
                                                    ),
                                              title: Text("123ş",
                                                  textScaleFactor: 1,
                                                  style: PeoplerTextStyle.normal.copyWith(color: Mode().blackAndWhiteConversion())),
                                              subtitle: Text(
                                                "123222",
                                                textScaleFactor: 1,
                                                style: PeoplerTextStyle.normal.copyWith(color: _mode.blackAndWhiteConversion(), fontSize: 14),
                                              ),
                                            );
                                          });
                                    });
                                  });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: _mode.bottomMenuBackground(),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: const Color(0xFF939393).withOpacity(0.6), blurRadius: 0.5, spreadRadius: 0, offset: const Offset(0, 0))
                                ],
                                //border: Border.symmetric(horizontal: BorderSide(color: _mode.blackAndWhiteConversion() as Color,width: 0.2, style: BorderStyle.solid,))
                              ),
                              child: Center(
                                  child: Text(
                                numberOfExperience.value == minNumberOfExperience + 1 ? "Daha Fazla Göster" : "Daha Az Göster",
                                textScaleFactor: 1,
                                style: PeoplerTextStyle.normal.copyWith(color: _mode.blackAndWhiteConversion(), fontSize: 16),
                              )),
                            ),
                          );
                        } else {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            decoration: BoxDecoration(
                              color: _mode.bottomMenuBackground(),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                    color: const Color(0xFF939393).withOpacity(0.6), blurRadius: 0.5, spreadRadius: 0, offset: const Offset(0, 0))
                              ],
                              //border: Border.symmetric(horizontal: BorderSide(color: _mode.blackAndWhiteConversion() as Color,width: 0.2, style: BorderStyle.solid,))
                            ),
                            child: Row(
                              children: [
                                MediaQuery.of(context).size.width < 320
                                    ? const SizedBox.shrink()
                                    : Stack(
                                        children: [
                                          Container(
                                            height: _photoSize,
                                            width: _photoSize,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(999),
                                                border: Border.all(
                                                  width: 1,
                                                  color: _mode.search_peoples_scaffold_background() as Color,
                                                )),
                                            child: CircleAvatar(
                                              backgroundColor: const Color(0xFF0353EF),
                                              child: Text("ppl$index", textScaleFactor: 1, style: PeoplerTextStyle.normal.copyWith(fontSize: 12)),
                                            ),
                                          ),
                                          Container(
                                              height: _photoSize,
                                              width: _photoSize,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(999),
                                                  border: Border.all(
                                                    width: 1,
                                                    color: _mode.search_peoples_scaffold_background() as Color,
                                                  )),
                                              child: hobbyItem(0, "asd22f4")),
                                        ],
                                      ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      HobbyModel.fromJson(profileData.hobbies[index]).subtitles?.first.subtitle ?? "null",
                                      textScaleFactor: 1,
                                      style: PeoplerTextStyle.normal
                                          .copyWith(color: _mode.blackAndWhiteConversion(), fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "denem#1111",
                                          textScaleFactor: 1,
                                          style: PeoplerTextStyle.normal.copyWith(color: _mode.blackAndWhiteConversion(), fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          );
                        }
                      }),
            ],
          );
        });
  }

  Widget addNewHobbyIconButton(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              String? selectedHobbyName;
              String? selectedStartYear;
              String? selectedStartMonth;
              String? selectedFinishYear;
              String? selectedFinishMonth;
              bool isChecked = true;

              Duration _duration = const Duration(milliseconds: 600);

              showDialog(
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setStateAddHobbyDialog) {
                      return AlertDialog(
                        contentPadding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
                        backgroundColor: Mode().homeScreenScaffoldBackgroundColor(),
                        title: Text("Yeni Hobi Ekle",
                            textScaleFactor: 1, style: PeoplerTextStyle.normal.copyWith(color: Mode().blackAndWhiteConversion())),
                        content: AnimatedContainer(
                          margin: EdgeInsets.zero,
                          duration: _duration,
                          height: isChecked ? 192 : 288,
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                DropdownButton<String>(
                                  alignment: AlignmentDirectional.centerStart,
                                  dropdownColor: Mode().homeScreenScaffoldBackgroundColor(),
                                  hint: Text(selectedHobbyName == null ? "Hobi Seçiniz" : selectedHobbyName!,
                                      textScaleFactor: 1, style: PeoplerTextStyle.normal.copyWith(color: Mode().blackAndWhiteConversion())),
                                  items: Hobby().hobbiesNameList().map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          textScaleFactor: 1, style: PeoplerTextStyle.normal.copyWith(color: Mode().blackAndWhiteConversion())),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setStateAddHobbyDialog(() {
                                      selectedHobbyName = newValue!;
                                    });
                                  },
                                ),
                                DropdownButton<String>(
                                  dropdownColor: Mode().homeScreenScaffoldBackgroundColor(),
                                  hint: Text(selectedStartYear == null ? "Başladığınız yılı seçin" : selectedStartYear.toString(),
                                      textScaleFactor: 1, style: PeoplerTextStyle.normal.copyWith(color: Mode().blackAndWhiteConversion())),
                                  items: List.generate(60, (index) {
                                    return (1962 + index).toString();
                                  }).map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          textScaleFactor: 1, style: PeoplerTextStyle.normal.copyWith(color: Mode().blackAndWhiteConversion())),
                                    );
                                  }).toList(),
                                  onChanged: (String? newStartYearValue) {
                                    setStateAddHobbyDialog(() {
                                      selectedStartYear = newStartYearValue!;
                                    });
                                  },
                                ),
                                DropdownButton<String>(
                                  dropdownColor: Mode().homeScreenScaffoldBackgroundColor(),
                                  hint: Text(selectedStartMonth == null ? "Başladığınız ayı seçin" : selectedStartMonth.toString(),
                                      textScaleFactor: 1, style: PeoplerTextStyle.normal.copyWith(color: Mode().blackAndWhiteConversion())),
                                  items: <String>[
                                    "Ocak",
                                    "Şubat",
                                    "Mart",
                                    "Nisan",
                                    "Mayıs",
                                    "Haziran",
                                    "Temmuz",
                                    "Ağustos",
                                    "Eylül",
                                    "Ekim",
                                    "Kasım",
                                    "Aralık"
                                  ].map((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          textScaleFactor: 1, style: PeoplerTextStyle.normal.copyWith(color: Mode().blackAndWhiteConversion())),
                                    );
                                  }).toList(),
                                  onChanged: (String? newStartMonthValue) {
                                    setStateAddHobbyDialog(() {
                                      selectedStartMonth = newStartMonthValue!;
                                    });
                                  },
                                ),
                                Visibility(
                                  visible: !isChecked,
                                  child: DropdownButton<String>(
                                    dropdownColor: Mode().homeScreenScaffoldBackgroundColor(),
                                    hint: Text(selectedFinishYear == null ? "Bıraktığınız yılı seçin" : selectedFinishYear.toString(),
                                        textScaleFactor: 1, style: PeoplerTextStyle.normal.copyWith(color: Mode().blackAndWhiteConversion())),
                                    items: List.generate(60, (index) {
                                      return (1962 + index).toString();
                                    }).map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,
                                            textScaleFactor: 1, style: PeoplerTextStyle.normal.copyWith(color: Mode().blackAndWhiteConversion())),
                                      );
                                    }).toList(),
                                    onChanged: (String? newFinishYearValue) {
                                      setStateAddHobbyDialog(() {
                                        selectedFinishYear = newFinishYearValue!;
                                      });
                                    },
                                  ),
                                ),
                                Visibility(
                                  visible: !isChecked,
                                  child: DropdownButton<String>(
                                    dropdownColor: Mode().homeScreenScaffoldBackgroundColor(),
                                    hint: Text(selectedFinishMonth == null ? "Bıraktığınız ayı seçin" : selectedFinishMonth.toString(),
                                        textScaleFactor: 1, style: PeoplerTextStyle.normal.copyWith(color: Mode().blackAndWhiteConversion())),
                                    items: <String>[
                                      "Ocak",
                                      "Şubat",
                                      "Mart",
                                      "Nisan",
                                      "Mayıs",
                                      "Haziran",
                                      "Temmuz",
                                      "Ağustos",
                                      "Eylül",
                                      "Ekim",
                                      "Kasım",
                                      "Aralık"
                                    ].map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,
                                            textScaleFactor: 1, style: PeoplerTextStyle.normal.copyWith(color: Mode().blackAndWhiteConversion())),
                                      );
                                    }).toList(),
                                    onChanged: (String? newFinishMonthValue) {
                                      setStateAddHobbyDialog(() {
                                        selectedFinishMonth = newFinishMonthValue!;
                                      });
                                    },
                                  ),
                                ),
                                Row(
                                  children: [
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        unselectedWidgetColor: Colors.white,
                                      ),
                                      child: Checkbox(
                                        checkColor: Colors.white,
                                        activeColor: const Color(0xFF0353EF),
                                        value: isChecked,
                                        onChanged: (bool? value) {
                                          Future.delayed(_duration, () {
                                            setStateAddHobbyDialog(() {
                                              isChecked = value!;
                                              selectedFinishYear = null;
                                              selectedFinishMonth = null;
                                            });
                                          });
                                        },
                                      ),
                                    ),
                                    Container(
                                      //color: Colors.red,
                                      child: Text("Hala devam ediyor musunu?",
                                          textScaleFactor: 1, style: PeoplerTextStyle.normal.copyWith(color: Mode().blackAndWhiteConversion())),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'iptal',
                                textScaleFactor: 1,
                                style: PeoplerTextStyle.normal.copyWith(
                                  color: const Color(0xFF0353EF),
                                ),
                              )),
                          TextButton(
                              onPressed: () {
                                ///monthToInt("Haziran") = 6 şeklinde int çıktı verir
                                ///String month Türkçe olmalı
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

                                //bitiş tarihi başlangıç tarihinden önce mi değil mi kontrolünün sağlanması
                                DateTime getStartDate() {
                                  if (selectedStartYear != null && selectedStartMonth != null) {
                                    return DateTime(int.parse(selectedStartYear!), monthToInt(selectedStartMonth!));
                                  } else {
                                    SnackBars(context: context).simple("Boşlukları Doldurunuz");

                                    return DateTime(3000, 1, 1);
                                  }
                                }

                                DateTime getFinishDate() {
                                  if (selectedFinishYear != null && selectedFinishMonth != null) {
                                    return DateTime(int.parse(selectedFinishYear!), monthToInt(selectedFinishMonth!));
                                  } else {
                                    SnackBars(context: context).simple("Boşlukları Doldurunuz");

                                    return DateTime(1, 1, 1);
                                  }
                                }

                                if (isChecked == true && selectedHobbyName != null && selectedStartYear != null && selectedStartMonth != null) {
                                  addHobbyWithJustStartDate(context, selectedHobbyName, selectedStartYear, selectedStartMonth);
                                  //print("başlangıç tarihini ekle bitiş tarihine şu anda yaz");
                                } else if (getFinishDate().difference(getStartDate()).inDays < 0) {
                                  if (selectedStartYear != null &&
                                      selectedStartMonth != null &&
                                      selectedFinishYear != null &&
                                      selectedFinishMonth != null) {
                                    SnackBars(context: context).simple("Boşlukları Doldurunuz");

                                    print("bitiş tarihi başlangıç tarihinden yeni olamaz");
                                  }
                                } else if (isChecked == false &&
                                    selectedHobbyName != null &&
                                    selectedStartYear != null &&
                                    selectedStartMonth != null &&
                                    selectedFinishYear != null &&
                                    selectedFinishMonth != null) {
                                  addHobbyWithStartAndFinishDate(
                                      context, selectedHobbyName, selectedStartYear, selectedStartMonth, selectedFinishYear, selectedFinishMonth);
                                  print("başlangıç + bitiş tarihlerini ekle");
                                } else {
                                  SnackBars(context: context).simple("Boşlukları Doldurunuz");

                                  print("boşlukları doldurunuz!");
                                }
                              },
                              child: Text(
                                'ekle',
                                textScaleFactor: 1,
                                style: PeoplerTextStyle.normal.copyWith(
                                  color: const Color(0xFF0353EF),
                                ),
                              )),
                        ],
                      );
                    });
                  });
            },
            icon: Icon(
              Icons.add,
              color: Mode().blackAndWhiteConversion(),
            )),

        //hobi editleme butonu düzenleme hobby
        IconButton(
          onPressed: () {
            showModalBottomSheet(
                context: context,
                backgroundColor: Mode().homeScreenScaffoldBackgroundColor(),
                builder: (context) {
                  return StatefulBuilder(builder: (context, setStateEditHobbyBottomSheet) {
                    return ListView.builder(
                        itemCount: UserBloc.user!.hobbies.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            leading: MediaQuery.of(context).size.width < 320
                                ? const SizedBox.shrink()
                                : Stack(
                                    children: [
                                      Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(999),
                                            border: Border.all(
                                              width: 1,
                                              color: _mode.search_peoples_scaffold_background() as Color,
                                            )),
                                        child: CircleAvatar(
                                          backgroundColor: const Color(0xFF0353EF),
                                          child: Text("ppl$index", textScaleFactor: 1, style: PeoplerTextStyle.normal.copyWith(fontSize: 12)),
                                        ),
                                      ),
                                      Container(
                                          height: 50,
                                          width: 50,
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(999),
                                              border: Border.all(
                                                width: 1,
                                                color: _mode.search_peoples_scaffold_background() as Color,
                                              )),
                                          child: hobbyItem(0, "sad2365d5")),
                                    ],
                                  ),
                            trailing: IconButton(
                              onPressed: () {
                                deleteHobby(context, index, setStateEditHobbyBottomSheet);
                              },
                              icon: Icon(
                                Icons.delete,
                                color: Mode().blackAndWhiteConversion(),
                              ),
                            ),
                            title:
                                Text("5s2252", textScaleFactor: 1, style: PeoplerTextStyle.normal.copyWith(color: Mode().blackAndWhiteConversion())),
                            subtitle: Text(
                              "5588dsd",
                              textScaleFactor: 1,
                              style: PeoplerTextStyle.normal.copyWith(color: _mode.blackAndWhiteConversion(), fontSize: 14),
                            ),
                          );
                        });
                  });
                });
          },
          icon: SvgPicture.asset(
            "assets/images/svg_icons/edit.svg",
            color: Mode().blackAndWhiteConversion(),
            matchTextDirection: true,
            fit: BoxFit.contain,
          ),
        )
      ],
    );
  }

  schoolName(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return profileData.schoolName != ""
        ? SizedBox(
            width: (screenWidth / 2) - 25,
            child: Text(
              profileData.schoolName,
              textScaleFactor: 1,
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
              style: PeoplerTextStyle.normal.copyWith(
                fontSize: 14,
                color: _mode.blackAndWhiteConversion(),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  currentJob(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return UserBloc.user!.schoolName != ""
        ? SizedBox(
            width: (screenWidth / 2) - 25,
            child: Text(
              UserBloc.user!.currentJobName,
              textScaleFactor: 1,
              textAlign: TextAlign.left,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
              style: PeoplerTextStyle.normal.copyWith(
                fontSize: 14,
                color: _mode.blackAndWhiteConversion(),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  companyName() {
    return profileData.company != ""
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              profileData.company + "'da çalışıyor",
              textScaleFactor: 1,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              softWrap: false,
              style: PeoplerTextStyle.normal.copyWith(
                fontSize: 14,
                color: _mode.blackAndWhiteConversion(),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  /*
  String hobbyDateRange(index) {
    DateTime _startDate =
    DateTime.parse(profileData.experiences.values.elementAt(index)[0]);
    DateTime _finishDate = DateTime.parse(
      //bitiş tarihi girilmiş mi girilmemiş mi kontorlünü sağlama
      profileData.experiences.values.elementAt(index).length == 2
          ? profileData.experiences.values.elementAt(index)[1]
          : DateTime.now().toString(),
    );
    int _days = _finishDate.difference(_startDate).inDays;
    int _months = _days ~/ 30 != 0 ? _days ~/ 30 : 1;
    if (_months < 12) {
      return "$_months Ay";
    } else if (_months >= 12) {
      return "${_months ~/ 12} Yıl " +
          (_months % 12 != 0 ? "${_months % 12} Ay" : "");
    } else {
      return "error";
    }
  }
   */

  intToMonthName(int monthNumber, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    switch (monthNumber) {
      case 1:
        {
          return screenWidth < 360 ? "Oca" : "Ocak";
        }
      case 2:
        {
          return screenWidth < 360 ? "Şub" : "Şubat";
        }
      case 3:
        {
          return screenWidth < 360 ? "Mar" : "Mart";
        }
      case 4:
        {
          return screenWidth < 360 ? "Nis" : "Nisan";
        }
      case 5:
        {
          return screenWidth < 360 ? "May" : "Mayıs";
        }
      case 6:
        {
          return screenWidth < 360 ? "Haz" : "Haziran";
        }
      case 7:
        {
          return screenWidth < 360 ? "Tem" : "Temmuz";
        }
      case 8:
        {
          return screenWidth < 360 ? "Ağu" : "Ağustos";
        }
      case 9:
        {
          return screenWidth < 360 ? "Eyl" : "Eylül";
        }
      case 10:
        {
          return screenWidth < 360 ? "Eki" : "Ekim";
        }
      case 11:
        {
          return screenWidth < 360 ? "Kas" : "Kasım";
        }
      case 12:
        {
          return screenWidth < 360 ? "Ara" : "Aralık";
        }
    }
  }

  String activityText(index, List<MyActivity> activities) {
    if (activities.isNotEmpty) {
      switch (activities[index].activityType) {
        case Strings.activityShared:
          return "bir fikir paylaştı.";
        case Strings.activityLiked:
          return "bir fikre katıldı.";
        case Strings.activityDisliked:
          return "bir fikre katılmadı.";
        default:
          {
            return "hata";
          }
      }
    } else {
      return "0";
    }
  }

  Container hobbyItem(double marginLeft, hobbyName) {
    hobbyName = Hobby().stringToHobbyTypes(hobbyName);
    double _size = 34;
    return Container(
      height: _size,
      width: _size,
      margin: EdgeInsets.only(left: marginLeft),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(color: const Color(0xFF939393).withOpacity(0.6), blurRadius: 2.0, spreadRadius: 0, offset: const Offset(-1.0, 0.75))
        ],
        borderRadius: const BorderRadius.all(Radius.circular(999)),
        color: Colors.white, //Colors.orange,
      ),
      child: SvgPicture.asset(
        "assets/images/hobby_badges/chess.svg",
        fit: BoxFit.contain,
        width: _size,
        height: _size,
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peopler/business_logic/blocs/CityBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/LocationBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/LocationPermissionBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/SavedBloc/bloc.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/enums/send_req_button_status_enum.dart';
import 'package:peopler/core/constants/enums/subscriptions_enum.dart';
import 'package:peopler/core/constants/svg_paths/svg_paths.dart';
import 'package:peopler/core/system_ui_service.dart';
import 'package:peopler/data/model/HobbyModels/hobbies.dart';
import 'package:peopler/others/empty_list.dart';
import 'package:peopler/presentation/screens/SEARCH/save_button_provider.dart';
import 'package:peopler/presentation/screens/SEARCH/seach_peoples_header.dart';
import 'package:peopler/presentation/screens/SEARCH/searching_animation.dart';
import 'package:provider/provider.dart';
import '../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../data/model/saved_user.dart';
import '../../../data/send_notification_service.dart';
import '../../../data/services/db/firestore_db_service_users.dart';
import '../../../others/classes/dark_light_mode_controller.dart';
import '../../../others/locator.dart';
import '../../../others/strings.dart';
import '../../../others/widgets/cached_network_error_image.dart';
import '../../../others/widgets/snack_bars.dart';
import '../PROFILE/OthersProfile/functions.dart';

class NearbyTab extends StatefulWidget {
  const NearbyTab(
      {Key? key,
      required this.screenHeight,
      required this.paddingTopSafeArea,
      required this.maxWidth,
      required this.context,
      required this.size,
      required this.showWidgetsKeyNearby,
      required this.showWidgetsKeyCity})
      : super(key: key);

  final double screenHeight;
  final double paddingTopSafeArea;
  final double maxWidth;
  final BuildContext context;
  final Size size;

  final GlobalKey showWidgetsKeyCity;
  final GlobalKey showWidgetsKeyNearby;

  static const double _secondRowHeight = 140;

  @override
  State<NearbyTab> createState() => _NearbyTabState();
}

class _NearbyTabState extends State<NearbyTab> {
  late ScrollController _searchPeopleListControllerNearby;

  late LocationBloc _locationBloc;
  late LocationPermissionBloc _locationPermissionBloc;
  late SavedBloc _savedBloc;

  final Mode _mode = locator<Mode>();

  bool loading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _locationBloc = BlocProvider.of<LocationBloc>(context);
    _locationPermissionBloc = BlocProvider.of<LocationPermissionBloc>(context);
    _savedBloc = BlocProvider.of<SavedBloc>(context);

    return SafeArea(
      child: ValueListenableBuilder(
          valueListenable: setTheme,
          builder: (context, x, y) {
            return NestedScrollView(
              headerSliverBuilder: (BuildContext context, bool? innerBoxIsScrolled) {
                return <Widget>[
                  SliverOverlapAbsorber(
                    // This widget takes the overlapping behavior of the SliverAppBar,
                    // and redirects it to the SliverOverlapInjector below. If it is
                    // missing, then it is possible for the nested "inner" scroll view
                    // below to end up under the SliverAppBar even when the inner
                    // scroll view thinks it has not been scrolled.
                    // This is not necessary if the "headerSliverBuilder" only builds
                    // widgets that do not overlap the next sliver.
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                    sliver: MySearchScreenAppBar(),
                  ),
                ];
              },
              body: Builder(
                  // This Builder is needed to provide a BuildContext that is "inside"
                  // the NestedScrollView, so that sliverOverlapAbsorberHandleFor() can
                  // find the NestedScrollView.
                  builder: (BuildContext context) {
                _searchPeopleListControllerNearby = context.findAncestorStateOfType<NestedScrollViewState>()!.innerController;
                if (_searchPeopleListControllerNearby.hasListeners == false) {
                  _searchPeopleListControllerNearby.addListener(_listScrollListener);
                }
                return RefreshIndicator(
                  onRefresh: () async {
                    /// Refresh users
                    await _locationBloc.getRefreshIndicatorData();
                  },
                  child: BlocBuilder<LocationPermissionBloc, LocationPermissionState>(
                    bloc: _locationPermissionBloc,
                    builder: (context, state) {
                      if (state is ReadyState) {
                        _locationBloc.add(GetInitialSearchUsersEvent());
                        return CustomScrollView(
                          // The controller must be the inner controller of nested scroll view widget.
                          controller: _searchPeopleListControllerNearby,
                          slivers: <Widget>[
                            SliverOverlapInjector(
                              // This is the flip side of the SliverOverlapAbsorber above.
                              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                            ),
                            BlocBuilder<LocationBloc, LocationState>(
                              key: widget.showWidgetsKeyNearby,
                              bloc: _locationBloc,
                              builder: (context, state) {
                                if (state is InitialSearchState) {
                                  // return _initialUsersStateWidget();
                                  SystemUIService().setSystemUIforThemeMode();
                                  return SliverToBoxAdapter(child: SearchingCase());
                                } else if (state is UsersNotExistSearchState) {
                                  return const SliverFillRemaining(
                                    child: Center(
                                      child: EmptyList(
                                        emptyListType: EmptyListType.nearby,
                                        isSVG: false,
                                      ),
                                    ),
                                  );
                                } else if (state is UsersLoadedSearch1State) {
                                  loading = false;
                                  return _showUsers(widget.size);
                                } else if (state is UsersLoadedSearch2State) {
                                  loading = false;
                                  return _showUsers(widget.size);
                                } else if (state is NoMoreUsersSearchState) {
                                  return _showUsers(widget.size);
                                } else if (state is NewUsersLoadingSearchState) {
                                  return _showUsers(widget.size);
                                } else {
                                  return const Text("Impossible");
                                }
                              },
                            ),
                            BlocBuilder<LocationBloc, LocationState>(
                                bloc: _locationBloc,
                                builder: (context, state) {
                                  if (state is NewUsersLoadingSearchState && LocationBloc.allUserList.length > 4) {
                                    return _usersLoadingCircularButton();
                                  } else {
                                    return const SliverToBoxAdapter(child: SizedBox.shrink());
                                  }
                                }),
                          ],
                        );
                      } else {
                        Widget _widget;

                        if (state is NoLocationState) {
                          _widget = _noLocationWidget();
                        } else if (state is NoPermissionState) {
                          _widget = _noPermissionWidget();
                        } else if (state is NoPermissionClickSettingsState) {
                          _widget = _noPermissionRefreshWidget();
                        } else {
                          _widget = const Text("Impossible");
                        }

                        return CustomScrollView(
                            // The controller must be the inner controller of nested scroll view widget.
                            controller: _searchPeopleListControllerNearby,
                            slivers: <Widget>[
                              SliverOverlapInjector(
                                // This is the flip side of the SliverOverlapAbsorber above.
                                handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                              ),
                              _widget
                            ]);
                      }
                    },
                  ),
                );
              }),
            );
          }),
    );
  }

  SliverToBoxAdapter _noLocationWidget() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SearchingCase(
            height: 200,
            width: MediaQuery.of(context).size.width * 0.6,
            svgIconPath: SVG_PATHS.locationPinPath,
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Text(
              "Yakınınızdaki kişilerin sizi bulabilmesi için konum özelliğini açmanız gerekiyor.",
              textScaleFactor: 1,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headline6,
              //sstyle: TextStyle(color: Colors.black, fontSize: 20),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          OutlinedButton(
              child: Text(
                "Konumu Aç",
                textScaleFactor: 1,
                style: Theme.of(context).textTheme.labelLarge,
                //style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              onPressed: () => _locationPermissionBloc.add(GetLocationPermissionEvent())),
        ]),
      ),
    );
  }

  SliverToBoxAdapter _noPermissionWidget() {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                child: SvgPicture.asset(
                  "assets/empty_list_images/locationRequest.svg",
                  fit: BoxFit.contain,
                  width: 220,
                  height: 220,
                ),
              ),
              Text(
                "Konum İzni",
                textAlign: TextAlign.center,
                textScaleFactor: 1,
                style: PeoplerTextStyle.normal.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: _mode.blackAndWhiteConversion(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Yakınınızdaki kişilerin sizi bulabilmesi için konum izni vermeniz gerekiyor",
                textAlign: TextAlign.center,
                textScaleFactor: 1,
                style: PeoplerTextStyle.normal.copyWith(
                  fontSize: 16,
                  color: _mode.blackAndWhiteConversion(),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 0, top: 10),
                    child: InkWell(
                      onTap: () => _locationPermissionBloc.add(OpenSettingsClicked()),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(width: 1, color: const Color(0xFF0353EF)),
                          color: Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            "Ayarlara Git",
                            textScaleFactor: 1,
                            style: PeoplerTextStyle.normal.copyWith(color: const Color(0xFF0353EF), fontSize: 14),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _noPermissionRefreshWidget() {
    return SliverToBoxAdapter(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Center(
          child: Text(
            "Ayarlardan konum izni verdiyseniz yenile butonuna tıklayarak yakınınızdaki kullanıcıları görebilirsiniz",
            textScaleFactor: 1,
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
        TextButton(
            child: const Text(
              "Sayfa Yenile",
              textScaleFactor: 1,
              style: TextStyle(color: Colors.black, fontSize: 20),
            ),
            onPressed: () => _locationPermissionBloc.add(GetLocationPermissionEvent())),
      ]),
    );
  }

  SliverToBoxAdapter _usersLoadingCircularButton() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(children: const [
          Expanded(flex: 5, child: SizedBox()),
          Flexible(flex: 1, child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator())),
          Expanded(flex: 5, child: SizedBox()),
        ]),
      ),
    );
  }

  SliverList _showUsers(Size _size) {
    int _listLength = LocationBloc.allUserList.length;
    if (_size.width < 335) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Container(
                        decoration: buildBoxDecoration(),
                        margin: const EdgeInsets.all(5),
                        child: buildColumn(index, context),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          childCount: _listLength,
        ),
      );
    } else {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            int _leftSideIndex = index * 2;
            int _rightSideIndex = _leftSideIndex + 1;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Container(
                        decoration: buildBoxDecoration(),
                        margin: const EdgeInsets.all(5),
                        child: buildColumn(_leftSideIndex, context),
                      ),
                    ),
                  ),
                  _listLength % 2 == 0
                      ? Expanded(
                          flex: 1,
                          child: Center(
                            child: Container(
                              decoration: buildBoxDecoration(),
                              margin: const EdgeInsets.all(5),
                              child: buildColumn(_rightSideIndex, context),
                            ),
                          ),
                        )
                      : (_listLength % 2 == 0 ? _listLength / 2 : (_listLength - 1) / 2) == index
                          ? const Expanded(
                              flex: 1,
                              child: SizedBox(),
                            )
                          : Expanded(
                              flex: 1,
                              child: Center(
                                child: Container(
                                  decoration: buildBoxDecoration(),
                                  margin: const EdgeInsets.all(5),
                                  child: buildColumn(_rightSideIndex, context),
                                ),
                              ),
                            ),
                ],
              ),
            );
          },
          childCount: (_listLength % 2 == 0 ? _listLength / 2 : ((_listLength - 1) / 2) + 1).toInt(),
        ),
      );
    }
  }

  Padding buildColumn(int index, BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    double _maxWidth = _size.width > 400 ? 400 : _size.width;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  height: 10,
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        height: 100,
                        width: 100,
                        child: const CircleAvatar(
                          backgroundColor: Color(0xFF0353EF),
                          child: Text("ppl"),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          if (UserBloc.user == null) {
                            showYouNeedToLogin(context);
                            return;
                          }
                          openOthersProfile(context, LocationBloc.allUserList[index].userID, SendRequestButtonStatus.save);
                        },
                        child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            height: 100,
                            width: 100,
                            child: CachedNetworkImage(
                              imageUrl: LocationBloc.allUserList[index].profileURL,
                              progressIndicatorBuilder: (context, url, downloadProgress) => ClipRRect(
                                  borderRadius: BorderRadius.circular(999), child: CircularProgressIndicator(value: downloadProgress.progress)),
                              errorWidget: (context, url, error) => cachedNetworkErrorImageWidget(LocationBloc.allUserList[index].gender),
                              imageBuilder: (context, imageProvider) => Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                                ),
                              ),
                            ) //: const CircleAvatar(backgroundColor: Colors.transparent,),
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    CityBloc _cityBloc = BlocProvider.of<CityBloc>(context);

                    String _deletedUserID = LocationBloc.allUserList[index].userID;
                    LocationBloc.allUserList.removeWhere((element) => element.userID == _deletedUserID);
                    CityBloc.allUserList.removeWhere((element) => element.userID == _deletedUserID);

                    if (UserBloc.user != null) {
                      _cityBloc.add(TrigUsersNotExistCityStateEvent(city: UserBloc.user!.city));
                    }
                    _locationBloc.add(TrigUsersNotExistSearchStateEvent());
                  },
                  child: Container(
                    alignment: Alignment.topRight,
                    color: Colors.transparent, //Colors.blue,
                    width: 25,
                    height: 25,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1, color: const Color(0xFF0353EF)),
                        color: Colors.white, //Colors.purple,
                        borderRadius: const BorderRadius.all(Radius.circular(999)),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  color: Colors.transparent, //Colors.teal,
                  height: NearbyTab._secondRowHeight,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: LimitedBox(
                          maxHeight: 20,
                          child: Text(
                            LocationBloc.allUserList[index].pplName!,
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textScaleFactor: 1,
                            style: PeoplerTextStyle.normal.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: _mode.blackAndWhiteConversion(),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        child: Text(
                          LocationBloc.allUserList[index].biography,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor: 1,
                          maxLines: 3,
                          //_size.width * 0.038 < 15 ? 3 : _size.width * 0.038 <20  ? 2:1,
                          style: const TextStyle(height: 1.1, color: Color(0xFF9C9C9C), fontWeight: FontWeight.normal, fontSize: 15),
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      Container(
                        height: 34,
                        color: Colors.transparent, //Colors.pinkAccent,
                        child: Center(
                          child: Stack(
                            children: [
                              LocationBloc.allUserList[index].hobbies.isNotEmpty
                                  ? hobbyItem(index, 0, LocationBloc.allUserList[index].hobbies[0]["title"])
                                  : const SizedBox(),
                              LocationBloc.allUserList[index].hobbies.length >= 2
                                  ? hobbyItem(index, 25, LocationBloc.allUserList[index].hobbies[1]["title"])
                                  : const SizedBox(),
                              LocationBloc.allUserList[index].hobbies.length >= 3
                                  ? hobbyItem(index, 50, LocationBloc.allUserList[index].hobbies[2]["title"])
                                  : const SizedBox(),
                            ],
                          ),
                        ),
                      ),
//Container(height: 5,width: 120,), //yellow space
                      Container(
                        height: 5,
                      ), //black space
                      Container(
                        height: 25,
                        color: Colors.transparent, //Colors.blue,

                        child: ChangeNotifierProvider.value(
                          value: SaveButton(),
                          child: Builder(builder: (context) {
                            bool _isSaved = Provider.of<SaveButton>(context).isSaved;
                            return InkWell(
                              onTap: () async {
                                if (UserBloc.user != null) {
                                  if (UserBloc.entitlement != SubscriptionTypes.premium) {
                                    _savedBloc.add(ClickSaveButtonEvent(savedUser: LocationBloc.allUserList[index], myUserID: UserBloc.user!.userID));

                                    Provider.of<SaveButton>(context, listen: false).saveUser();
                                    await Future.delayed(const Duration(milliseconds: 1500));

                                    widget.showWidgetsKeyNearby.currentState?.setState(() {});
                                    widget.showWidgetsKeyCity.currentState?.setState(() {});
                                  } else {
                                    final SendNotificationService _sendNotificationService = locator<SendNotificationService>();
                                    final FirestoreDBServiceUsers _firestoreDBServiceUsers = locator<FirestoreDBServiceUsers>();

                                    SavedUser _savedUser = SavedUser();
                                    _savedUser.userID = LocationBloc.allUserList[index].userID;
                                    _savedUser.pplName = LocationBloc.allUserList[index].pplName!;
                                    _savedUser.displayName = LocationBloc.allUserList[index].displayName;
                                    _savedUser.gender = LocationBloc.allUserList[index].gender;
                                    _savedUser.profileURL = LocationBloc.allUserList[index].profileURL;
                                    _savedUser.biography = LocationBloc.allUserList[index].biography;
                                    _savedUser.hobbies = LocationBloc.allUserList[index].hobbies;

                                    _savedBloc.add(ClickSendRequestButtonEvent(myUser: UserBloc.user!, savedUser: _savedUser));

                                    Provider.of<SaveButton>(context, listen: false).saveUser();
                                    await Future.delayed(const Duration(milliseconds: 1500));

                                    String? _token = await _firestoreDBServiceUsers.getToken(_savedUser.userID);

                                    if (_token != null) {
                                      _sendNotificationService.sendNotification(Strings.sendRequest, _token, "", UserBloc.user!.displayName,
                                          UserBloc.user!.profileURL, UserBloc.user!.userID);
                                    }

                                    widget.showWidgetsKeyNearby.currentState?.setState(() {});
                                    widget.showWidgetsKeyCity.currentState?.setState(() {});
                                  }
                                } else {
                                  showYouNeedToLoginSave(context);
                                }
                              },
                              child: Center(
                                child: Container(
                                  width: 104,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 1, color: _mode.disabledBottomMenuItemAssetColor() as Color),
                                    color: Colors.transparent,
                                    //Colors.purple,
                                    borderRadius: const BorderRadius.all(Radius.circular(999)),
                                  ),
                                  child: Center(
                                    child: _isSaved == false
                                        ? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              UserBloc.entitlement == SubscriptionTypes.premium
                                                  ? const SizedBox.shrink()
                                                  : SvgPicture.asset(
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
                                                UserBloc.entitlement == SubscriptionTypes.premium ? "Bağlantı Kur" : "Kaydet",
                                                textScaleFactor: 1,
                                                style: PeoplerTextStyle.normal.copyWith(
                                                  color: _mode.disabledBottomMenuItemAssetColor(),
                                                  fontSize: _maxWidth * 0.0391 > 16 ? 16 : _maxWidth * 0.0391,
                                                ),
                                              ),
                                            ],
                                          )
                                        : const Icon(
                                            Icons.done,
                                            color: Color(0xFF0353EF),
                                          ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
      boxShadow: <BoxShadow>[
        BoxShadow(
          color: const Color(0xFF939393).withOpacity(0.6),
          blurRadius: 2.0,
          spreadRadius: 0,
          offset: const Offset(0.0, 0.75),
        ),
      ],
      borderRadius: const BorderRadius.all(Radius.circular(14)),
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          _mode.searchItemGradientBgTop(),
          _mode.searchItemGradientBgBottom(),
        ],
      ),
    );
  }

  Container hobbyItem(int index, double marginLeft, String hobbyName) {
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
        "assets/images/hobby_badges/$hobbyName.svg",
        fit: BoxFit.contain,
        width: _size,
        height: _size,
      ),
    );
  }

  bool _listScrollListener() {
    var nextPageTrigger = 0.8 * _searchPeopleListControllerNearby.positions.last.maxScrollExtent;

    if (_searchPeopleListControllerNearby.positions.last.axisDirection == AxisDirection.down &&
        _searchPeopleListControllerNearby.positions.last.pixels >= nextPageTrigger) {
      if (loading == false) {
        loading = true;
        _locationBloc.add(GetMoreSearchUsersEvent());
      }
    }

    return true;
  }
}

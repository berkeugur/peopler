import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:peopler/business_logic/blocs/CityBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/LocationBloc/bloc.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/enums/send_req_button_status_enum.dart';
import 'package:peopler/core/constants/enums/subscriptions_enum.dart';
import 'package:peopler/data/model/HobbyModels/hobbies.dart';
import 'package:peopler/presentation/screens/GUEST_LOGIN/body.dart';
import 'package:peopler/presentation/screens/SEARCH/save_button_provider.dart';
import 'package:provider/provider.dart';
import '../../../business_logic/blocs/SavedBloc/saved_bloc.dart';
import '../../../business_logic/blocs/SavedBloc/saved_event.dart';
import '../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../others/classes/variables.dart';
import '../../../data/model/saved_user.dart';
import '../../../data/send_notification_service.dart';
import '../../../data/services/db/firestore_db_service_users.dart';
import '../../../others/classes/dark_light_mode_controller.dart';
import '../../../others/locator.dart';
import '../../../others/strings.dart';
import '../../../others/widgets/snack_bars.dart';
import '../../../others/empty_list.dart';
import '../PROFILE/OthersProfile/functions.dart';

class CityTab extends StatefulWidget {
  const CityTab(
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

  @override
  State<CityTab> createState() => CityTabState();
}

class CityTabState extends State<CityTab> {
  late ScrollController _searchPeopleListControllerCity;

  late final CityBloc _cityBloc;
  late final SavedBloc _savedBloc;

  static const double _secondRowHeight = 140;

  final Mode _mode = locator<Mode>();

  bool loading = false;

  @override
  void initState() {
    _cityBloc = BlocProvider.of<CityBloc>(context);
    _savedBloc = BlocProvider.of<SavedBloc>(context);

    _searchPeopleListControllerCity = ScrollController();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (UserBloc.user == null) {
      return const GuestLoginScreenBody();
    }

    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          debugPrint("~~~~~~~~~~~~~city~~~~~~~~~~~~~~~~~~");
          debugPrint(Mode.isEnableDarkMode.toString());
          return Container(
            color: Mode().homeScreenScaffoldBackgroundColor(),
            child: Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: SizedBox(
                child: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scrollNotification) =>
                      _listScrollListener(),
                  child: Container(
                    color: Mode().homeScreenScaffoldBackgroundColor(),
                    child: RefreshIndicator(
                      color: const Color(0xFF0353EF),
                      displacement: 80.0,
                      onRefresh: () async {
                        /// Refresh users
                        await _cityBloc
                            .getRefreshIndicatorData(UserBloc.user!.city);
                      },
                      child: SingleChildScrollView(
                        controller: _searchPeopleListControllerCity,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          children: [
                            BlocBuilder<CityBloc, CityState>(
                              key: widget.showWidgetsKeyCity,
                              bloc: _cityBloc,
                              builder: (context, state) {
                                if (state is InitialCityState) {
                                  return _initialUsersStateWidget();
                                } else if (state is UsersNotExistCityState) {
                                  return _noUserExistsWidget();
                                } else if (state is UsersLoadedCity1State) {
                                  loading = false;
                                  return _showUsers(widget.size);
                                } else if (state is UsersLoadedCity2State) {
                                  loading = false;
                                  return _showUsers(widget.size);
                                }else if (state is NoMoreUsersCityState) {
                                  return _showUsers(widget.size);
                                } else if (state is NewUsersLoadingCityState) {
                                  return _showUsers(widget.size);
                                } else {
                                  return const Text("Impossible");
                                }
                              },
                            ),
                            BlocBuilder<CityBloc, CityState>(
                                bloc: _cityBloc,
                                builder: (context, state) {
                                  if (state is NewUsersLoadingCityState) {
                                    return _usersLoadingCircularButton();
                                  } else {
                                    return const SizedBox.shrink();
                                  }
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  SizedBox _initialUsersStateWidget() {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const Center(
          child: CircularProgressIndicator(),
        ));
  }

  EmptyList _noUserExistsWidget() {
    return const EmptyList(
      emptyListType: EmptyListType.citySearch,
      isSVG: false,
    );
  }

  Padding _usersLoadingCircularButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: const [
        Expanded(flex: 5, child: SizedBox()),
        Flexible(
            flex: 1,
            child: SizedBox(
                width: 30, height: 30, child: CircularProgressIndicator())),
        Expanded(flex: 5, child: SizedBox()),
      ]),
    );
  }

  Widget _showUsers(Size _size) {
    int _listLength = CityBloc.allUserList.length;
    if (_size.width < 335) {
      return ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(
              parent: NeverScrollableScrollPhysics()),
          padding: EdgeInsets.only(
            top: 80,
            left: _size.width > 320
                ? 60
                : _size.width > 280
                    ? 45
                    : 25,
            right: _size.width > 320
                ? 60
                : _size.width > 280
                    ? 45
                    : 25,
          ),
          itemCount: _listLength,
          itemBuilder: (BuildContext context, int index) {
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
          });
    } else {
      return ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 80),
          physics: const BouncingScrollPhysics(
              parent: NeverScrollableScrollPhysics()),
          itemCount: (_listLength % 2 == 0
                  ? _listLength / 2
                  : ((_listLength - 1) / 2) + 1)
              .toInt(),
          itemBuilder: (BuildContext context, int index) {
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
                      : (_listLength % 2 == 0
                                  ? _listLength / 2
                                  : (_listLength - 1) / 2) ==
                              index
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
          });
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
                child: Container(height: 10),
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
                          openOthersProfile(
                              context,
                              CityBloc.allUserList[index].userID,
                              SendRequestButtonStatus.connect);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          height: 100,
                          width: 100,
                          child: //_userBloc != null ?

                              CachedNetworkImage(
                            imageUrl: CityBloc.allUserList[index].profileURL,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) => ClipRRect(
                                    borderRadius: BorderRadius.circular(999),
                                    child: CircularProgressIndicator(
                                        value: downloadProgress.progress)),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                          ),
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
                    LocationBloc _locationBloc =
                        BlocProvider.of<LocationBloc>(context);
                    CityBloc _cityBloc = BlocProvider.of<CityBloc>(context);

                    String _deletedUserID = CityBloc.allUserList[index].userID;
                    LocationBloc.allUserList.removeWhere(
                        (element) => element.userID == _deletedUserID);
                    CityBloc.allUserList.removeWhere(
                        (element) => element.userID == _deletedUserID);

                    _cityBloc.add(TrigUsersNotExistCityStateEvent());
                    _locationBloc.add(TrigUsersNotExistSearchStateEvent());
                  },
                  child: Container(
                    alignment: Alignment.topRight,
                    color: Colors.transparent,
                    //Colors.blue,
                    width: 25,
                    height: 25,
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        border: Border.all(
                            width: 1, color: const Color(0xFF0353EF)),
                        color: Colors.white, //Colors.purple,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(999)),
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
                  height: _secondRowHeight,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: LimitedBox(
                          maxHeight: 20,
                          child: Text(
                            CityBloc.allUserList[index].displayName,
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
                          CityBloc.allUserList[index].biography,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          textScaleFactor: 1,
                          maxLines: 3,
                          //_size.width * 0.038 < 15 ? 3 : _size.width * 0.038 <20  ? 2:1,
                          style: const TextStyle(
                              height: 1.1,
                              color: Color(0xFF9C9C9C),
                              fontWeight: FontWeight.normal,
                              fontSize: 15),
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
                              CityBloc.allUserList[index].hobbies.isNotEmpty
                                  ? hobbyItem(
                                      index,
                                      0,
                                      CityBloc.allUserList[index].hobbies[0]
                                          ["title"])
                                  : const SizedBox(),
                              CityBloc.allUserList[index].hobbies.length >= 2
                                  ? hobbyItem(
                                      index,
                                      25,
                                      CityBloc.allUserList[index].hobbies[1]
                                          ["title"])
                                  : const SizedBox(),
                              CityBloc.allUserList[index].hobbies.length >= 3
                                  ? hobbyItem(
                                      index,
                                      50,
                                      CityBloc.allUserList[index].hobbies[2]
                                          ["title"])
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
                            bool _isSaved =
                                Provider.of<SaveButton>(context).isSaved;
                            return InkWell(
                              onTap: () async {
                                if (UserBloc.entitlement ==
                                        SubscriptionTypes.free &&
                                    UserBloc.user!.numOfSendRequest < 1) {
                                  showNumOfConnectionRequestsConsumed(context);
                                  return;
                                }

                                if (UserBloc.entitlement ==
                                        SubscriptionTypes.free &&
                                    UserBloc.user!.numOfSendRequest == 1) {
                                  showNumOfConnectionRequestsConsumed(context);
                                }

                                final SendNotificationService
                                    _sendNotificationService =
                                    locator<SendNotificationService>();
                                final FirestoreDBServiceUsers
                                    _firestoreDBServiceUsers =
                                    locator<FirestoreDBServiceUsers>();

                                SavedUser _savedUser = SavedUser();
                                _savedUser.userID =
                                    CityBloc.allUserList[index].userID;
                                _savedUser.pplName =
                                    CityBloc.allUserList[index].pplName!;
                                _savedUser.displayName =
                                    CityBloc.allUserList[index].displayName;
                                _savedUser.gender =
                                    CityBloc.allUserList[index].gender;
                                _savedUser.profileURL =
                                    CityBloc.allUserList[index].profileURL;
                                _savedUser.biography =
                                    CityBloc.allUserList[index].biography;
                                _savedUser.hobbies =
                                    CityBloc.allUserList[index].hobbies;

                                _savedBloc.add(ClickSendRequestButtonEvent(
                                    myUser: UserBloc.user!,
                                    savedUser: _savedUser));

                                if (UserBloc.entitlement ==
                                    SubscriptionTypes.free) {
                                  showRestNumOfConnectionRequests(context);
                                }

                                Provider.of<SaveButton>(context, listen: false)
                                    .saveUser();
                                await Future.delayed(
                                    const Duration(milliseconds: 1500));

                                String? _token = await _firestoreDBServiceUsers
                                    .getToken(_savedUser.userID);

                                if (_token != null) {
                                  _sendNotificationService.sendNotification(
                                      Strings.sendRequest,
                                      _token,
                                      "",
                                      UserBloc.user!.displayName,
                                      UserBloc.user!.profileURL,
                                      UserBloc.user!.userID);
                                }

                                widget.showWidgetsKeyNearby.currentState
                                    ?.setState(() {});
                                widget.showWidgetsKeyCity.currentState
                                    ?.setState(() {});
                              },
                              child: Center(
                                child: Container(
                                  width: 104,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1,
                                        color: _mode
                                                .disabledBottomMenuItemAssetColor()
                                            as Color),
                                    color: Colors.transparent,
                                    //Colors.purple,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(999)),
                                  ),
                                  child: Center(
                                    child: _isSaved == false
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                "Bağlantı Kur",
                                                textScaleFactor: 1,
                                                style: PeoplerTextStyle.normal
                                                    .copyWith(
                                                  color: _mode
                                                      .disabledBottomMenuItemAssetColor(),
                                                  fontSize:
                                                      _maxWidth * 0.0391 > 16
                                                          ? 16
                                                          : _maxWidth * 0.0391,
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

  Container hobbyItem(int index, double marginLeft, hobbyName) {
    hobbyName = Hobby().stringToHobbyTypes(hobbyName);
    double _size = 34;
    return Container(
      height: _size,
      width: _size,
      margin: EdgeInsets.only(left: marginLeft),
      decoration: BoxDecoration(
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: const Color(0xFF939393).withOpacity(0.6),
              blurRadius: 2.0,
              spreadRadius: 0,
              offset: const Offset(-1.0, 0.75))
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
    if (_searchPeopleListControllerCity.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (Variables.animatedSearchPeopleHeaderHeight.value != 80) {
        Variables.animatedSearchPeopleHeaderHeight.value = 80;
        // print("forward $ach ${MediaQuery.of(context).size.width}, ${MediaQuery.of(context).size.height}");
        // print("textScaleFactor : ${MediaQuery.of(context).textScaleFactor}");
      }
    } else if (_searchPeopleListControllerCity.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (Variables.animatedSearchPeopleHeaderHeight.value != 0) {
        Variables.animatedSearchPeopleHeaderHeight.value = 0;
        // print("reverse $ach");
      }
    }

    var nextPageTrigger = 0.8 * _searchPeopleListControllerCity.position.maxScrollExtent;

    if(_searchPeopleListControllerCity.position.userScrollDirection ==  ScrollDirection.reverse &&
        _searchPeopleListControllerCity.position.pixels >= nextPageTrigger) {
      if (loading == false) {
        loading = true;
        debugPrint("hello");
        _cityBloc.add(GetMoreSearchUsersCityEvent(city: UserBloc.user!.city));
      }
    }

    return true;
  }
}

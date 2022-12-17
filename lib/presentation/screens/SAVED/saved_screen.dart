import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:peopler/business_logic/blocs/SavedBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';
import 'package:peopler/core/constants/enums/send_req_button_status_enum.dart';
import 'package:peopler/others/empty_list.dart';
import 'package:peopler/presentation/screens/SAVED/saved_screen_action_button.dart';
import 'package:peopler/presentation/screens/SAVED/saved_screen_time_text.dart';
import '../../../business_logic/cubits/ThemeCubit.dart';
import '../../../core/constants/enums/subscriptions_enum.dart';
import '../../../others/classes/variables.dart';
import '../../../others/classes/dark_light_mode_controller.dart';
import '../../../others/locator.dart';
import 'package:peopler/presentation/screens/SAVED/saved_screen_header.dart';
import '../PROFILE/OthersProfile/functions.dart';

class SavedScreen extends StatefulWidget {
  const SavedScreen({Key? key}) : super(key: key);

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final Mode _mode = locator<Mode>();
  final double _secondRowHeight = 160;
  final ScrollController _savedListController = ScrollController();
  late final ThemeCubit _themeCubit;
  late final SavedBloc _savedBloc;

  final GlobalKey showWidgetsKeySaved = GlobalKey();

  bool loading = false;

  @override
  void initState() {
    _themeCubit = BlocProvider.of<ThemeCubit>(context);
    _savedBloc = BlocProvider.of<SavedBloc>(context);
    _savedBloc.add(GetInitialSavedUsersEvent(myUserID: UserBloc.user!.userID));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Mode().homeScreenScaffoldBackgroundColor(),
        body: MultiValueListenableBuilder(
            valueListenables: [
              Variables.animatedSearchPeopleHeaderHeight,
              setTheme,
            ],
            builder: (context, snapshot, _) {
              double _maxWidth = _size.width > 400 ? 400 : _size.width;

              return BlocBuilder<ThemeCubit, bool>(
                  bloc: _themeCubit,
                  builder: (_, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          height: MediaQuery.of(context).padding.top,
                          color: _mode.homeScreenScaffoldBackgroundColor(),
                        ),
                        Expanded(
                          child: SizedBox(
                            width: _maxWidth,
                            child: NotificationListener(
                              onNotification: (ScrollNotification scrollNotification) => _listScrollListener(),
                              child: SingleChildScrollView(
                                controller: _savedListController,
                                physics: const BouncingScrollPhysics(),
                                child: Column(
                                  children: [
                                    saved_screen_header(context: context),
                                    BlocBuilder<SavedBloc, SavedState>(
                                      key: showWidgetsKeySaved,
                                      bloc: _savedBloc,
                                      builder: (context, state) {
                                        if (state is InitialSavedState) {
                                          return _initialUsersStateWidget();
                                        } else if (state is UserNotExistSavedState) {
                                          return _noUserExistsWidget();
                                        } else if (state is UsersLoadedSaved1State) {
                                          loading = false;
                                          return _showSavedUsers(_size);
                                        } else if (state is UsersLoadedSaved2State) {
                                          loading = false;
                                          return _showSavedUsers(_size);
                                        } else if (state is NoMoreUsersSavedState) {
                                          return _showSavedUsers(_size);
                                        } else if (state is NewUsersLoadingSavedState) {
                                          return _showSavedUsers(_size);
                                        } else {
                                          return const Text("Impossible");
                                        }
                                      },
                                    ),
                                    BlocBuilder<SavedBloc, SavedState>(
                                        bloc: _savedBloc,
                                        builder: (context, state) {
                                          if (state is NewUsersLoadingSavedState) {
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
                      ],
                    );
                  });
            }),
      ),
    );
  }

  SizedBox _initialUsersStateWidget() {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const Center(
          child: CircularProgressIndicator(),
        ));
  }

  SizedBox _noUserExistsWidget() {
    return const SizedBox(
      height: 521,
      child: EmptyList(
        emptyListType: EmptyListType.saved,
        isSVG: true,
      ),
    );
  }

  Padding _usersLoadingCircularButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: const [
        Expanded(flex: 5, child: SizedBox()),
        Flexible(flex: 1, child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator())),
        Expanded(flex: 5, child: SizedBox()),
      ]),
    );
  }

  ListView _showSavedUsers(Size _size) {
    int _savedBlocUsersLength = _savedBloc.allRequestList.length;
    return _size.width < 335
        ? ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.only(
              // ekran genişliği 320 den büyük ise 60,
              // 320 ile 280 arasında ise 45, 280 den küçükse 25 döndürüyor.
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
            physics: const BouncingScrollPhysics(parent: NeverScrollableScrollPhysics()),
            itemCount: _savedBlocUsersLength,
            itemBuilder: (
              BuildContext context,
              int index,
            ) {
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
                          child: buildSavedColumn(
                            index,
                            context,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            })
        : ListView.builder(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(parent: NeverScrollableScrollPhysics()),
            itemCount: (_savedBlocUsersLength % 2 == 0 ? _savedBlocUsersLength / 2 : ((_savedBlocUsersLength - 1) / 2) + 1).toInt(),
            itemBuilder: (
              BuildContext context,
              int index,
            ) {
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
                          child: buildSavedColumn(
                            _leftSideIndex,
                            context,
                          ),
                        ),
                      ),
                    ),
                    _savedBlocUsersLength % 2 == 0
                        ? Expanded(
                            flex: 1,
                            child: Center(
                              child: Container(
                                decoration: buildBoxDecoration(),
                                margin: const EdgeInsets.all(5),
                                child: buildSavedColumn(
                                  _rightSideIndex,
                                  context,
                                ),
                              ),
                            ),
                          )
                        : (_savedBlocUsersLength % 2 == 0 ? _savedBlocUsersLength / 2 : (_savedBlocUsersLength - 1) / 2) == index
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
                                    child: buildSavedColumn(
                                      _rightSideIndex,
                                      context,
                                    ),
                                  ),
                                ),
                              ),
                  ],
                ),
              );
            },
          );
  }

  Column buildSavedColumn(
    int index,
    BuildContext context,
  ) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              flex: 1,
              child: SizedBox(
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
                      onTap: () => openOthersProfile(context, _savedBloc.allRequestList[index].userID, SendRequestButtonStatus.connect),
                      child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          height: 100,
                          width: 100,
                          child: CachedNetworkImage(
                            imageUrl: _savedBloc.allRequestList[index].profileURL,
                            progressIndicatorBuilder: (context, url, downloadProgress) => ClipRRect(
                                borderRadius: BorderRadius.circular(999), child: CircularProgressIndicator(value: downloadProgress.progress)),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                              ),
                            ),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _savedBloc.add(DeleteSavedUserEvent(savedUserID: _savedBloc.allRequestList[index].userID));
                    _savedBloc.allRequestList.removeWhere((element) => element.userID == _savedBloc.allRequestList[index].userID);
                    _savedBloc.add(TrigUserNotExistSavedStateEvent());
                  });
                },
                child: Container(
                  alignment: Alignment.topRight,
                  color: Colors.transparent, //Colors.blue,
                  width: 25,
                  height: 25,
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 5,
                    ),
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: const Color(0xFF0353EF),
                      ),
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
                color: Colors.transparent, //Colors.cyanAccent,
                width: 10,
                height: _secondRowHeight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 140,
                      child: LimitedBox(
                        maxWidth: 140,
                        maxHeight: 20,
                        child: Text(
                          (_savedBloc.allRequestList[index].isCountdownFinished == false)
                              ? _savedBloc.allRequestList[index].pplName
                              : _savedBloc.allRequestList[index].displayName,
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
                      width: 140,
                      child: Text(
                        _savedBloc.allRequestList[index].biography,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        textScaleFactor: 1,
                        maxLines: 3,
                        style: const TextStyle(
                          height: 1.1,
                          color: Color(0xFF9C9C9C),
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Container(
                      width: 140,
                      height: 34,
                      color: Colors.transparent, //Colors.pinkAccent,
                      child: Center(
                        child: Stack(
                          children: [
                            _savedBloc.allRequestList[index].hobbies.isNotEmpty
                                ? hobbyItem(index, 0, _savedBloc.allRequestList[index].hobbies[0])
                                : const SizedBox(),
                            _savedBloc.allRequestList[index].hobbies.length >= 2
                                ? hobbyItem(index, 25, _savedBloc.allRequestList[index].hobbies[1])
                                : const SizedBox(),
                            _savedBloc.allRequestList[index].hobbies.length >= 3
                                ? hobbyItem(index, 50, _savedBloc.allRequestList[index].hobbies[2])
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
//Container(height: 5,width: 120,), //yellow space
                    const SizedBox(
                      height: 5,
                      width: 140,
                    ), //black space
                    Container(
                      height: 25,
                      color: Colors.transparent, //Colors.blue,
                      width: 140,
                      child: Center(
                        child: actionButton(context, index, showWidgetsKeySaved),
                      ),
                    ),
                    UserBloc.entitlement != SubscriptionTypes.premium ? timeText(context, index) : const SizedBox.shrink(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
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

  bool _listScrollListener() {
    var nextPageTrigger = 0.8 * _savedListController.positions.last.maxScrollExtent;

    if (_savedListController.positions.last.axisDirection == AxisDirection.down && _savedListController.positions.last.pixels >= nextPageTrigger) {
      if (loading == false) {
        loading = true;
        _savedBloc.add(GetMoreSavedUsersEvent(myUserID: UserBloc.user!.userID));
      }
    }

    return true;
  }
}

Container hobbyItem(int index, double marginLeft, hobbyName) {
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

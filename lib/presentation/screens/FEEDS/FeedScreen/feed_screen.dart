import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peopler/business_logic/blocs/LocationPermissionBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/LocationUpdateBloc/bloc.dart';
import 'package:peopler/business_logic/cubits/ThemeCubit.dart';
import 'package:peopler/components/FlutterWidgets/app_bars.dart';
import 'package:peopler/components/FlutterWidgets/drawer.dart';
import 'package:peopler/core/system_ui_service.dart';
import 'package:peopler/presentation/screens/SUBSCRIPTIONS/subscriptions_page.dart';
import 'package:peopler/presentation/screens/TUTORIAL/constants.dart';
import 'package:peopler/presentation/screens/TUTORIAL/onboardingscreen.dart';
import '../../../../business_logic/blocs/FeedBloc/feed_bloc.dart';
import '../../../../business_logic/blocs/FeedBloc/feed_event.dart';
import '../../../../business_logic/blocs/FeedBloc/feed_state.dart';
import '../../../../business_logic/blocs/UserBloc/bloc.dart';
import '../../../../others/classes/variables.dart';
import '../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../others/locator.dart';
import '../../../../others/empty_list.dart';
import 'each_feed.dart';
import 'feed_functions.dart';
import 'package:peopler/components/FlutterWidgets/text_style.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);
  @override
  State<FeedScreen> createState() => FeedScreenState();
}

class FeedScreenState extends State<FeedScreen> {
  late final FeedBloc _feedBloc;
  late final LocationPermissionBloc _locationPermissionBloc;
  late final LocationUpdateBloc _locationUpdateBloc;

  late ScrollController _scrollController;

  final Mode _mode = locator<Mode>();

  bool loading = false;

  @override
  void initState() {
    super.initState();

    _feedBloc = BlocProvider.of<FeedBloc>(context);
    _feedBloc.add(GetInitialDataEvent());

    _locationPermissionBloc = BlocProvider.of<LocationPermissionBloc>(context);
    _locationPermissionBloc.add(GetLocationPermissionForHomeScreenEvent());

    _locationUpdateBloc = BlocProvider.of<LocationUpdateBloc>(context);
    _locationUpdateBloc.add(StartLocationUpdatesForeground());
    _locationUpdateBloc.add(StartLocationUpdatesBackground());

    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingTopSafeArea = MediaQuery.of(context).padding.top;

    return SafeArea(
      child: ValueListenableBuilder(
          valueListenable: setTheme,
          builder: (context, x, y) {
            debugPrint("~~~~~~~~~~~~~~~~feed~~~~~~~~~~~~~~~");
            debugPrint(Mode.isEnableDarkMode.toString());
            return Stack(
              children: [
                Container(
                  color: Mode().homeScreenScaffoldBackgroundColor(),
                  height: screenHeight - paddingTopSafeArea - 50,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (ScrollNotification scrollNotification) => _listScrollListener(),
                    child: RefreshIndicator(
                      color: const Color(0xFF0353EF),
                      displacement: 120.0,
                      onRefresh: () async {
                        /// Refresh feeds
                        await _feedBloc.getRefreshIndicatorData();
                      },
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BlocBuilder<FeedBloc, FeedState>(
                              bloc: _feedBloc,
                              builder: (context, state) {
                                if (state is InitialFeedState) {
                                  return _initialFeedsStateWidget();
                                } else if (state is FeedNotExistState) {
                                  return _noFeedExistsWidget();
                                } else if (state is FeedsLoadedState) {
                                  loading = false;
                                  return _showFeedsWidget();
                                } else if (state is NoMoreFeedsState) {
                                  return _showFeedsWidget();
                                } else if (state is NewFeedsLoadingState) {
                                  return _showFeedsWidget();
                                } else {
                                  return const Text("Impossible");
                                }
                              },
                            ),
                            BlocBuilder<FeedBloc, FeedState>(
                                bloc: _feedBloc,
                                builder: (context, state) {
                                  if (state is NewFeedsLoadingState && _feedBloc.allFeedList.length > 5) {
                                    return _feedsLoadingCircularButton();
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
                _buildAppBar(context, screenWidth, _scrollController),
              ],
            );
          }),
    );
  }

  Column _buildAppBar(BuildContext context, double screenWidth, _scrollController) {
    return Column(
      children: [
        _buildTopAppBar(_scrollController),
        _buildBottomAppBar(context, screenWidth),
      ],
    );
  }

  Widget _buildBottomAppBar(BuildContext context, double screenWidth) {
    return MediaQuery.of(context).size.width < 340
        ? const SizedBox()
        : ValueListenableBuilder(
            valueListenable: Variables.animatedContainerHeight,
            builder: (context, value, _) {
              return AnimatedContainer(
                color: _mode.bottomMenuBackground(),
                height: Variables.animatedContainerHeight.value,
                duration: const Duration(milliseconds: 250),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        if (TutorialDataList.screen_list.length != 3) {
                          TutorialDataList.prepareDataList();
                        }
                        UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
                        _userBloc.mainKey.currentState?.push(
                          MaterialPageRoute(builder: (context) => const TutorialScreen()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        height: 30,
                        width: screenWidth > 600 ? 298 : (screenWidth - 50) / 2,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0353EF),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/images/svg_icons/compass.svg",
                              width: 20,
                              height: 20,
                              fit: BoxFit.contain,
                            ),
                            Text(
                              " Başlangıç rehberi",
                              textScaleFactor: 1,
                              style: PeoplerTextStyle.normal.copyWith(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    InkWell(
                      onTap: () {
                        UserBloc _userBloc = BlocProvider.of<UserBloc>(context);
                        _userBloc.mainKey.currentState?.push(
                          MaterialPageRoute(builder: (context) => const SubscriptionsPage()),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        height: 30,
                        width: screenWidth > 600 ? 298 : (screenWidth - 50) / 2,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0353EF),
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              "assets/images/svg_icons/ppl_mini_logo.svg",
                              width: 20,
                              height: 20,
                              fit: BoxFit.contain,
                            ),
                            Text(
                              " Ayrıcalıkları Keşfet",
                              textScaleFactor: 1,
                              style: PeoplerTextStyle.normal.copyWith(color: Colors.white, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
  }

  ValueListenableBuilder<double> _buildTopAppBar(_scrollController) {
    return ValueListenableBuilder(
        valueListenable: Variables.animatedAppBarHeight,
        builder: (context, value, _) {
          return AnimatedContainer(
            color: _mode.bottomMenuBackground(),
            height: Variables.animatedAppBarHeight.value,
            duration: const Duration(milliseconds: 250),
            child: PeoplerAppBars(context: context).FEED(titleFunction: () {
              op_peopler_title(context, _scrollController);
            }, leadingFunction: () {
              op_settings_icon(context);
            }),
          );
        });
  }

  /// This function is triggered when the user presses the Event tab button when the currentTab is Event
  void scrollToTop() {
    /// Scroll to Top
    _scrollController.animateTo(0, duration: const Duration(milliseconds: 100), curve: Curves.linear);

    /// Animate app bar
    if (Variables.animatedContainerHeight.value != 30) {
      Variables.animatedAppBarHeight.value = 70;

      Future.delayed(const Duration(milliseconds: 450), () {
        Variables.animatedContainerHeight.value = 30;
      });
    }

    /// Refresh users
    _feedBloc.add(GetRefreshDataEvent());
  }

  bool _listScrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
      if (Variables.animatedContainerHeight.value != 30) {
        Variables.animatedAppBarHeight.value = 70;

        Future.delayed(const Duration(milliseconds: 450), () {
          Variables.animatedContainerHeight.value = 30;
        });
      }
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      if (Variables.animatedContainerHeight.value != 0) {
        Variables.animatedContainerHeight.value = 0;

        Future.delayed(const Duration(milliseconds: 450), () {
          Variables.animatedAppBarHeight.value = 0;
        });
      }
    }

    var nextPageTrigger = 0.8 * _scrollController.position.maxScrollExtent;

    if(_scrollController.position.userScrollDirection ==  ScrollDirection.reverse &&
        _scrollController.position.pixels >= nextPageTrigger) {
      if (loading == false) {
        loading = true;
        debugPrint("hello");
        _feedBloc.add(GetMoreDataEvent());
      }
    }

    return true;
  }

  Padding _feedsLoadingCircularButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: const [
        Expanded(flex: 5, child: SizedBox()),
        Flexible(flex: 1, child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator())),
        Expanded(flex: 5, child: SizedBox()),
      ]),
    );
  }

  _showFeedsWidget() {
    return Column(
      children: [
        ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: NeverScrollableScrollPhysics()),
          shrinkWrap: true,
          itemCount: _feedBloc.allFeedList.length,
          itemBuilder: (context, i) {
            eachFeedWidget eachFeed = eachFeedWidget(myFeed: _feedBloc.allFeedList[i], index: i);
            return eachFeed;
          },
        ),
      ],
    );
  }

  SizedBox _initialFeedsStateWidget() {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        child: const Center(
          child: CircularProgressIndicator(),
        ));
  }

  EmptyList _noFeedExistsWidget() {
    return const EmptyList(
      emptyListType: EmptyListType.emptyFeed,
      isSVG: true,
    );
  }
}

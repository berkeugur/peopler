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
import 'package:peopler/core/constants/scroll_animation_activation.dart';
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
import 'feed_app_bar.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return SafeArea(
            child: NestedScrollView(
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
                    sliver: MyFeedAppBar(),
                  ),
                ];
              },
              body: Builder(
                // This Builder is needed to provide a BuildContext that is "inside"
                // the NestedScrollView, so that sliverOverlapAbsorberHandleFor() can
                // find the NestedScrollView.
                builder: (BuildContext context) {
                  _scrollController = context.findAncestorStateOfType<NestedScrollViewState>()!.innerController;
                  if (_scrollController.hasListeners == false) {
                    _scrollController.addListener(_listScrollListener);
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      /// Refresh feeds
                      await _feedBloc.getRefreshIndicatorData();
                    },
                    child: CustomScrollView(
                      // The controller must be the inner controller of nested scroll view widget.
                      controller: _scrollController,
                      slivers: <Widget>[
                        SliverOverlapInjector(
                          // This is the flip side of the SliverOverlapAbsorber above.
                          handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                        ),
                        BlocBuilder<FeedBloc, FeedState>(
                          bloc: _feedBloc,
                          builder: (context, state) {
                            if (state is InitialFeedState) {
                              return _initialFeedsStateWidget();
                            } else if (state is FeedNotExistState) {
                              return _noFeedExistsWidget();
                            } else if (state is FeedsLoaded1State) {
                              loading = false;
                              return _showFeedsWidget();
                            } else if (state is FeedsLoaded2State) {
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
                                return const SliverToBoxAdapter(child: SizedBox.shrink());
                              }
                            }),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        });
  }

  /// This function is triggered when the user presses the Event tab button when the currentTab is Event
  void scrollToTop() {
    /// Scroll to Top
    /// -100 is the offset. Since scrollController is inner, offset=0 is not enough to expand SliverAppBar so we use -100
    _scrollController.animateTo(-100, duration: const Duration(milliseconds: 500), curve: Curves.decelerate).then((value) => null);
  }

  bool _listScrollListener() {
    var nextPageTrigger = 0.8 * _scrollController.position.maxScrollExtent;

    if (_scrollController.position.axisDirection == AxisDirection.down && _scrollController.position.pixels >= nextPageTrigger) {
      if (loading == false) {
        loading = true;
        debugPrint("hello");
        _feedBloc.add(GetMoreDataEvent());
      }
    }

    return true;
  }

  SliverToBoxAdapter _feedsLoadingCircularButton() {
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

  _showFeedsWidget() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return eachFeedWidget(myFeed: _feedBloc.allFeedList[index]);
        },
        childCount: _feedBloc.allFeedList.length,
      ),
    );
  }

  SliverToBoxAdapter _initialFeedsStateWidget() {
    return SliverToBoxAdapter(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: const Center(
              child: CircularProgressIndicator(),
            )));
  }

  SliverToBoxAdapter _noFeedExistsWidget() {
    return const SliverToBoxAdapter(
      child: EmptyList(
        emptyListType: EmptyListType.emptyFeed,
        isSVG: true,
      ),
    );
  }
}

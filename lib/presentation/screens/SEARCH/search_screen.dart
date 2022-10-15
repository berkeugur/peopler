import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/cubits/FloatingActionButtonCubit.dart';
import 'package:peopler/core/constants/enums/screen_item_enum.dart';
import 'package:peopler/core/constants/enums/tab_item_enum.dart';
import 'package:peopler/presentation/screens/SEARCH/city_tab.dart';
import 'package:peopler/presentation/screens/SEARCH/nearby_tab.dart';
import 'package:peopler/presentation/screens/SEARCH/seach_peoples_header.dart';
import 'package:provider/provider.dart';
import '../../../business_logic/blocs/CityBloc/bloc.dart';
import '../../../business_logic/blocs/LocationBloc/bloc.dart';
import '../../../business_logic/blocs/LocationPermissionBloc/bloc.dart';
import '../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../business_logic/cubits/ThemeCubit.dart';

import 'city_nearby_buttons.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  double? loadMoreOffset;
  double? userHeight;

  late final ThemeCubit _themeCubit;
  late final FloatingActionButtonCubit _homeScreen;

  final GlobalKey showWidgetsKeyNearby = GlobalKey();
  final GlobalKey showWidgetsKeyCity = GlobalKey();

  @override
  void initState() {
    super.initState();

    _themeCubit = BlocProvider.of<ThemeCubit>(context);
    _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);
  }

  // didChangeDependencies method runs after initState method. Since MediaQuery should run after initState method,
  // variables are initialized in didChangeDependencies method running after initState but before build method.
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userHeight = MediaQuery.of(context).size.height / 2;
    loadMoreOffset = userHeight;
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    double paddingTopSafeArea = MediaQuery.of(context).padding.top;
    double screenHeight = MediaQuery.of(context).size.height;

    return ValueListenableBuilder(
        valueListenable: setTheme,
        builder: (context, x, y) {
          return ChangeNotifierProvider.value(
            value: CityNearbyButtons(),
            child: Builder(builder: (context) {
              bool _isNearby = Provider.of<CityNearbyButtons>(context).isNearby;

              if (_isNearby == true) {
                _homeScreen.currentScreen = {TabItem.search: ScreenItem.searchNearByScreen};
              } else {
                _homeScreen.currentScreen = {TabItem.search: ScreenItem.searchCityScreen};
              }
              _homeScreen.changeFloatingActionButtonEvent();

              double _maxWidth = _size.width > 400 ? 400 : _size.width;

              return BlocBuilder<ThemeCubit, bool>(
                  bloc: _themeCubit,
                  builder: (_, state) {
                    return Stack(children: [
                      _isNearby == true
                          ? NearbyTab(
                              screenHeight: screenHeight,
                              paddingTopSafeArea: paddingTopSafeArea,
                              maxWidth: _maxWidth,
                              context: context,
                              size: _size,
                              showWidgetsKeyNearby: showWidgetsKeyNearby,
                              showWidgetsKeyCity: showWidgetsKeyCity)
                          : CityTab(
                              screenHeight: screenHeight,
                              paddingTopSafeArea: paddingTopSafeArea,
                              maxWidth: _maxWidth,
                              context: context,
                              size: _size,
                              showWidgetsKeyNearby: showWidgetsKeyNearby,
                              showWidgetsKeyCity: showWidgetsKeyCity),
                      search_peoples_header(),
                    ]);
                  });
            }),
          );
        });
  }
}


// CityNearbyButtons
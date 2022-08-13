import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/cubits/FloatingActionButtonCubit.dart';
import 'package:peopler/presentation/screens/search/city_tab.dart';
import 'package:peopler/presentation/screens/search/nearby_tab.dart';
import 'package:peopler/presentation/screens/search/seach_peoples_header.dart';
import 'package:provider/provider.dart';
import '../../../business_logic/blocs/CityBloc/bloc.dart';
import '../../../business_logic/blocs/LocationBloc/bloc.dart';
import '../../../business_logic/blocs/LocationPermissionBloc/bloc.dart';
import '../../../business_logic/blocs/UserBloc/user_bloc.dart';
import '../../../business_logic/cubits/ThemeCubit.dart';
import '../../tab_item.dart';
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

  late final LocationBloc _locationBloc;
  late final LocationPermissionBloc _locationPermissionBloc;
  late final CityBloc _cityBloc;

  final GlobalKey showWidgetsKeyNearby = GlobalKey();
  final GlobalKey showWidgetsKeyCity = GlobalKey();

  @override
  void initState() {
    super.initState();

    _themeCubit = BlocProvider.of<ThemeCubit>(context);
    _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);
    _locationBloc = BlocProvider.of<LocationBloc>(context);
    _locationPermissionBloc = BlocProvider.of<LocationPermissionBloc>(context);
    _cityBloc = BlocProvider.of<CityBloc>(context);
    if(UserBloc.user != null) {
      _cityBloc.add(GetInitialSearchUsersCityEvent(city: UserBloc.user!.city));
    }
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
          return BlocListener<LocationPermissionBloc, LocationPermissionState>(
            bloc: _locationPermissionBloc,
            listener: (BuildContext context, state) {
              if (state is ReadyState) {
                _locationBloc.add(GetInitialSearchUsersEvent(latitude: UserBloc.user!.latitude, longitude: UserBloc.user!.longitude));
              }
            },
            child: ChangeNotifierProvider.value(
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
            ),
          );
        });
  }
}


// CityNearbyButtons
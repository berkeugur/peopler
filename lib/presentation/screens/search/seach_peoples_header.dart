import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../../../business_logic/blocs/LocationPermissionBloc/location_permission_bloc.dart';
import '../../../../business_logic/blocs/LocationPermissionBloc/location_permission_event.dart';
import '../../../../others/classes/dark_light_mode_controller.dart';
import '../../../../others/classes/variables.dart';
import '../../../others/locator.dart';
import '../../../business_logic/cubits/FloatingActionButtonCubit.dart';
import '../../../business_logic/cubits/ThemeCubit.dart';
import '../../tab_item.dart';
import 'city_nearby_buttons.dart';

class search_peoples_header extends StatelessWidget {
  search_peoples_header({Key? key}) : super(key: key);

  final Mode _mode = locator<Mode>();

  final String _itemText1 = "Aynı Ortamımdaki";
  final String _itemText2 = "Aynı Şehrimdeki";

  late final Size _size;
  late final ThemeCubit _themeCubit;

  @override
  Widget build(BuildContext context) {
    _themeCubit = BlocProvider.of<ThemeCubit>(context);
    _size = MediaQuery.of(context).size;
    double _x = 20; //amount of space between two containers
    double _y = _size.width > 600 ? 280 : _size.width * 0.40; //the ratio of each container to the screen

    return ValueListenableBuilder(
      valueListenable: Variables.animatedSearchPeopleHeaderHeight,
      builder: (context, snapshot, _) {
        return BlocBuilder<ThemeCubit, bool>(
            bloc: _themeCubit,
            builder: (_, state) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                height: Variables.animatedSearchPeopleHeaderHeight.value,
                color: _mode.search_peoples_scaffold_background(),
                child: Padding(
                    padding: EdgeInsets.only(
                      top: _size.width < 340 ? 45 : 40.0,
                      bottom: 5.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        searchHeaderItem(true, _y, _itemText1, context),
                        searchHeaderItem(false, _y, _itemText2, context),
                      ],
                    )),
              );
            });
      },
    );
  }

  Widget searchHeaderItem(bool index, double itemWidth, String text, context) {
    LocationPermissionBloc _locationPermissionBloc = BlocProvider.of<LocationPermissionBloc>(context);
    FloatingActionButtonCubit _homeScreen = BlocProvider.of<FloatingActionButtonCubit>(context);
    CityNearbyButtons _cityNearbyButtons = Provider.of<CityNearbyButtons>(context);

    return InkWell(
      onTap: () {
        _cityNearbyButtons.isNearby = index;

        if (_cityNearbyButtons.isNearby == true) {
          _homeScreen.currentScreen = {_homeScreen.currentTab: ScreenItem.searchNearByScreen};
          _locationPermissionBloc.add(GetLocationPermissionEvent());
        } else {
          _homeScreen.currentScreen = {_homeScreen.currentTab: ScreenItem.searchCityScreen};
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        margin: EdgeInsets.all(_size.width < 340 ? 1.5 : 5),
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: _cityNearbyButtons.isNearby == index
                  ? const Color(0xFF939393).withOpacity(0.6)
                  : const Color(0xFF939393).withOpacity(0),
              blurRadius: 2.0,
              spreadRadius: 0,
              offset: const Offset(0.0, 0.75),
            ),
          ],
          color: _cityNearbyButtons.isNearby == index ? const Color(0xFF0353EF) : Colors.transparent,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Center(
            child: AutoSizeText(
          text,
          textScaleFactor: 1,
          style: GoogleFonts.rubik(
            color: _cityNearbyButtons.isNearby == index ? Colors.white : _mode.searchHeaderItemText(),
            fontSize: _size.width < 340 ? 12 : 14,
          ),
        )),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'package:peopler/data/model/user.dart';
import 'package:peopler/data/repository/location_repository.dart';
import '../../../others/locator.dart';
import 'bloc.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final LocationRepository _locationRepository = locator<LocationRepository>();

  static List<MyUser> allUserList = [];

  void removeUnnecessaryUsersFromUserList(List<MyUser> userList) {
    if(UserBloc.user != null) {
      /// Remove myself from list
      userList.removeWhere((item) => item.userID == UserBloc.user!.userID);

      List<MyUser> tempList = [...userList];
      for (MyUser tempUser in tempList) {
        if (UserBloc.user!.savedUserIDs.contains(tempUser.userID)) {
          userList.removeWhere((item) => item.userID == tempUser.userID);
        }

        if (UserBloc.user!.transmittedRequestUserIDs.contains(
            tempUser.userID)) {
          userList.removeWhere((item) => item.userID == tempUser.userID);
        }

        if (UserBloc.user!.receivedRequestUserIDs.contains(tempUser.userID)) {
          userList.removeWhere((item) => item.userID == tempUser.userID);
        }

        if (UserBloc.user!.connectionUserIDs.contains(tempUser.userID)) {
          userList.removeWhere((item) => item.userID == tempUser.userID);
        }

        if (UserBloc.user!.whoBlockedYou.contains(tempUser.userID)) {
          userList.removeWhere((item) => item.userID == tempUser.userID);
        }

        if (UserBloc.user!.blockedUsers.contains(tempUser.userID)) {
          userList.removeWhere((item) => item.userID == tempUser.userID);
        }
      }
    }
  }

  /// getRefreshDataFuture function is used in this Refresh Indicator function.
  Future<void> getRefreshIndicatorData(String city) async {
    try {
      allUserList = [];
      _locationRepository.restartRepositoryCache();

      List<MyUser> userList = await _locationRepository.queryUsersCityWithPagination(city, allUserList);

      removeUnnecessaryUsersFromUserList(userList);

      /// await Future.delayed(const Duration(seconds: 2));

      if (userList.isNotEmpty) {
        allUserList.addAll(userList);
        add(TrigUsersLoadedCityStateEvent());
      } else {
        add(TrigUsersNotExistCityStateEvent());
      }
    } catch (e) {
      debugPrint("Blocta initial city hata:" + e.toString());
    }
  }

  CityBloc() : super(InitialCityState()) {

    ///******************************************************************************************
    ///**************************** GET INITIAL *************************************************
    ///******************************************************************************************
    on<GetInitialSearchUsersCityEvent>((event, emit) async {
      try {
        emit(InitialCityState());

        allUserList = [];
        _locationRepository.restartRepositoryCache();

        List<MyUser> userList = await _locationRepository.queryUsersCityWithPagination(event.city, allUserList);

        removeUnnecessaryUsersFromUserList(userList);

        /// await Future.delayed(const Duration(seconds: 2));

        if (userList.isNotEmpty) {
          allUserList.addAll(userList);
          emit(UsersLoadedCityState());
        } else {
          emit(UsersNotExistCityState());
        }
      } catch (e) {
        debugPrint("Blocta initial location hata:" + e.toString());
      }
    });


    /// *****************************************************************************************
    ///**************************** GET MORE ****************************************************
    ///******************************************************************************************
    on<GetMoreSearchUsersCityEvent>((event, emit) async {
      try {
        emit(NewUsersLoadingCityState());

        List<MyUser> userList = await _locationRepository.queryUsersCityWithPagination(event.city, allUserList);

        removeUnnecessaryUsersFromUserList(userList);

        /// await Future.delayed(const Duration(seconds: 2));

        if (userList.isNotEmpty) {
          allUserList.addAll(userList);
          emit(UsersLoadedCityState());
        } else {
          if (allUserList.isNotEmpty) {
            emit(NoMoreUsersCityState());
          } else {
            emit(UsersNotExistCityState());
          }
        }
      } catch (e) {
        debugPrint("Blocta get more location event hata:" + e.toString());
      }
    });
    ///******************************************************************************************
    ///******************************************************************************************
    ///******************************************************************************************

    on<TrigUsersLoadedCityStateEvent>((event, emit) async {
      emit(UsersLoadedCityState());
    });

    on<TrigUsersNotExistCityStateEvent>((event, emit) async {
      emit(UsersNotExistCityState());
    });
  }
}

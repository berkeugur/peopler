import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'package:peopler/data/model/user.dart';
import 'package:peopler/data/repository/location_repository.dart';
import '../../../data/repository/user_repository.dart';
import '../../../others/locator.dart';
import 'bloc.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final LocationRepository _locationRepository = locator<LocationRepository>();
  final UserRepository _userRepository = locator<UserRepository>();

  static List<MyUser> allUserList = [];

  static StreamSubscription? _streamSubscription;
  static bool _newUserListenListener = false;

  void removeUnnecessaryUsersFromUserList(List<MyUser> userList, MyUser myUser) {
    /// Remove myself from list
    userList.removeWhere((item) => item.userID == myUser.userID);

    List<MyUser> tempList = [...userList];
    for (MyUser tempUser in tempList) {
      if (myUser.savedUserIDs.contains(tempUser.userID)) {
        userList.removeWhere((item) => item.userID == tempUser.userID);
      }

      if (myUser.transmittedRequestUserIDs.contains(
          tempUser.userID)) {
        userList.removeWhere((item) => item.userID == tempUser.userID);
      }

      if (myUser.receivedRequestUserIDs.contains(
          tempUser.userID)) {
        userList.removeWhere((item) => item.userID == tempUser.userID);
      }

      if (myUser.connectionUserIDs.contains(tempUser.userID)) {
        userList.removeWhere((item) => item.userID == tempUser.userID);
      }

      if (myUser.whoBlockedYou.contains(tempUser.userID)) {
        userList.removeWhere((item) => item.userID == tempUser.userID);
      }

      if (myUser.blockedUsers.contains(tempUser.userID)) {
        userList.removeWhere((item) => item.userID == tempUser.userID);
      }
    }
  }

  /// getRefreshDataFuture function is used in this Refresh Indicator function.
  Future<void> getRefreshIndicatorData(String city) async {
    try {
      allUserList = [];
      _locationRepository.restartRepositoryCache();

      List<MyUser> userList = await _locationRepository.queryUsersCityWithPagination(city, allUserList);

      removeUnnecessaryUsersFromUserList(userList, UserBloc.user!);

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

        removeUnnecessaryUsersFromUserList(userList, UserBloc.user!);

        /// await Future.delayed(const Duration(seconds: 2));
        if (userList.isNotEmpty) {
          allUserList.addAll(userList);
          emit(UsersLoadedCityState());
        } else {
          emit(UsersNotExistCityState());
        }

        if (_newUserListenListener == false) {
          _newUserListenListener = true;
          _streamSubscription = _userRepository
              .getMyUserWithStream(UserBloc.user!.userID)
              .listen((myUser) async {

            add(NewUserListenerEvent(myUser: myUser));
          });
        }
      } catch (e) {
        debugPrint("Blocta initial city hata:" + e.toString());
      }
    });


    /// *****************************************************************************************
    ///**************************** GET MORE ****************************************************
    ///******************************************************************************************
    on<GetMoreSearchUsersCityEvent>((event, emit) async {
      try {
        emit(NewUsersLoadingCityState());

        List<MyUser> userList = await _locationRepository.queryUsersCityWithPagination(event.city, allUserList);

        removeUnnecessaryUsersFromUserList(userList, UserBloc.user!);

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
      if(allUserList.isEmpty) {
        emit(UsersNotExistCityState());
      } else {
        emit(NewUsersLoadingCityState());
        emit(UsersLoadedCityState());
      }
    });
    on<NewUserListenerEvent>((event, emit) async {
      removeUnnecessaryUsersFromUserList(allUserList, event.myUser);
      add(TrigUsersNotExistCityStateEvent());
    });
  }

  @override
  Future<void> close() async {
    await closeStreams();
    await super.close();
  }

  static Future<void> closeStreams() async {
    if (_streamSubscription != null) {
      await _streamSubscription?.cancel();
    }
  }
}
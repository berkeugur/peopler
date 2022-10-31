import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'package:peopler/data/model/user.dart';
import '../../../data/repository/city_repository.dart';
import '../../../data/repository/user_repository.dart';
import '../../../others/locator.dart';
import 'bloc.dart';

class CityBloc extends Bloc<CityEvent, CityState> {
  final CityRepository _cityRepository = locator<CityRepository>();
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
      _cityRepository.restartRepositoryCache();

      List<MyUser> userList = await _cityRepository.queryUsersCityWithPagination(city);

      removeUnnecessaryUsersFromUserList(userList, UserBloc.user!);

      allUserList.addAll(userList);
      add(TrigUsersNotExistCityStateEvent());
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
        _cityRepository.restartRepositoryCache();

        List<MyUser> userList = await _cityRepository.queryUsersCityWithPagination(event.city);

        removeUnnecessaryUsersFromUserList(userList, UserBloc.user!);

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

        List<MyUser> userList = await _cityRepository.queryUsersCityWithPagination(event.city);

        removeUnnecessaryUsersFromUserList(userList, UserBloc.user!);

        if (userList.isNotEmpty) {
          allUserList.addAll(userList);

          List<MyUser> uniqueItems = [];
          var uniqueIDs = allUserList
              .map((e) => e.userID)
              .toSet(); //list if UniqueID to remove duplicates
          for (var e in uniqueIDs) {
            uniqueItems.add(allUserList.firstWhere((i) => i.userID == e));
          }
          allUserList = [];
          allUserList.addAll(uniqueItems);

          emit(UsersLoadedCityState());
        } else {
          if (allUserList.isNotEmpty) {
            emit(NoMoreUsersCityState());
          } else {
            emit(UsersNotExistCityState());
          }
        }
      } catch (e) {
        debugPrint("Blocta get more city event hata:" + e.toString());
      }
    });
    ///******************************************************************************************
    ///******************************************************************************************
    ///******************************************************************************************

    on<TrigUsersNotExistCityStateEvent>((event, emit) async {
      if(allUserList.isEmpty) {
        emit(UsersNotExistCityState());
      } else {
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
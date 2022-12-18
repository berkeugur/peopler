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

  static Set<String> unnecessaryUsers = {};

  CityBloc() : super(InitialCityState()) {
    on<ResetCityEvent>((event, emit) async {
      emit(InitialCityState());
    });

    ///******************************************************************************************
    ///**************************** GET INITIAL *************************************************
    ///******************************************************************************************
    on<GetInitialSearchUsersCityEvent>((event, emit) async {
      try {
        emit(InitialCityState());

        allUserList = [];
        _cityRepository.restartRepositoryCache();

        findUnnecessaryUsersFromUserList();

        List<MyUser> userList = await _cityRepository.queryUsersCityWithPagination(event.city, unnecessaryUsers);
        userList.shuffle();

        if (userList.isNotEmpty) {
          allUserList.addAll(userList);
          emit(UsersLoadedCity1State());
        } else {
          emit(UsersNotExistCityState());
        }

        if (_newUserListenListener == false) {
          _newUserListenListener = true;
          _streamSubscription = _userRepository.getMyUserWithStream(UserBloc.user!.userID).listen((myUser) async {
            add(NewUserListenerEvent(myUser: myUser, city: event.city));
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

        findUnnecessaryUsersFromUserList();

        List<MyUser> userList = await _cityRepository.queryUsersCityWithPagination(event.city, unnecessaryUsers);
        userList.shuffle();

        if (userList.isNotEmpty) {
          allUserList.addAll(userList);
          if (state is UsersLoadedCity1State) {
            emit(UsersLoadedCity2State());
          } else {
            emit(UsersLoadedCity1State());
          }
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
      if (allUserList.isEmpty) {
        emit(UsersNotExistCityState());
      } else {
        if (state is UsersLoadedCity1State) {
          emit(UsersLoadedCity2State());
        } else {
          emit(UsersLoadedCity1State());
        }
      }

      if (allUserList.length < 5) {
        add(GetMoreSearchUsersCityEvent(city: event.city));
      }
    });

    on<NewUserListenerEvent>((event, emit) async {
      removeUnnecessaryUsersFromUserList(allUserList, event.myUser);
      add(TrigUsersNotExistCityStateEvent(city: event.city));
    });
  }

  void findUnnecessaryUsersFromUserList() {
    unnecessaryUsers = {};
    unnecessaryUsers.add(UserBloc.user!.userID);
    unnecessaryUsers.addAll(UserBloc.user!.savedUserIDs);
    unnecessaryUsers.addAll(UserBloc.user!.transmittedRequestUserIDs);
    unnecessaryUsers.addAll(UserBloc.user!.receivedRequestUserIDs);
    unnecessaryUsers.addAll(UserBloc.user!.connectionUserIDs);
    unnecessaryUsers.addAll(UserBloc.user!.whoBlockedYou);
    unnecessaryUsers.addAll(UserBloc.user!.blockedUsers);
  }

  void removeUnnecessaryUsersFromUserList(List<MyUser> userList, MyUser myUser) {
    /// Remove myself from list
    userList.removeWhere((item) => item.userID == myUser.userID);

    List<MyUser> tempList = [...userList];
    for (MyUser tempUser in tempList) {
      if (myUser.savedUserIDs.contains(tempUser.userID)) {
        userList.removeWhere((item) => item.userID == tempUser.userID);
      }

      if (myUser.transmittedRequestUserIDs.contains(tempUser.userID)) {
        userList.removeWhere((item) => item.userID == tempUser.userID);
      }

      if (myUser.receivedRequestUserIDs.contains(tempUser.userID)) {
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

      findUnnecessaryUsersFromUserList();

      List<MyUser> userList = await _cityRepository.queryUsersCityWithPagination(city, unnecessaryUsers);

      allUserList.addAll(userList);
      add(TrigUsersNotExistCityStateEvent(city: UserBloc.user!.city));
    } catch (e) {
      debugPrint("Blocta initial city hata:" + e.toString());
    }
  }

  void resetBloc() {
    /// Close streams
    closeStreams();

    /// Reset variables
    allUserList = [];
    _streamSubscription = null;
    _newUserListenListener = false;
    unnecessaryUsers = {};

    /// set initial state
    add(ResetCityEvent());
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

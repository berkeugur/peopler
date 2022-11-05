import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/LocationUpdateBloc/bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'package:peopler/data/model/user.dart';
import 'package:peopler/data/repository/location_repository.dart';
import '../../../data/repository/user_repository.dart';
import '../../../others/locator.dart';
import 'bloc.dart';
import 'dart:async';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository _locationRepository = locator<LocationRepository>();
  final UserRepository _userRepository = locator<UserRepository>();

  static List<MyUser> allUserList = [];
  static StreamSubscription? _streamSubscription;
  static bool _newUserListenListener = false;

  static List<String> _queryList = List.filled(9, '');

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
  Future<void> getRefreshIndicatorData() async {
    try {
        int _latitude;
        int _longitude;

        if (UserBloc.user != null) {
          _latitude = UserBloc.user!.latitude;
          _longitude = UserBloc.user!.longitude;
        } else {
          _latitude = UserBloc.guestUser!.latitude;
          _longitude = UserBloc.guestUser!.longitude;
        }

        _locationRepository.restartRepositoryCache();

        _queryList = _locationRepository.determineQueryList(_latitude, _longitude);
        List<MyUser> userList = await _locationRepository.queryUsersWithPagination(_queryList);

        if(UserBloc.user != null) {
          removeUnnecessaryUsersFromUserList(userList, UserBloc.user!);
        }

        allUserList = [];

        if (userList.isNotEmpty) {
          allUserList.addAll(userList);
          add(TrigUsersLoadedSearchStateEvent());
        } else {
          add(TrigUsersNotExistSearchStateEvent());
        }
    } catch (e) {
      debugPrint("Blocta refresh event hata:" + e.toString());
    }
  }

  LocationBloc() : super(InitialSearchState()) {
    /******************************************************************************************/
    /**************************** NEARBY USERS ************************************************/
    /******************************************************************************************/
    on<GetInitialSearchUsersEvent>((event, emit) async {
      try {
        while(LocationUpdateBloc.firstUpdate == false) {
          await Future.delayed(const Duration(seconds: 1));
        }

        int _latitude;
        int _longitude;

        if (UserBloc.user != null) {
          _latitude = UserBloc.user!.latitude;
          _longitude = UserBloc.user!.longitude;
        } else {
          _latitude = UserBloc.guestUser!.latitude;
          _longitude = UserBloc.guestUser!.longitude;
        }

        emit(InitialSearchState());

        allUserList = [];
        _locationRepository.restartRepositoryCache();

        _queryList = await _locationRepository.determineQueryList(_latitude, _longitude);
        List<MyUser> userList = await _locationRepository.queryUsersWithPagination(_queryList);

        if(UserBloc.user != null) {
          removeUnnecessaryUsersFromUserList(userList, UserBloc.user!);
        }

        if (userList.isNotEmpty) {
          allUserList.addAll(userList);
          emit(UsersLoadedSearchState());
        } else {
          emit(UsersNotExistSearchState());
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
        debugPrint("Blocta initial location hata:" + e.toString());
      }
    });

    on<GetMoreSearchUsersEvent>((event, emit) async {
      try {
        emit(NewUsersLoadingSearchState());

        List<MyUser> userList = await _locationRepository.queryUsersWithPagination(_queryList);

        if(UserBloc.user != null) {
          removeUnnecessaryUsersFromUserList(userList, UserBloc.user!);
        }

        if (userList.isNotEmpty) {
          allUserList.addAll(userList);
          emit(UsersLoadedSearchState());
        } else {
          if (allUserList.isNotEmpty) {
            emit(NoMoreUsersSearchState());
          } else {
            emit(UsersNotExistSearchState());
          }
        }
      } catch (e) {
        debugPrint("Blocta get more location event hata:" + e.toString());
      }
    });

    on<TrigUsersLoadedSearchStateEvent>((event, emit) async {
      emit(UsersLoadedSearchState());
    });

    on<TrigUsersNotExistSearchStateEvent>((event, emit) async {
      if(allUserList.isEmpty) {
        emit(UsersNotExistSearchState());
      } else {
        emit(UsersLoadedSearchState());
      }
    });

    on<NewUserListenerEvent>((event, emit) async {
      removeUnnecessaryUsersFromUserList(allUserList, event.myUser);
      add(TrigUsersNotExistSearchStateEvent());
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

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'package:peopler/data/model/user.dart';
import 'package:peopler/data/repository/location_repository.dart';
import '../../../others/locator.dart';
import 'bloc.dart';
import 'dart:async';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository _locationRepository = locator<LocationRepository>();

  static List<MyUser> allUserList = [];
  StreamSubscription? _streamSubscription;

  List<String> _queryList = List.filled(9, '');

  void removeUnnecessaryUsersFromUserList(List<MyUser> userList) {
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

      if (UserBloc.user!.receivedRequestUserIDs.contains(
          tempUser.userID)) {
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

  /// getRefreshDataFuture function is used in this Refresh Indicator function.
  Future<void> getRefreshIndicatorData(int latitude, int longitude) async {
    try {
        _locationRepository.restartRepositoryCache();

        _queryList = await _locationRepository.determineQueryList(latitude, longitude);
        List<MyUser> userList = await _locationRepository.queryUsersWithPagination(_queryList);

        if(UserBloc.user != null) {
          removeUnnecessaryUsersFromUserList(userList);
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
        emit(InitialSearchState());

        allUserList = [];
        _locationRepository.restartRepositoryCache();

        _queryList = await _locationRepository.determineQueryList(event.latitude, event.longitude);
        List<MyUser> userList = await _locationRepository.queryUsersWithPagination(_queryList);

        if(UserBloc.user != null) {
          removeUnnecessaryUsersFromUserList(userList);
        }

        // await Future.delayed(const Duration(seconds: 2));

        if (userList.isNotEmpty) {
          allUserList.addAll(userList);
          emit(UsersLoadedSearchState());
        } else {
          emit(UsersNotExistSearchState());
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
          removeUnnecessaryUsersFromUserList(userList);
        }

        // await Future.delayed(const Duration(seconds: 2));

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
      emit(UsersNotExistSearchState());
    });

  }

  @override
  Future<void> close() async {
    if (_streamSubscription != null) {
      _streamSubscription?.cancel();
    }
    super.close();
  }
}

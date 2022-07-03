import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'package:peopler/data/model/user.dart';
import 'package:peopler/data/repository/location_repository.dart';
import '../../../others/locator.dart';
import 'bloc.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final LocationRepository _locationRepository = locator<LocationRepository>();

  List<MyUser> _allUserList = [];
  List<MyUser> get allUserList => _allUserList;

  List<String> _queryList = List.filled(9, '');

  LocationBloc() : super(InitialSearchState()) {
    /******************************************************************************************/
    /**************************** NEARBY USERS ************************************************/
    /******************************************************************************************/
    on<GetInitialSearchUsersEvent>((event, emit) async {
      try {
        emit(InitialSearchState());

        _allUserList = [];
        _locationRepository.restartRepositoryCache();

        _queryList = await _locationRepository.determineQueryList(event.latitude, event.longitude);
        List<MyUser> userList = await _locationRepository.queryUsersWithPagination(_queryList);

        /// Remove myself from list
        userList.removeWhere((item) => item.userID == UserBloc.user!.userID);

        List<MyUser> tempList = [...userList];
        for(MyUser tempUser in  tempList){
          if(UserBloc.user!.savedUserIDs.contains(tempUser.userID)){
            userList.removeWhere((item) => item.userID == tempUser.userID);
          }

          if(UserBloc.user!.transmittedRequestUserIDs.contains(tempUser.userID)){
            userList.removeWhere((item) => item.userID == tempUser.userID);
          }

          if(UserBloc.user!.receivedRequestUserIDs.contains(tempUser.userID)){
            userList.removeWhere((item) => item.userID == tempUser.userID);
          }

          if(UserBloc.user!.connectionUserIDs.contains(tempUser.userID)){
            userList.removeWhere((item) => item.userID == tempUser.userID);
          }
        }

        // await Future.delayed(const Duration(seconds: 2));

        if (userList.isNotEmpty) {
          _allUserList.addAll(userList);
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

        /// Remove myself from list
        userList.removeWhere((item) => item.userID == UserBloc.user!.userID);

        List<MyUser> tempList = [...userList];
        for(MyUser tempUser in  tempList){
          if(UserBloc.user!.savedUserIDs.contains(tempUser.userID)){
            userList.removeWhere((item) => item.userID == tempUser.userID);
          }

          if(UserBloc.user!.transmittedRequestUserIDs.contains(tempUser.userID)){
            userList.removeWhere((item) => item.userID == tempUser.userID);
          }

          if(UserBloc.user!.receivedRequestUserIDs.contains(tempUser.userID)){
            userList.removeWhere((item) => item.userID == tempUser.userID);
          }

          if(UserBloc.user!.connectionUserIDs.contains(tempUser.userID)){
            userList.removeWhere((item) => item.userID == tempUser.userID);
          }
        }

        // await Future.delayed(const Duration(seconds: 2));

        if (userList.isNotEmpty) {
          _allUserList.addAll(userList);
          emit(UsersLoadedSearchState());
        } else {
          if (_allUserList.isNotEmpty) {
            emit(NoMoreUsersSearchState());
          } else {
            emit(UsersNotExistSearchState());
          }
        }
      } catch (e) {
        debugPrint("Blocta get more location event hata:" + e.toString());
      }
    });
  }
}

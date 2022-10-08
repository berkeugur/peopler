import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/core/constants/enums/subscriptions_enum.dart';
import 'package:peopler/data/model/saved_user.dart';
import 'package:peopler/data/repository/saved_repository.dart';

import '../../../others/locator.dart';
import '../UserBloc/user_bloc.dart';
import 'bloc.dart';

class SavedBloc extends Bloc<SavedEvent, SavedState> {
  final SavedRepository _savedRepository = locator<SavedRepository>();
  List<SavedUser> _allSavedUserList = [];
  List<SavedUser> get allRequestList => _allSavedUserList;

  SavedBloc() : super(InitialSavedState()) {
    on<GetInitialSavedUsersEvent>((event, emit) async {
      try {
        emit(InitialSavedState());

        _allSavedUserList = [];
        _savedRepository.restartSavedCache();

        List<SavedUser> savedUserList = await _savedRepository.getSavedUsersWithPagination(event.myUserID, null);

        List<SavedUser> tempList = [...savedUserList];
        for(SavedUser tempUser in  tempList){
          if(UserBloc.user!.receivedRequestUserIDs.contains(tempUser.userID)){
            savedUserList.removeWhere((item) => item.userID == tempUser.userID);
            await _savedRepository.deleteSavedUser(UserBloc.user!.userID, tempUser.userID);
          }
        }

        if (savedUserList.isNotEmpty) {
          _allSavedUserList.addAll(savedUserList);
          emit(UsersLoadedSavedState());
        } else {
          emit(UserNotExistSavedState());
        }
      } catch (e) {
        debugPrint("Blocta initial saved hata:" + e.toString());
      }
    });

    on<GetMoreSavedUsersEvent>((event, emit) async {
      try {
        emit(NewUsersLoadingSavedState());

        List<SavedUser> savedUserList = await _savedRepository.getSavedUsersWithPagination(event.myUserID, _allSavedUserList.last);

        List<SavedUser> tempList = [...savedUserList];
        for(SavedUser tempUser in  tempList){
          if(UserBloc.user!.receivedRequestUserIDs.contains(tempUser.userID)){
            savedUserList.removeWhere((item) => item.userID == tempUser.userID);
          }

          await _savedRepository.deleteSavedUser(UserBloc.user!.userID, tempUser.userID);
        }

        // await Future.delayed(const Duration(seconds: 2));

        if (savedUserList.isNotEmpty) {
          _allSavedUserList.addAll(savedUserList);
          emit(UsersLoadedSavedState());
        } else {
          if (_allSavedUserList.isNotEmpty) {
            emit(NoMoreUsersSavedState());
          } else {
            emit(UserNotExistSavedState());
          }
        }
      } catch (e) {
        debugPrint("Blocta get more data saved hata:" + e.toString());
      }
    });

    on<ClickSaveButtonEvent>((event, emit) async {
      try {
        emit(NewUsersLoadingSavedState());

        SavedUser savedUser = SavedUser();
        savedUser.userID = event.savedUser.userID;

        await _savedRepository.saveUser(event.myUserID, savedUser);

        UserBloc.user!.savedUserIDs.add(event.savedUser.userID);

        _allSavedUserList.insert(0, savedUser);
        emit(UsersLoadedSavedState());
      } catch (e) {
        debugPrint("Blocta add my saved error:" + e.toString());
      }
    });

    on<ClickSendRequestButtonEvent>((event, emit) async {
      try {
        SavedUser myUser = SavedUser();
        myUser.userID = event.myUser.userID;

        await _savedRepository.saveConnectionRequest(myUser, event.savedUser);

        UserBloc.user!.savedUserIDs.remove(event.savedUser.userID);
        UserBloc.user!.transmittedRequestUserIDs.add(event.savedUser.userID);

        if(UserBloc.entitlement == SubscriptionTypes.free && UserBloc.user!.numOfSendRequest > 0) {
          UserBloc.user!.numOfSendRequest -= 1;
          await _savedRepository.decrementNumOfSendRequest(myUser.userID);
        }
      } catch (e) {
        debugPrint("Blocta add my saved error:" + e.toString());
      }
    });

    on<DeleteSavedUserEvent>((event, emit) async {
      try {
        await _savedRepository.deleteSavedUser(UserBloc.user!.userID, event.savedUserID);
      } catch (e) {
        debugPrint("Blocta delete my saved error:" + e.toString());
      }
    });

    on<TrigUserNotExistSavedStateEvent>((event, emit) async {
      if(_allSavedUserList.isEmpty) {
        emit(UserNotExistSavedState());
      }
    });
  }
}

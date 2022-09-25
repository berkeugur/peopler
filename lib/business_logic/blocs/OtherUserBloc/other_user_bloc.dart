import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/user_bloc.dart';
import 'package:peopler/core/constants/enums/send_req_button_status_enum.dart';
import 'package:peopler/data/model/activity.dart';
import '../../../data/model/user.dart';
import '../../../data/repository/user_repository.dart';
import '../../../others/locator.dart';
import '../../../presentation/screens/PROFILE/OthersProfile/profile/profile_screen_components.dart';
import 'bloc.dart';

class OtherUserBloc extends Bloc<OtherUserEvent, OtherUserState> {
  final UserRepository _userRepository = locator<UserRepository>();

  MyUser? otherUser;
  late final List<String> mutualConnectionUserIDs;
  late final List<MyActivity> activities;
  late final SendRequestButtonStatus status;

  StreamSubscription? _streamSubscription;
  bool _newUserListenListener = false;

  OtherUserBloc() : super(InitialOtherUserState()) {
    on<GetInitialDataEvent>((event, emit) async {
      try {
        emit(InitialOtherUserState());

        /// Get otherUser object from database
        otherUser = await _userRepository.getUserWithUserId(event.userID);

        /// Find my mutual friends with him/her
        Set<String> otherUserConnectionIDs = otherUser!.connectionUserIDs.toSet();
        Set<String> myUserConnectionIDs = UserBloc.user!.connectionUserIDs.toSet();
        mutualConnectionUserIDs = otherUserConnectionIDs.intersection(myUserConnectionIDs).toList();

        /// Get his activities
        activities = await _userRepository.getActivities(event.userID);

        /// Find status with him/her
        if(UserBloc.user!.blockedUsers.toSet().contains(event.userID)) {
          /// Check if I have blocked other user
          status = SendRequestButtonStatus.blocked;
        } else if (UserBloc.user!.savedUserIDs.toSet().contains(event.userID)) {
          /// Check if I have already saved other user
          status = SendRequestButtonStatus.saved;
        } else if (event.status == SendRequestButtonStatus.save) {
          /// If not, check if I have opened other user's profile from nearby users
          status = SendRequestButtonStatus.save;
        } else if (otherUserConnectionIDs.contains(UserBloc.user?.userID)) {
          /// Check if we are already connected
          status = SendRequestButtonStatus.connected;
        } else if (UserBloc.user!.transmittedRequestUserIDs.toSet().contains(event.userID)) {
          /// Check if I sent a request to other user
          status = SendRequestButtonStatus.requestSent;
        } else if (UserBloc.user!.receivedRequestUserIDs.toSet().contains(event.userID)) {
          /// Check if other user sent me a request
          status = SendRequestButtonStatus.accept;
        } else {
          /// If not above them, then I opened other user's profile from "feeds" or "city" screens
          status = SendRequestButtonStatus.connect;
        }

        emit(OtherUserLoadedState(otherUser!, mutualConnectionUserIDs, activities, status));

        if (_newUserListenListener == false) {
          _newUserListenListener = true;
          _streamSubscription = _userRepository
              .getMyUserWithStream(UserBloc.user!.userID)
              .listen((myUser) async {

            add(NewUserListenerEvent(myUser: myUser));
          });
        }
      } catch (e) {
        emit(OtherUserNotFoundState());
        debugPrint("other user not found" + e.toString());
      }
    });

    on<TrigStatusEvent>((event, emit) async {
      emit(InitialOtherUserState());
      emit(OtherUserLoadedState(otherUser!, mutualConnectionUserIDs, activities, event.status));
    });

    on<NewUserListenerEvent>((event, emit) async {
      if(event.myUser.blockedUsers.toSet().contains(otherUser!.userID)) {
        /// Check if I have blocked other user
        add(TrigStatusEvent(status: SendRequestButtonStatus.blocked));
      }
    });

    on<RemoveConnectionEvent>((event, emit) async {
      emit(InitialOtherUserState());
      await _userRepository.removeConnection(UserBloc.user!.userID, event.otherUserID);
      status = SendRequestButtonStatus.connect;
      emit(OtherUserLoadedState(otherUser!, mutualConnectionUserIDs, activities, status));
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

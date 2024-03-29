import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import '../../../data/model/notifications.dart';
import '../../../data/repository/notification_repository.dart';
import '../../../others/locator.dart';
import 'bloc.dart';

class NotificationTransmittedBloc extends Bloc<NotificationTransmittedEvent, NotificationTransmittedState> {
  final NotificationRepository _notificationRepository = locator<NotificationRepository>();
  List<Notifications> _allTransmittedList = [];
  List<Notifications> get allTransmittedList => _allTransmittedList;
  Notifications? _lastSelectedTransmitted;

  NotificationTransmittedBloc() : super(InitialNotificationTransmittedState()) {
    on<ResetNotificationTransmittedEvent>((event, emit) async {
      emit(InitialNotificationTransmittedState());
    });

    on<GetInitialDataTransmittedEvent>((event, emit) async {
      try {
        emit(InitialNotificationTransmittedState());

        _allTransmittedList = [];
        _notificationRepository.restartTransmittedRequestCache();

        _lastSelectedTransmitted = null;
        List<Notifications> _transmittedList =
            await _notificationRepository.getNotificationTransmittedWithPagination(UserBloc.user!.userID, _lastSelectedTransmitted);
        if (_transmittedList.isNotEmpty) {
          _lastSelectedTransmitted = _transmittedList.last;
        }

        /// If transmitted request is accepted, then do not show it in Incoming Requests screen, so remove them.
        List<Notifications> tempList = [..._transmittedList];
        for (Notifications tempNotification in tempList) {
          if (tempNotification.didAccepted == true) {
            _transmittedList.removeWhere((item) => item.notificationID == tempNotification.notificationID);
          }
        }

        // await Future.delayed(const Duration(seconds: 2));

        if (_transmittedList.isNotEmpty) {
          _allTransmittedList.addAll(_transmittedList);
          if (state is NotificationTransmittedLoaded1State) {
            emit(NotificationTransmittedLoaded2State());
          } else {
            emit(NotificationTransmittedLoaded1State());
          }
        } else {
          emit(NotificationTransmittedNotExistState());
        }
      } catch (e) {
        debugPrint("Blocta initial NotificationTransmitted hata:" + e.toString());
      }
    });

    on<GetMoreDataTransmittedEvent>((event, emit) async {
      try {
        emit(NewNotificationTransmittedLoadingState());

        List<Notifications> _transmittedList =
            await _notificationRepository.getNotificationTransmittedWithPagination(UserBloc.user!.userID, _lastSelectedTransmitted);
        if (_transmittedList.isNotEmpty) {
          _lastSelectedTransmitted = _transmittedList.last;
        }

        List<Notifications> tempList = [..._transmittedList];
        for (Notifications tempNotification in tempList) {
          if (tempNotification.didAccepted == true) {
            _transmittedList.removeWhere((item) => item.notificationID == tempNotification.notificationID);
          }
        }

        // await Future.delayed(const Duration(seconds: 2));

        if (_transmittedList.isNotEmpty) {
          _allTransmittedList.addAll(_transmittedList);
          if (state is NotificationTransmittedLoaded1State) {
            emit(NotificationTransmittedLoaded2State());
          } else {
            emit(NotificationTransmittedLoaded1State());
          }
        } else {
          if (_allTransmittedList.isNotEmpty) {
            emit(NoMoreNotificationTransmittedState());
          } else {
            emit(NotificationTransmittedNotExistState());
          }
        }
      } catch (e) {
        debugPrint("Blocta get more data NotificationTransmitted hata:" + e.toString());
      }
    });

    on<GeriAlTransmittedButtonEvent>((event, emit) async {
      try {
        UserBloc.user!.transmittedRequestUserIDs.remove(event.requestUserID);
        _allTransmittedList.removeWhere((element) => element.requestUserID == event.requestUserID);

        if (_allTransmittedList.isEmpty) {
          emit(NotificationTransmittedNotExistState());
        } else {
          if (state is NotificationTransmittedLoaded1State) {
            emit(NotificationTransmittedLoaded2State());
          } else {
            emit(NotificationTransmittedLoaded1State());
          }
        }

        await _notificationRepository.deleteNotification(UserBloc.user!.userID, event.requestUserID);

        if (_allTransmittedList.length < 5) {
          add(GetMoreDataTransmittedEvent());
        }
      } catch (e) {
        debugPrint("Blocta geri al error:" + e.toString());
      }
    });
  }

  void resetBloc() {
    /// Close streams

    /// Reset variables
    _allTransmittedList = [];
    _lastSelectedTransmitted = null;

    /// set initial state
    add(ResetNotificationTransmittedEvent());
  }
}

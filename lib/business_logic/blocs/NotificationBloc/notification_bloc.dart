import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import '../../../data/model/notifications.dart';
import '../../../data/repository/notification_repository.dart';
import '../../../others/locator.dart';
import 'bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository = locator<NotificationRepository>();
  List<Notifications> _allNotificationList = [];
  List<Notifications> get allNotificationList => _allNotificationList;
  Notifications? _lastSelected;

  NotificationBloc() : super(InitialNotificationState()) {
    on<GetInitialDataEvent>((event, emit) async {
      try {
        emit(InitialNotificationState());

        _allNotificationList = [];
        _notificationRepository.restartNotificationCache();

        _lastSelected = null;
        List<Notifications> _notificationList = await _notificationRepository.getNotificationWithPagination(UserBloc.user!.userID, _lastSelected);
        if(_notificationList.isNotEmpty) {
          _lastSelected = _notificationList.last;
        }

        // await Future.delayed(const Duration(seconds: 2));

        if (_notificationList.isNotEmpty) {
          _allNotificationList.addAll(_notificationList);
          emit(NotificationLoadedState());
        } else {
          emit(NotificationNotExistState());
        }
      } catch (e) {
        debugPrint("Blocta initial Notification hata:" + e.toString());
      }
    });

    on<GetMoreDataEvent>((event, emit) async {
      try {
        emit(NewNotificationLoadingState());

        List<Notifications> _notificationList = await _notificationRepository.getNotificationWithPagination(UserBloc.user!.userID, _lastSelected);
        if(_notificationList.isNotEmpty) {
          _lastSelected = _notificationList.last;
        }

        // await Future.delayed(const Duration(seconds: 2));

        if (_notificationList.isNotEmpty) {
          _allNotificationList.addAll(_notificationList);
          emit(NotificationLoadedState());
        } else {
          if (_allNotificationList.isNotEmpty) {
            emit(NoMoreNotificationState());
          } else {
            emit(NotificationNotExistState());
          }
        }
      } catch (e) {
        debugPrint("Blocta get more data Notification hata:" + e.toString());
      }
    });

    on<ClickAcceptEvent>((event, emit) async {
      try {
        await _notificationRepository.acceptConnectionRequest(UserBloc.user!.userID, event.requestUserID);
      } catch (e) {
        debugPrint("Blocta get more data ClickAcceptEvent hata:" + e.toString());
      }
    });
  }
}

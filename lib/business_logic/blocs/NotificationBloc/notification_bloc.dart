import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'package:peopler/data/services/db/firestore_db_service_users.dart';
import '../../../data/model/notifications.dart';
import '../../../data/model/user.dart';
import '../../../data/repository/notification_repository.dart';
import '../../../others/locator.dart';
import 'bloc.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository _notificationRepository = locator<NotificationRepository>();
  final FirestoreDBServiceUsers _firestoreDBServiceUsers = locator<FirestoreDBServiceUsers>();

  static List<Notifications> _allNotificationList = [];
  List<Notifications> get allNotificationList => _allNotificationList;

  static Notifications? _lastSelectedNotification;

  static StreamSubscription? _streamSubscription;
  static bool _newNotificationListenListener = false;

  NotificationBloc() : super(InitialNotificationState()) {
    on<GetInitialNotificationEvent>((event, emit) async {
      try {
        emit(InitialNotificationState());

        _allNotificationList = [];
        _notificationRepository.restartNotificationCache();

        _lastSelectedNotification = null;
        List<Notifications> newNotificationList = await _notificationRepository.getNotificationWithPagination(
            UserBloc.user!.userID, _lastSelectedNotification);
        if (newNotificationList.isNotEmpty) {
          _lastSelectedNotification = newNotificationList.last;
        }

        if (newNotificationList.isNotEmpty) {
          _allNotificationList.addAll(newNotificationList);
          if (state is NotificationLoadedState1) {
            emit(NotificationLoadedState2());
          } else {
            emit(NotificationLoadedState1());
          }
        } else {
          emit(NotificationNotExistState());
        }

        if (_newNotificationListenListener == false) {
          _newNotificationListenListener = true;
          _streamSubscription = _notificationRepository
              .getNotificationWithStream(UserBloc.user!.userID)
              .listen((updatedNotification) async {
            if (updatedNotification.isEmpty) {
              /// Call another NotificationBloc event named NewNotificationListenerEvent
              add(NewNotificationListenerEvent(
                  updatedNotification: updatedNotification, newNotificationCubit: event.newNotificationCubit));
              debugPrint("There is no new notification");
              return;
            }

            if (updatedNotification[0].requestUserID == null) {
              /// Call another NotificationBloc event named NewNotificationListenerEvent
              add(NewNotificationListenerEvent(
                  updatedNotification: updatedNotification, newNotificationCubit: event.newNotificationCubit));
              debugPrint("Notification Type is not receive or transmit");
              return;
            }

            MyUser? _user = await _firestoreDBServiceUsers.readUserRestricted(updatedNotification[0].requestUserID!);
            updatedNotification[0].requestDisplayName = _user!.displayName;
            updatedNotification[0].requestProfileURL = _user.profileURL;
            updatedNotification[0].requestBiography = _user.biography;

            /// Call another NotificationBloc event named NewNotificationListenerEvent
            add(NewNotificationListenerEvent(
                updatedNotification: updatedNotification, newNotificationCubit: event.newNotificationCubit));
          });
        }
      } catch (e) {
        debugPrint("Blocta initial Notification hata: " + e.toString());
      }
    });

    on<GetMoreNotificationEvent>((event, emit) async {
      try {
        emit(NotificationsLoadingState());

        List<Notifications> newNotificationList = await _notificationRepository.getNotificationWithPagination(
            UserBloc.user!.userID, _lastSelectedNotification);
        if (newNotificationList.isNotEmpty) {
          _lastSelectedNotification = newNotificationList.last;
        }

        if (newNotificationList.isNotEmpty) {
          _allNotificationList.addAll(newNotificationList);
          if (state is NotificationLoadedState1) {
            emit(NotificationLoadedState2());
          } else {
            emit(NotificationLoadedState1());
          }
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

    on<NewNotificationListenerEvent>((event, emit) async {
      /// If notification deleted and now there is no notifications
      if (event.updatedNotification.isEmpty) {
        emit(NotificationNotExistState());
        return;
      }

      /// If there is a notification with updatedNotificationId, then remove it from _allNotificationList.
      /// Since updatedNotification is a list with only one element, we get the only element whose index is 0.
      _allNotificationList.removeWhere((item) => item.notificationID == event.updatedNotification[0].notificationID);

      /// Insert updatedNotification at the top of list
      _allNotificationList.insert(0, event.updatedNotification[0]);

      if (state is NotificationLoadedState1) {
        emit(NotificationLoadedState2());
      } else {
        emit(NotificationLoadedState1());
      }

      event.newNotificationCubit.newNotificationEvent();
    });

    on<ClickAcceptEvent>((event, emit) async {
      try {
        await _notificationRepository.acceptConnectionRequest(UserBloc.user!.userID, event.requestUserID);
      } catch (e) {
        debugPrint("Blocta ClickAcceptEvent hata:" + e.toString());
      }
    });

    on<DeleteNotification>((event, emit) async {
      try {
        _allNotificationList.removeWhere((element) => element.notificationID == event.notificationID);

        add(TrigNotificationsNotExistEvent());

        await _notificationRepository.makeNotificationInvisible(UserBloc.user!.userID, event.notificationID);
      } catch (e) {
        debugPrint("Blocta DeleteNotification hata:" + e.toString());
      }
    });

    on<GeriAlButtonEvent>((event, emit) async {
      try {
        UserBloc.user!.transmittedRequestUserIDs.remove(event.requestUserID);
        _allNotificationList.removeWhere((element) => element.requestUserID == event.requestUserID);

        add(TrigNotificationsNotExistEvent());
        await _notificationRepository.deleteNotification(UserBloc.user!.userID, event.requestUserID);
      } catch (e) {
        debugPrint("Blocta geri al error:" + e.toString());
      }
    });

    on<TrigNotificationsNotExistEvent>((event, emit) async {
      if (_allNotificationList.isEmpty) {
        emit(NotificationNotExistState());
      } else {
        if (state is NotificationLoadedState1) {
          emit(NotificationLoadedState2());
        } else {
          emit(NotificationLoadedState1());
        }
      }

      if (_allNotificationList.length < 5) {
        add(GetMoreNotificationEvent());
      }
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

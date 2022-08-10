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

  final List<Notifications> _allNotificationList = [];
  List<Notifications> get allNotificationList => _allNotificationList;

  Notifications? _lastSelectedNotification;

  static const int _numberOfElements = 10;
  StreamSubscription? _streamSubscription;
  bool _newNotificationListenListener = false;
  bool _hasMore = true;

  NotificationBloc() : super(InitialNotificationState()) {

    on<GetNotificationWithPaginationEvent>((event, emit) async {
      if (_hasMore == false) {
        emit(NoMoreNotificationState());
      } else {
        if (_allNotificationList.isNotEmpty) {
          _lastSelectedNotification = _allNotificationList.last;
        }

        emit(NotificationsLoadingState());

        List<Notifications> newNotificationList = await _notificationRepository.getNotificationWithPagination(UserBloc.user!.userID, _lastSelectedNotification, _numberOfElements);

        if (newNotificationList.length < _numberOfElements) {
          _hasMore = false;
        }

        /// If notification is not visible (if it is deleted by user before), then remove it from list
        int newNotificationListLength = newNotificationList.length;
        for(int i=0; i<newNotificationListLength; i++){
            newNotificationList.removeWhere((item) => item.notificationVisible == false);
        }

        if(_allNotificationList.isNotEmpty) {
          _allNotificationList.addAll(newNotificationList);
          if(state is NotificationLoadedState1) {
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

            if(updatedNotification.isEmpty) {
              debugPrint("There is no new notification");
              return;
            }

            if(updatedNotification[0].requestUserID == null) {
              debugPrint("Notification Type is not receive or transmit");
              return;
            }

            MyUser? _user = await _firestoreDBServiceUsers.readUserRestricted(updatedNotification[0].requestUserID!);
            updatedNotification[0].requestDisplayName = _user!.displayName;
            updatedNotification[0].requestProfileURL = _user.profileURL;
            updatedNotification[0].requestBiography = _user.biography;

            /// Call another ChatBloc event named NewChatListenerEvent
            add(NewNotificationListenerEvent(updatedNotification: updatedNotification));
          });
        }
      }
    });



    on<NewNotificationListenerEvent>((event, emit) async {
      /// If there is a notification with updatedNotificationId, then remove it from _allNotificationList.
      /// Since updatedNotification is a list with only one element, we get the only element whose index is 0.
      _allNotificationList.removeWhere((item) => item.notificationID == event.updatedNotification[0].notificationID);

      /// Insert updatedNotification at the top of list
      _allNotificationList.insert(0, event.updatedNotification[0]);

      if(state is NotificationLoadedState1) {
        emit(NotificationLoadedState2());
      } else {
        emit(NotificationLoadedState1());
      }
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
        int index = _allNotificationList.indexWhere((element) => element.notificationID == event.notificationID);
        _allNotificationList.removeAt(index);

        await _notificationRepository.makeNotificationInvisible(UserBloc.user!.userID, event.notificationID);

        if(state is NotificationLoadedState1) {
          emit(NotificationLoadedState2());
        } else {
          emit(NotificationLoadedState1());
        }

      } catch (e) {
        debugPrint("Blocta DeleteNotification hata:" + e.toString());
      }
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

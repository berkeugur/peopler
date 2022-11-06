import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import '../../../data/model/notifications.dart';
import '../../../data/repository/notification_repository.dart';
import '../../../data/send_notification_service.dart';
import '../../../data/services/db/firestore_db_service_users.dart';
import '../../../others/locator.dart';
import '../../../others/strings.dart';
import 'bloc.dart';

class NotificationReceivedBloc extends Bloc<NotificationReceivedEvent, NotificationReceivedState> {
  final NotificationRepository _notificationRepository = locator<NotificationRepository>();
  List<Notifications> _allReceivedList = [];
  List<Notifications> get allReceivedList => _allReceivedList;
  Notifications? _lastSelectedReceived;
  final SendNotificationService _sendNotificationService = locator<SendNotificationService>();
  final FirestoreDBServiceUsers _firestoreDBServiceUsers = locator<FirestoreDBServiceUsers>();

  NotificationReceivedBloc() : super(InitialNotificationReceivedState()) {
    on<GetInitialDataReceivedEvent>((event, emit) async {
      try {
        emit(InitialNotificationReceivedState());

        _allReceivedList = [];
        _notificationRepository.restartReceivedRequestCache();

        _lastSelectedReceived = null;
        List<Notifications> receivedList = await _notificationRepository.getNotificationReceivedWithPagination(UserBloc.user!.userID, _lastSelectedReceived);
        if(receivedList.isNotEmpty) {
          _lastSelectedReceived = receivedList.last;
        }

        // await Future.delayed(const Duration(seconds: 2));

        if (receivedList.isNotEmpty) {
          _allReceivedList.addAll(receivedList);
          if(state is NotificationReceivedLoaded1State) {
            emit(NotificationReceivedLoaded2State());
          } else {
            emit(NotificationReceivedLoaded1State());
          }
        } else {
          emit(NotificationReceivedNotExistState());
        }
      } catch (e) {
        debugPrint("Blocta initial NotificationReceived hata:" + e.toString());
      }
    });

    on<GetMoreDataReceivedEvent>((event, emit) async {
      try {
        emit(NewNotificationReceivedLoadingState());

        List<Notifications> receivedList = await _notificationRepository.getNotificationReceivedWithPagination(UserBloc.user!.userID, _lastSelectedReceived);
        if(receivedList.isNotEmpty) {
          _lastSelectedReceived = receivedList.last;
        }

        // await Future.delayed(const Duration(seconds: 2));

        if (receivedList.isNotEmpty) {
          _allReceivedList.addAll(receivedList);
          if(state is NotificationReceivedLoaded1State) {
            emit(NotificationReceivedLoaded2State());
          } else {
            emit(NotificationReceivedLoaded1State());
          }
        } else {
          if (_allReceivedList.isNotEmpty) {
            emit(NoMoreNotificationReceivedState());
          } else {
            emit(NotificationReceivedNotExistState());
          }
        }
      } catch (e) {
        debugPrint("Blocta get more data NotificationReceived hata:" + e.toString());
      }
    });

    on<ClickAcceptReceivedEvent>((event, emit) async {
      try {
        await _notificationRepository.acceptConnectionRequest(UserBloc.user!.userID, event.requestUserID);

        /// Send request user a notification that I have accepted his/her connection request
        String? _token = await _firestoreDBServiceUsers.getToken(event.requestUserID);
        if(_token == null) return;

        await _sendNotificationService.sendNotification(Strings.receiveRequest, _token, "", UserBloc.user!.displayName, UserBloc.user!.profileURL, UserBloc.user!.userID);

      } catch (e) {
        debugPrint("Blocta get more data ClickAcceptEvent hata:" + e.toString());
      }
    });

    on<ClickNotAcceptEvent>((event, emit) async {
      try {
        UserBloc.user!.receivedRequestUserIDs.remove(event.requestUserID);
        _allReceivedList.removeAt(event.index);

        if(_allReceivedList.isEmpty) {
          emit(NotificationReceivedNotExistState());
        }

        await _notificationRepository.deleteNotification(UserBloc.user!.userID, event.requestUserID);
      } catch (e) {
        debugPrint("Blocta get more data ClickNotAcceptEvent hata:" + e.toString());
      }
    });
  }
}

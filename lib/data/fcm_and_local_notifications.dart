import 'dart:async';
import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import '../business_logic/blocs/UserBloc/user_bloc.dart';
import '../business_logic/cubits/FloatingActionButtonCubit.dart';
import '../others/strings.dart';
import '../presentation/screens/MessageScreen/message_screen.dart';
import '../presentation/tab_item.dart';
import 'model/chat.dart';

/// AWESOME NOTIFICATIONS
Future<void> myBackgroundMessageHandler(RemoteMessage message) {
  Map<String, dynamic> _message = message.data;
  if (_message['notificationType'] == Strings.sendRequest) {
    FCMAndLocalNotifications.showSendRequestNotification(_message);
  } else if (_message['notificationType'] == Strings.receiveRequest) {
    FCMAndLocalNotifications.showReceivedRequestNotification(_message);
  } else if (_message['notificationType'] == Strings.message) {
    FCMAndLocalNotifications.showIncomingMessage(_message);
  }
  return Future<void>.value();
}

class FCMAndLocalNotifications {
  static BuildContext? myContext;

  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  static final GeolocatorPlatform _geolocatorPlatform =
      GeolocatorPlatform.instance;
  static final AwesomeNotifications awesomeNotificationsPlugin =
      AwesomeNotifications();

  /// Make this class singleton
  static final FCMAndLocalNotifications _singleton =
      FCMAndLocalNotifications._internal();
  factory FCMAndLocalNotifications() {
    return _singleton;
  }
  FCMAndLocalNotifications._internal();

  /// Called in locator.dart because local notifications does not require user to logged in
  static void initializeAwesomeNotifications() async {
    /// Initialize Awesome Notifications
    awesomeNotificationsPlugin.initialize(
        // set the icon to null if you want to use the default app icon
        'resource://mipmap/ic_launcher_adaptive_fore',
        [
          NotificationChannel(
            channelKey: Strings.keyDebug,
            channelName: 'Debug notifications',
            channelDescription: 'Notification channel for debug purposes',
            defaultColor: Colors.green,
            ledColor: Colors.white,
            playSound: true,
            enableVibration: true,
          ),
          NotificationChannel(
            channelKey: Strings.keyPermission,
            channelName: 'Permission notifications',
            channelDescription: 'Notification channel for permissions',
            defaultColor: const Color(0xFF0A58EF),
            ledColor: Colors.white,
            playSound: true,
            enableVibration: true,
          ),
          NotificationChannel(
            channelKey: Strings.keyMain,
            channelName: 'Message and Connection Request notifications',
            channelDescription: 'Notification channel for main purposes',
            defaultColor: const Color(0xFF0A58EF),
            ledColor: Colors.white,
            playSound: true,
            enableVibration: true,
          ),
        ],
        debug: true);
  }

  /// Called in home_screen because local FCM notifications require user to logged in
  void initializeFCMNotifications(BuildContext? context) async {
    myContext = context;

    /// Get token and save it to database
    String? _token = await _fcm.getToken();
    debugPrint(_token!);
    User? _currentUser = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .doc("tokens/" + _currentUser!.uid)
        .set({"token": _token});

    /// If current user's token is refreshed because of some reason, then update it on database also.
    _fcm.onTokenRefresh.listen((newToken) async {
      User? _currentUser = FirebaseAuth.instance.currentUser;
      await FirebaseFirestore.instance
          .doc("tokens/" + _currentUser!.uid)
          .set({"token": newToken});
    });

    /// For IOS, foreground notifications
    await _fcm.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: false,
    );

    /// For foreground notification, firebase cloud messaging
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Map<String, dynamic> _message = message.data;
      if (_message['notificationType'] == Strings.sendRequest) {
        showSendRequestNotification(_message);
      } else if (_message['notificationType'] == Strings.receiveRequest) {
        showReceivedRequestNotification(_message);
      } else if (_message['notificationType'] == Strings.message) {
        showIncomingMessage(_message);
      }
    });

    /// For background notification, firebase cloud messaging
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  }

  static Future showNotificationForDebugPurposes(String error) async {
    await awesomeNotificationsPlugin.createNotification(
        content: NotificationContent(
            id: 0,
            channelKey: Strings.keyDebug,
            title: 'Location for Debug Purposes',
            body: error,
            payload: {'payload': ''},
            summary: 'debug'
            ));
  }

  static Future showNotificationForLocationPermissions(
      String title, String body, String payloadType) async {
    await awesomeNotificationsPlugin.createNotification(
        content: NotificationContent(
            id: 1,
            channelKey: Strings.keyPermission,
            title: title,
            body: body,
            payload: {'payload': payloadType},
            summary: 'Permission'
            ));
  }

  /// If a user sent a connection request to you
  static void showSendRequestNotification(Map<String, dynamic> message) async {
    // message["displayName"] // message["message"] // message["profileURL"] // message["userID"]
    if(Platform.isAndroid) {
      await awesomeNotificationsPlugin.createNotification(
        content: NotificationContent(
            id: 2,
            channelKey: Strings.keyMain,
            title: '',
            body: message["displayName"] + ' size bağlantı isteği gönderdi',
            showWhen: true,
            displayOnForeground: true,
            displayOnBackground: true,
            notificationLayout: NotificationLayout.Messaging,
            roundedLargeIcon: true,
            largeIcon: message["profileURL"],
            payload: {'payload': Strings.sendRequest},
            summary: 'Yeni Bağlantı İsteği'
            ));
    } else if(Platform.isIOS) {
      await awesomeNotificationsPlugin.createNotification(
          content: NotificationContent(
              id: 2,
              channelKey: Strings.keyMain,
              title: '',
              body: message["displayName"] + ' size bağlantı isteği gönderdi',
              showWhen: true,
              displayOnForeground: true,
              displayOnBackground: true,
              notificationLayout: NotificationLayout.Messaging,
              payload: {'payload': Strings.sendRequest},
              summary: ''
          ));
    }
  }

  /// If a user accepted your connection request
  static void showReceivedRequestNotification(
      Map<String, dynamic> message) async {
    if(Platform.isAndroid) {
      await awesomeNotificationsPlugin.createNotification(
          content: NotificationContent(
              id: 3,
              channelKey: Strings.keyMain,
              title: '',
              body: message["displayName"] + ' bağlantı isteğinizi kabul etti.',
              showWhen: true,
              displayOnForeground: true,
              displayOnBackground: true,
              notificationLayout: NotificationLayout.Messaging,
              roundedLargeIcon: true,
              largeIcon: message["profileURL"],
              payload: {'payload': Strings.receiveRequest},
              summary: 'Yeni Bağlantı'));
    } else if(Platform.isIOS) {
      await awesomeNotificationsPlugin.createNotification(
          content: NotificationContent(
              id: 3,
              channelKey: Strings.keyMain,
              title: '',
              body: message["displayName"] + ' bağlantı isteğinizi kabul etti.',
              showWhen: true,
              displayOnForeground: true,
              displayOnBackground: true,
              notificationLayout: NotificationLayout.Messaging,
              payload: {'payload': Strings.receiveRequest},
              summary: ''));
    }
  }

  /// If your connection send you a message
  static void showIncomingMessage(Map<String, dynamic> message) async {
    // message["displayName"] // message["message"] // message["profileURL"] // message["userID"]
    if(Platform.isAndroid) {
      await awesomeNotificationsPlugin.createNotification(
          content: NotificationContent(
              id: 4,
              channelKey: Strings.keyMain,
              title: '',
              body: message["message"],
              showWhen: true,
              displayOnForeground: true,
              displayOnBackground: true,
              notificationLayout: NotificationLayout.Messaging,
              roundedLargeIcon: true,
              largeIcon: message["profileURL"],
              payload: {
                'payload': Strings.message,
                'userID': message['userID'],
                'displayName': message['displayName'],
                'profileURL': message['profileURL']
              },
              summary: message["displayName"]
          ));
    } else if(Platform.isIOS) {
      await awesomeNotificationsPlugin.createNotification(
          content: NotificationContent(
              id: 4,
              channelKey: Strings.keyMain,
              title: message["displayName"],
              body: message["message"],
              showWhen: true,
              displayOnForeground: true,
              displayOnBackground: true,
              notificationLayout: NotificationLayout.Messaging,
              payload: {
                'payload': Strings.message,
                'userID': message['userID'],
                'displayName': message['displayName'],
                'profileURL': message['profileURL']
              },
              summary: ''
          ));
    }
  }

  static void listenNotification() async {
    awesomeNotificationsPlugin.actionStream.listen((receivedAction) async {
      String? payloadType = receivedAction.payload!['payload'];

      if (receivedAction.channelKey == Strings.keyDebug) {
        // Nothing
      }

      if (receivedAction.channelKey == Strings.keyPermission) {
        if (payloadType == Strings.permissionSettings) {
          _geolocatorPlatform.openAppSettings();
        } else if (payloadType == Strings.requestPermission) {
          _geolocatorPlatform.requestPermission();
        } else if (payloadType == Strings.googleDialog) {
          const locationChannel = MethodChannel('mertsalar/location_setting');

          /// This is the same name where we have defined in Native side
          await locationChannel.invokeMethod('requestLocationSetting', []);

          /// This method name is the same as Native side, we call this method from Kotlin
        } else {
          debugPrint('No payload');
        }
      }

      if (receivedAction.channelKey == Strings.keyMain) {
        if (payloadType == Strings.sendRequest) {
          final FloatingActionButtonCubit _homeScreen =
              BlocProvider.of<FloatingActionButtonCubit>(myContext!);
          _homeScreen.currentTab = TabItem.notifications;
          _homeScreen.changeFloatingActionButtonEvent();
          _homeScreen.navigatorKeys[TabItem.notifications]!.currentState!
              .pushNamed('/invitations');
        } else if (payloadType == Strings.receiveRequest) {
          final FloatingActionButtonCubit _homeScreen =
              BlocProvider.of<FloatingActionButtonCubit>(myContext!);
          _homeScreen.currentTab = TabItem.notifications;
          _homeScreen.changeFloatingActionButtonEvent();
          _homeScreen.navigatorKeys[TabItem.notifications]!.currentState!
              .pushNamed('/');
        } else if (payloadType == Strings.message) {
          UserBloc _userBloc = BlocProvider.of<UserBloc>(myContext!);
          _userBloc.mainKey.currentState?.push(
            MaterialPageRoute(
                builder: (context) => MessageScreen(
                      requestUserID: receivedAction.payload!['userID']!,
                      requestProfileURL: receivedAction.payload!['profileURL']!,
                      requestDisplayName: receivedAction.payload!['displayName']!,
                    )),
          );
        } else {
          debugPrint('No payload');
        }
      }
    });
  }
}

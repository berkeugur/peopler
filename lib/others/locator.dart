import 'package:get_it/get_it.dart';
import 'package:peopler/data/fcm_and_local_notifications.dart';
import 'package:peopler/data/my_work_manager.dart';
import 'package:peopler/data/repository/chat_repository.dart';
import 'package:peopler/data/repository/connection_repository.dart';
import 'package:peopler/data/repository/message_repository.dart';
import 'package:peopler/data/repository/notification_repository.dart';
import 'package:peopler/data/repository/saved_repository.dart';
import 'package:peopler/data/services/db/firebase_db_common.dart';
import 'package:peopler/data/services/db/firebase_db_service_message.dart';
import 'package:peopler/data/services/remote_config/remote_config.dart';
import 'package:peopler/data/services/storage/firebase_storage_service.dart';
import 'package:peopler/others/classes/dark_light_mode_controller.dart';
import 'package:peopler/presentation/screens/OnBoardingScreen/constants.dart';
import '../data/in_app_purchases.dart';
import '../data/repository/connectivity_repository.dart';
import '../data/repository/feed_repository.dart';
import '../data/repository/location_repository.dart';
import '../data/repository/user_repository.dart';
import '../data/send_notification_service.dart';
import '../data/services/auth/firebase_auth_service.dart';
import '../data/services/connectivity/connectivity_service.dart';
import '../data/services/db/firebase_db_service_chat.dart';
import '../data/services/db/firebase_db_service_location.dart';
import '../data/services/db/firestore_db_service_feeds.dart';
import '../data/services/db/firestore_db_service_users.dart';
import '../data/services/location/location_service.dart';

GetIt locator = GetIt.I;

Future<void> setupLocator() async {
  OnBoardingScreenDataList.prepareDataList();
  /// Custom Services
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => LocationService());
  locator.registerLazySingleton(() => ConnectivityService());
  /// Firestore Services
  locator.registerLazySingleton(() => FirestoreDBServiceUsers());
  locator.registerLazySingleton(() => FirestoreDBServiceFeeds());
  locator.registerLazySingleton(() => FirestoreDBServiceLocation());
  locator.registerLazySingleton(() => FirestoreDBServiceChat());
  locator.registerLazySingleton(() => FirestoreDBServiceMessage());
  locator.registerLazySingleton(() => FirestoreDBServiceCommon());

  /// Repositories
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => FeedRepository());
  locator.registerLazySingleton(() => LocationRepository());
  locator.registerLazySingleton(() => ConnectivityRepository());
  locator.registerLazySingleton(() => ChatRepository());
  locator.registerLazySingleton(() => ConnectionRepository());
  locator.registerLazySingleton(() => MessageRepository());
  locator.registerLazySingleton(() => SavedRepository());
  locator.registerLazySingleton(() => NotificationRepository());

  /// Storage Service
  locator.registerLazySingleton(() => FirebaseStorageService());

  /// Flutter Local Notifications
  FCMAndLocalNotifications.initializeAwesomeNotifications();

  /// Work Manager
  // await MyWorkManager.create();

  /// Send Notification Service
  locator.registerLazySingleton(() => SendNotificationService());

  /// Purchase API,
  locator.registerLazySingleton(() => PurchaseApi());
  final PurchaseApi _purchaseApi = locator<PurchaseApi>();
  await _purchaseApi.init();

  /// Firebase Remote Config Service
  locator.registerLazySingleton(() => FirebaseRemoteConfigService());
  final FirebaseRemoteConfigService _remoteConfig = locator<FirebaseRemoteConfigService>();
  await _remoteConfig.initConfig();

  /// Theme
  locator.registerLazySingleton(() => Mode());
}

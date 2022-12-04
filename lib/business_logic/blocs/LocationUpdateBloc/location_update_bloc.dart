import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:peopler/business_logic/blocs/UserBloc/bloc.dart';
import 'package:peopler/core/constants/enums/subscriptions_enum.dart';
import 'package:peopler/data/my_work_manager.dart';
import 'package:peopler/data/repository/location_repository.dart';
import '../../../data/repository/saved_repository.dart';
import '../../../others/locator.dart';
import 'bloc.dart';

class LocationUpdateBloc extends Bloc<LocationUpdateEvent, LocationUpdateState> {
  static final LocationRepository _locationRepository = locator<LocationRepository>();

  static Position? _position;
  static Position? get position => _position;

  static bool firstUpdate = false;

  static Timer? _timer;

  LocationUpdateBloc() : super(InitialState()) {
    on<ResetLocationUpdateEvent>((event, emit) async {
      emit(InitialState());
    });

    on<UpdateLocationEvent>((event, emit) async {
      String methodState = await updateLocationMethod();
      if (methodState == 'PositionNotUpdatedState') {
        emit(PositionNotUpdatedState());
      } else if (methodState == 'PositionUpdatedState') {
        emit(PositionUpdatedState());
      } else if (methodState == 'PositionNotGetState') {
        emit(PositionNotGetState());
      }

      firstUpdate = true;
      debugPrint(methodState);
    });

    on<UpdateNumOfSendRequest>((event, emit) async {
      final SavedRepository _savedRepository = locator<SavedRepository>();
      await _savedRepository.refreshNumOfSendRequest();
    });

    ///--------------- TIMER - FOREGROUND ----------------------------//
    on<StartLocationUpdatesForeground>((event, emit) async {
      if (_timer == null) {
        const storage = FlutterSecureStorage();

        if (UserBloc.user != null) {
          await storage.write(key: 'sharedUserID', value: UserBloc.user!.userID);
          await storage.write(key: 'sharedLatitude', value: UserBloc.user!.latitude.toString());
          await storage.write(key: 'sharedLongitude', value: UserBloc.user!.longitude.toString());
        } else {
          await storage.write(key: 'sharedLatitude', value: UserBloc.guestUser!.latitude.toString());
          await storage.write(key: 'sharedLongitude', value: UserBloc.guestUser!.longitude.toString());
        }

        add(UpdateLocationEvent());

        _timer = Timer.periodic(
          const Duration(minutes: 1),
          (dummy) {
            debugPrint("Foreground update active");
            add(UpdateLocationEvent());

            if (UserBloc.entitlement != SubscriptionTypes.free) return;
            if (UserBloc.user == null) return;

            add(UpdateNumOfSendRequest());
          },
        );
      }
    });

    ///--------------- WORK MANAGER - BACKGROUND ----------------------------//

    on<StartLocationUpdatesBackground>((event, emit) async {
      if (UserBloc.user != null) {
        const storage = FlutterSecureStorage();

        await storage.write(key: 'sharedUserID', value: UserBloc.user!.userID);
        await storage.write(key: 'sharedLatitude', value: UserBloc.user!.latitude.toString());
        await storage.write(key: 'sharedLongitude', value: UserBloc.user!.longitude.toString());

        /// Start work manager fetch location on background
        MyWorkManager.fetchLocationBackground();
      }
    });

    ///---------------------------------------------------------//
  }

  static Future<String> updateLocationMethod() async {
    try {
      LocationPermission _permission = await _locationRepository.checkPermissions();
      if (!(_permission == LocationPermission.whileInUse || _permission == LocationPermission.always)) {
        /// For debug purposes
        /// FCMAndLocalNotifications.showNotificationForDebugPurposes("not while in use nor always");
        return 'PositionNotGetState';
      }

      bool locationStatus = await _locationRepository.checkLocationSetting();
      if (locationStatus == false) {
        /// For debug purposes
        /// FCMAndLocalNotifications.showNotificationForDebugPurposes("location setting is closed");
        return 'PositionNotGetState';
      }

      _position = await _locationRepository.getCurrentPosition();
      if (_position == null) {
        /// For debug purposes
        /// FCMAndLocalNotifications.showNotificationForDebugPurposes("Position cannot be get");
        return 'PositionNotGetState';
      }

      if (UserBloc.user != null) {
        /// Update user location at database and secure storage (phone cache)
        bool isUpdated = await _locationRepository.updateUserLocationAtDatabase(_position!);
        if (isUpdated == false) {
          /// For debug purposes
          /// FCMAndLocalNotifications.showNotificationForDebugPurposes("Position cannot be updated, firestore problem");
          return 'PositionNotUpdatedState';
        }

        /// Obtain shared preferences.
        const storage = FlutterSecureStorage();
        Map<String, String> allValues = await storage.readAll();

        UserBloc.user?.latitude = int.parse(allValues['sharedLatitude']!);
        UserBloc.user?.longitude = int.parse(allValues['sharedLongitude']!);

        /// For debug purposes
        /// FCMAndLocalNotifications.showNotificationForDebugPurposes("Position updated ${_position.toString()}");
      } else {
        bool isUpdated = await _locationRepository.updateGuestUserLocation(_position!);
        if (isUpdated == false) {
          /// For debug purposes
          /// FCMAndLocalNotifications.showNotificationForDebugPurposes("Position cannot be updated, firestore problem");
          return 'PositionNotUpdatedState';
        }

        /// Obtain shared preferences.
        const storage = FlutterSecureStorage();
        Map<String, String> allValues = await storage.readAll();

        UserBloc.guestUser?.latitude = int.parse(allValues['sharedLatitude']!);
        UserBloc.guestUser?.longitude = int.parse(allValues['sharedLongitude']!);

        /// For debug purposes
        /// FCMAndLocalNotifications.showNotificationForDebugPurposes("Position updated ${_position.toString()}");
      }

      return 'PositionUpdatedState';
    } catch (e) {
      debugPrint("Blocta location update hata:" + e.toString());
      return 'Error';
    }
  }

  void resetBloc() {
    /// Close streams
    closeStreams();

    /// Reset variables
    _position = null;
    firstUpdate = false;
    _timer = null;

    /// set initial state
    add(ResetLocationUpdateEvent());
  }

  @override
  Future<void> close() async {
    await closeStreams();
    await super.close();
  }

  static Future<void> closeStreams() async {
    if (_timer != null) {
      _timer?.cancel();
    }
  }
}

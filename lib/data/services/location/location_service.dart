import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationService {
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  Future<bool> checkLocationService() async {
    // Test if location services are enabled.
    return await _geolocatorPlatform.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkPermission() async {
    return await _geolocatorPlatform.checkPermission();
  }

  Future<LocationPermission> requestPermission() async {
    /// This request permission line opens a window requesting location permission from user.
    return await _geolocatorPlatform.requestPermission();
  }

  Future<Position?> getCurrentPosition() async {
    return await _geolocatorPlatform.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.best));
  }

  Future<Position?> getLastKnownPosition() async {
    return await _geolocatorPlatform.getLastKnownPosition();
  }

  // When app is running, if "location" service of phone is toggled, this code triggered.
  Stream<String> serviceStatusStream() {
    return _geolocatorPlatform
        .getServiceStatusStream()
        .map<String>((serviceStatus) {
      return serviceStatus.name;
    });
  }

  /*
  Stream<Position?> getCurrentPositionStream() {
    late LocationSettings locationSettings;

    if (defaultTargetPlatform == TargetPlatform.android) {
      locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 100,
          forceLocationManager: true,
          intervalDuration: const Duration(seconds: 10),
          // (Optional) Set foreground notification config to keep the app alive
          // when going to the background
          foregroundNotificationConfig: const ForegroundNotificationConfig(
            notificationText:
                "Example app will continue to receive your location even when you aren't using it",
            notificationTitle: "Running in Background",
            enableWakeLock: true,
          ));
    } else if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      locationSettings = AppleSettings(
        accuracy: LocationAccuracy.best,
        activityType: ActivityType.fitness,
        distanceFilter: 100,
        pauseLocationUpdatesAutomatically: true,
        // Only set to true if our app will be started up in the background.
        showBackgroundLocationIndicator: false,
      );
    } else {
      locationSettings = const LocationSettings(
        accuracy: LocationAccuracy.best,
        distanceFilter: 100,
      );
    }

    return _geolocatorPlatform
        .getPositionStream(locationSettings: locationSettings)
        .map<Position?>((Position? position) {
      return position;
    });
  }
   */


  Future<bool> openAppSettings() async {
    return await _geolocatorPlatform.openAppSettings();
  }

  /// ******************* IOS Only Functions **********************/
  Future<String> getLocationAccuracy() async {
    final status = await _geolocatorPlatform.getLocationAccuracy();
    return _handleLocationAccuracyStatus(status);
  }

  void requestTemporaryFullAccuracy() async {
    final status = await _geolocatorPlatform.requestTemporaryFullAccuracy(
      purposeKey: "TemporaryPreciseAccuracy",
    );
    _handleLocationAccuracyStatus(status);
  }

  String _handleLocationAccuracyStatus(LocationAccuracyStatus status) {
    String locationAccuracyStatusValue;
    if (status == LocationAccuracyStatus.precise) {
      locationAccuracyStatusValue = 'Precise';
    } else if (status == LocationAccuracyStatus.reduced) {
      locationAccuracyStatusValue = 'Reduced';
    } else {
      locationAccuracyStatusValue = 'Unknown';
    }
    return locationAccuracyStatusValue;
  }

  /// ***************************************************************/
}

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:peopler/data/fcm_and_local_notifications.dart';
import 'package:peopler/data/repository/location_repository.dart';
import '../../../others/locator.dart';
import '../../../others/strings.dart';
import 'bloc.dart';

class LocationPermissionBloc extends Bloc<LocationPermissionEvent, LocationPermissionState> {
  final LocationRepository _locationRepository = locator<LocationRepository>();

  StreamSubscription? _streamSubscription;
  LocationPermission? _permission;

  LocationPermissionBloc() : super(NoPermissionState()) {
    on<GetLocationPermissionEvent>((event, emit) async {
      try {
        _permission = await _locationRepository.checkPermissions();

        if (_permission == LocationPermission.whileInUse || _permission == LocationPermission.always) {
          /// If permission already given, no problem, then check for location
          add(LocationSettingListener());
        } else if(_permission == LocationPermission.denied ){
          /// If "ask every time" chosen, then app can popUp requestPermission dialog. Thus, ask for user to request permission last time and wait for his choice.
          _permission = await _locationRepository.requestPermission();
          if(_permission == LocationPermission.whileInUse) {
            /// If user choose permission whileInUse, no problem, then check for location
            add(LocationSettingListener());
          }else{
            emit(NoPermissionState());
          }
        }else if(_permission == LocationPermission.deniedForever ){
          /// If user chosen "Don't allow before, then app cannot popUp requestPermission dialog, so app will push a notification that user need to open settings and allow himself/herself"
          emit(NoPermissionState());
          /// FUTURE: Trig a notification that user need to allow permission
        }
      } catch (e) {
        debugPrint("Blocta location permission hata:" + e.toString());
      }
    });

    on<GetLocationPermissionForHomeScreenEvent>((event, emit) async {
      try {
        _permission = await _locationRepository.checkPermissions();
        bool _locationStatus = await _locationRepository.checkLocationSetting();


        if (_permission == LocationPermission.always) {
          /// Since permission already given, no problem, then check for location
          add(LocationSettingListener());

        } else if (_permission == LocationPermission.whileInUse) {
          /// When notification button clicked, open Permission Settings
          await FCMAndLocalNotifications.showNotificationForLocationPermissions('İzin', 'Uygulamanız arka planda çalışırken bulunabilir olmanız için ayarlardan Her zaman İzin Ver seçiniz.', Strings.permissionSettings);

          /// Since permission already given, no problem, then check for location
          add(LocationSettingListener());

        } else if(_permission == LocationPermission.denied){
          /// When notification button clicked, requestPermission dialog opens
          await FCMAndLocalNotifications.showNotificationForLocationPermissions('İzin', 'Yakınınızdaki kişileri bulabilmek veya onların sizi bulabilmesi için Uygulamayı Kullanırken seçiniz.', Strings.requestPermission);

        } else if(_permission == LocationPermission.deniedForever ){
          /// When notification button clicked, open Permission Settings window because requestPermission does not run
          await FCMAndLocalNotifications.showNotificationForLocationPermissions('İzin', 'Yakınınızdaki kişileri bulabilmek veya onların sizi bulabilmesi için ayarlardan Uygulamayı Kullanırken seçiniz.', Strings.permissionSettings);

        } else if(_locationStatus == false){
          /// When notification button clicked, open Google's location setting dialog window.
          await FCMAndLocalNotifications.showNotificationForLocationPermissions('Konum', 'Yakınınızdaki kişileri bulabilmek veya onların sizi bulabilmesi için konum özelliğini açmanız gerekir.', Strings.googleDialog);
        }
      } catch (e) {
        debugPrint("Blocta location permission hata:" + e.toString());
      }
    });


    on<LocationSettingListener>((event, emit) async {

      /// Check if location setting is open
      bool locationStatus = await _locationRepository.checkLocationSetting();
      if(locationStatus == false) {
        /// If location setting is closed, then popUp Google location setting window
        await _locationRepository.requestLocationSetting();
        /// Until user open setting, emit no location state
        add(EmitNoLocationEvent());
        if(_streamSubscription == null) {
          _streamSubscription = _locationRepository.serviceStatusStream().listen(null);
          _streamSubscription?.onData((data) {
            /// If user opened location setting, then this stream will be triggered,
            /// canceled and so user ready to get nearby users
            debugPrint("LOCATION TOGGLE");
            _streamSubscription?.cancel();
            _streamSubscription = null;
            add(EmitReadyEvent());
          });
        }
      } else {
        /// If location setting is open, then user ready to get nearby users
        add(EmitReadyEvent());
      }
    });

    /// Inside stream, since bloc cannot emit state maybe because of a bug,
    /// following events which will emit related states will be triggered.
    on<EmitReadyEvent>((event, emit) async {
        emit(ReadyState());
    });

    on<EmitNoLocationEvent>((event, emit) async {
      emit(NoLocationState());
    });

    on<OpenSettingsClicked>((event, emit) async {
      await _locationRepository.openPermissionSettings();
      /// This delay is used to navigate user to refresh screen after 2 seconds because while AppSettings opening, user should not see that screen change in app.
      // await Future.delayed(const Duration(seconds: 2));
      emit(NoPermissionClickSettingsState());
    });

  }
}

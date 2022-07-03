import 'package:equatable/equatable.dart';

abstract class LocationPermissionState extends Equatable {
  const LocationPermissionState();
}

class NoPermissionState extends LocationPermissionState {
  @override
  List<Object> get props => [];
}

class NoLocationState extends LocationPermissionState {
  @override
  List<Object> get props => [];
}

class ReadyState extends LocationPermissionState {
  @override
  List<Object> get props => [];
}

class NoPermissionClickSettingsState extends LocationPermissionState {
  @override
  List<Object> get props => [];
}

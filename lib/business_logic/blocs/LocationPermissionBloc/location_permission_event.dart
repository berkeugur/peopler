import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';


@immutable
abstract class LocationPermissionEvent extends Equatable {}

class GetLocationPermissionEvent extends LocationPermissionEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}


class GetLocationPermissionForHomeScreenEvent extends LocationPermissionEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class LocationSettingListener extends LocationPermissionEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class EmitReadyEvent extends LocationPermissionEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class EmitNoLocationEvent extends LocationPermissionEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class OpenSettingsClicked extends LocationPermissionEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}



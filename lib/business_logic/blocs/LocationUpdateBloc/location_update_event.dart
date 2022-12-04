import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LocationUpdateEvent extends Equatable {}

class UpdateLocationEvent extends LocationUpdateEvent {
  @override
  List<Object> get props => [];
}

class UpdateNumOfSendRequest extends LocationUpdateEvent {
  @override
  List<Object> get props => [];
}

class StartLocationUpdatesBackground extends LocationUpdateEvent {
  @override
  List<Object?> get props => [];
}

class StartLocationUpdatesForeground extends LocationUpdateEvent {
  @override
  List<Object?> get props => [];
}

class ResetLocationUpdateEvent extends LocationUpdateEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

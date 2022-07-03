import 'package:equatable/equatable.dart';

abstract class LocationUpdateState extends Equatable {
  const LocationUpdateState();
}

class InitialState extends LocationUpdateState {
  @override
  List<Object> get props => [];
}

class PositionNotUpdatedState extends LocationUpdateState {
  @override
  List<Object> get props => [];
}

class PositionNotGetState extends LocationUpdateState {
  @override
  List<Object> get props => [];
}

class PositionUpdatedState extends LocationUpdateState {
  @override
  List<Object> get props => [];
}

class PositionDoesNotExistState extends LocationUpdateState {
  @override
  List<Object> get props => [];
}


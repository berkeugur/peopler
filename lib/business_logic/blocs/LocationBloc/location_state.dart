import 'package:equatable/equatable.dart';

abstract class LocationState extends Equatable {
  const LocationState();
}

class InitialSearchState extends LocationState {
  @override
  List<Object> get props => [];
}

class UsersLoadedSearchState extends LocationState {
  @override
  List<Object> get props => [];
}

class UsersNotExistSearchState extends LocationState {
  @override
  List<Object> get props => [];
}

class NewUsersLoadingSearchState extends LocationState {
  @override
  List<Object> get props => [];
}

class NoMoreUsersSearchState extends LocationState {
  @override
  List<Object> get props => [];
}

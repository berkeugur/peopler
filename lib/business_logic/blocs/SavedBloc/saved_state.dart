import 'package:equatable/equatable.dart';

abstract class SavedState extends Equatable {
  const SavedState();
}

class InitialSavedState extends SavedState {
  @override
  List<Object> get props => [];
}

class NewUsersLoadingSavedState extends SavedState {
  @override
  List<Object> get props => [];
}

class UsersLoadedSavedState extends SavedState {
  @override
  List<Object> get props => [];
}

class NoMoreUsersSavedState extends SavedState {
  @override
  List<Object> get props => [];
}

class UserNotExistSavedState extends SavedState {
  @override
  List<Object> get props => [];
}




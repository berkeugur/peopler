import 'package:equatable/equatable.dart';

abstract class UserState extends Equatable {
  const UserState();
}

class InitialUserState extends UserState {
  @override
  List<Object> get props => [];
}

class SignedOutState extends UserState {
  @override
  List<Object> get props => [];
}

class SignedInState extends UserState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ResetPasswordSentState extends UserState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SignedInMissingInfoState extends UserState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SignedInNotVerifiedState extends UserState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SigningInState extends UserState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class InvalidEmailState extends UserState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UserNotFoundState extends UserState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class WrongPasswordState extends UserState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SignErrorState extends UserState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class EmailAlreadyInUseState extends UserState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class WeakPasswordState extends UserState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DeletingState extends UserState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';


@immutable
abstract class UserEvent extends Equatable {}

class checkUserSignedInEvent extends UserEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class signOutEvent extends UserEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class signInWithLinkedInEvent extends UserEvent {
  String customToken;

  signInWithLinkedInEvent({required this.customToken});

  @override
  List<Object> get props => [customToken];
}

class updateUserInfoForLinkedInEvent extends UserEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class resendVerificationLink extends UserEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class resetPasswordEvent extends UserEvent {
  String email;

  resetPasswordEvent({required this.email});

  @override
// TODO: implement props
  List<Object> get props => [email];
}

class initializeMyUserEvent extends UserEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class waitForVerificationEvent extends UserEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class waitFor15minutes extends UserEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class createUserWithEmailAndPasswordEvent extends UserEvent {
  String email;
  String password;

  createUserWithEmailAndPasswordEvent({required this.email, required this.password});

  @override
// TODO: implement props
  List<Object> get props => [email, password];
}

class uploadProfilePhoto extends UserEvent {
  File? imageFile;

  uploadProfilePhoto({required this.imageFile});

  @override
// TODO: implement props
  List<File?> get props => [imageFile];
}

class signInWithEmailandPasswordEvent extends UserEvent {
  String email;
  String password;
  signInWithEmailandPasswordEvent({required this.email, required this.password});

  @override
// TODO: implement props
  List<Object> get props => [email, password];
}

class deleteUser extends UserEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

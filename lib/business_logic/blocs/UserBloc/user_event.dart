import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
abstract class UserEvent extends Equatable {}

class checkUserSignedInEvent extends UserEvent {
  BuildContext context;

  checkUserSignedInEvent({required this.context});

  @override
// TODO: implement props
  List<Object> get props => [context];
}

class signOutEvent extends UserEvent {
  BuildContext context;

  signOutEvent({required this.context});

  @override
// TODO: implement props
  List<Object> get props => [context];
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

class waitFor15minutes extends UserEvent {
  BuildContext context;

  waitFor15minutes({required this.context});

  @override
// TODO: implement props
  List<Object> get props => [context];
}

class waitForVerificationEvent extends UserEvent {
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

class uploadProfilePhotoEvent extends UserEvent {
  File? imageFile;

  uploadProfilePhotoEvent({required this.imageFile});

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

class SignInWithAppleEvent extends UserEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class deleteUser extends UserEvent {
  String? password;
  BuildContext? context;
  deleteUser({this.password, this.context});

  @override
// TODO: implement props
  List<Object?> get props => [password, context];
}

class ResetUserEvent extends UserEvent {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

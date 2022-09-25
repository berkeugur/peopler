import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../data/model/user.dart';


@immutable
abstract class LocationEvent extends Equatable {}

class GetInitialSearchUsersEvent extends LocationEvent {
  final int latitude;
  final int longitude;
  GetInitialSearchUsersEvent({
    required this.latitude, required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}

class GetMoreSearchUsersEvent extends LocationEvent {
  final int latitude;
  final int longitude;
  GetMoreSearchUsersEvent({
    required this.latitude, required this.longitude,
  });

  @override
  List<Object> get props => [latitude, longitude];
}

class TrigNewUsersLoadingSearchStateEvent extends LocationEvent {
  @override
  List<Object> get props => [];
}

class TrigUsersLoadedSearchStateEvent extends LocationEvent {
  @override
  List<Object> get props => [];
}

class TrigUsersNotExistSearchStateEvent extends LocationEvent {
  @override
  List<Object> get props => [];
}

class NewUserListenerEvent extends LocationEvent {
  final MyUser myUser;
  NewUserListenerEvent({
    required this.myUser,
  });

  @override
  List<Object> get props => [myUser];
}
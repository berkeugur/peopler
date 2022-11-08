import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../../../data/model/user.dart';


@immutable
abstract class CityEvent extends Equatable {}


class GetInitialSearchUsersCityEvent extends CityEvent {
  final String city;
  GetInitialSearchUsersCityEvent({
    required this.city,
  });

  @override
  List<Object> get props => [city];
}

class GetMoreSearchUsersCityEvent extends CityEvent {
  final String city;
  GetMoreSearchUsersCityEvent({
    required this.city,
  });

  @override
  List<Object> get props => [city];
}

class TrigUsersNotExistCityStateEvent extends CityEvent {
  final String city;
  TrigUsersNotExistCityStateEvent({
    required this.city,
  });

  @override
  List<Object> get props => [city];
}

class NewUserListenerEvent extends CityEvent {
  final MyUser myUser;
  final String city;
  NewUserListenerEvent({
    required this.myUser,
    required this.city,
  });

  @override
  List<Object> get props => [myUser, city];
}
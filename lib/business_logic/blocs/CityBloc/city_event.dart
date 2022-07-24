import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';


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

class TrigUsersLoadedCityStateEvent extends CityEvent {
  @override
  List<Object> get props => [];
}

class TrigUsersNotExistCityStateEvent extends CityEvent {
  @override
  List<Object> get props => [];
}
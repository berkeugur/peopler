import 'package:equatable/equatable.dart';

abstract class CityState extends Equatable {
  const CityState();
}

class InitialCityState extends CityState {
  @override
  List<Object> get props => [];
}

class UsersLoadedCityState1 extends CityState {
  @override
  List<Object> get props => [];
}

class UsersLoadedCityState2 extends CityState {
  @override
  List<Object> get props => [];
}

class UsersNotExistCityState extends CityState {
  @override
  List<Object> get props => [];
}

class NewUsersLoadingCityState extends CityState {
  @override
  List<Object> get props => [];
}

class NoMoreUsersCityState extends CityState {
  @override
  List<Object> get props => [];
}


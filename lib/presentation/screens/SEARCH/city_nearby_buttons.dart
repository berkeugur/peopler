import 'package:flutter/material.dart';

class CityNearbyButtons extends ChangeNotifier {
  bool _isNearby = true;
  bool get isNearby => _isNearby;

  set isNearby(bool value) {
    _isNearby = value;
    notifyListeners();
  }
}
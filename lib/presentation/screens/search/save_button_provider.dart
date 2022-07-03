import 'package:flutter/material.dart';

class SaveButton extends ChangeNotifier {
  bool _saved = false;
  bool get isSaved{
    return _saved;
  }

  void saveUser() {
    _saved = true;
    notifyListeners();
  }
}
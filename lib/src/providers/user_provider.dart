import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _name = 'Usuario Prueba';
  int _idItem = 0;

  String get name => _name;
  set name(String newName) {
    _name = newName;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorProvider extends ChangeNotifier {
  Color _currentColor = Colors.green;

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentColor = Color(prefs.getInt('color') ?? 0xFF00FF00);
  }

  Color get currentColor => _currentColor;
  set currentColor(Color color) => setColor(color);

  Future<void> setColor(Color color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('color', color.value);
    _currentColor = color;
    notifyListeners();
  }
}

class SettingsProvider extends ChangeNotifier {
  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentTodoList = prefs.getInt('currentTodoList') ?? 0;
    _showCompleted = prefs.getBool('showCompleted') ?? false;
    _currentColor = Color(prefs.getInt('color') ?? 0xFF00FF00);
  }

  int _currentTodoList = 0;
  bool _showCompleted = false;
  Color _currentColor = Colors.green;

  int get currentTodoList => _currentTodoList;
  set currentTodoList(int listId) => setCurrentTodoList(listId);
  bool get showCompleted => _showCompleted;
  set showCompleted(bool showCompleted) => setShowCompleted(showCompleted);
  Color get currentColor => _currentColor;
  set currentColor(Color color) => setColor(color);

  Future<void> setCurrentTodoList(int listId) async {
    _currentTodoList = listId;
    notifyListeners();
  }

  //TODO: Update this to update only the current list instead the whole app
  Future<void> setShowCompleted(bool showCompleted) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('showCompleted', showCompleted);
    _showCompleted = showCompleted;
    notifyListeners();
  }

  Future<void> setColor(Color color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('color', color.value);
    _currentColor = color;
    notifyListeners();
  }
}
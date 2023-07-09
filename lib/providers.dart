import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:collection/collection.dart';

import 'types.dart';

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

class TodoProvider extends ChangeNotifier {
  List<TodoColl> todoColls = [
    TodoColl(name: 'School', settings: Settings(color: Colors.blue), todos: [
      const Todo(
        title: 'Do homework',
        description: 'Do homework for math',
      ),
      const Todo(
        title: 'Do homework',
        description: 'Do homework for math',
      ),
      const Todo(
        title: 'Do homework',
        description: 'Do homework for math',
      ),
    ]),
  ];

  Future<void> init() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentTodoColl = prefs.getString('currentTodoColl');
    _showCompleted = prefs.getBool('showCompleted') ?? false; //This should be in some global settings
    _currentColor = Color(prefs.getInt('color') ?? 0xFF00FF00);
  }

  String? _currentTodoColl;
  bool _showCompleted = false;
  Color _currentColor = Colors.green;

  String? get currentTodoColl => _currentTodoColl;
  set currentTodoColl(String? collName) => setCurrentTodoColl(collName);
  bool get showCompleted => _showCompleted;
  set showCompleted(bool showCompleted) => setShowCompleted(showCompleted);
  Color get currentColor => _currentColor;
  set currentColor(Color color) => setColor(color);

  void setCurrentTodoColl(String? collName) {
    log('setTodoColl: $collName');
    _currentTodoColl = collName;
    log('setTodoColl: $currentTodoColl');
    notifyListeners();
  }


  TodoColl? getTodoColl(String? collName) {
    log('getTodoColl: $collName');
    return todoColls.firstWhereOrNull((coll) => coll.name == collName);
  }
  
  TodoColl? getCurrentTodoColl() {
    log('getCurrentTodoColl: $currentTodoColl');
    return getTodoColl(currentTodoColl);
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
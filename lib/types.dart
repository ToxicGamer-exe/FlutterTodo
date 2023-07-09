import 'dart:convert';
import 'package:flutter/material.dart';

class Settings {
  Settings({
    this.color,
  });

  Color? color;

  static Settings fromJson(String e) {
    final json = jsonDecode(e);
    return Settings(
      color: json['color'] != null ? Color(json['color']) : Colors.green,
    );
  }
}

class TodoColl {
  TodoColl({
    // required this.id,
    required this.name,
    this.todos = const [],
    this.settings,
  });

  // final String id;
  final String name;
  List<Todo>? todos = [];
  Settings? settings;

  static TodoColl fromJson(String e) {
    final json = jsonDecode(e);
    return TodoColl(
      // id: json['id'],
      name: json['name'],
      todos: (json['todos'] as List).map((e) => Todo.fromJson(e)).toList(),
      settings:
      json['settings'] != null ? Settings.fromJson(json['settings']) : null,
    );
  }
}

class Todo {
  const Todo({
    required this.title,
    required this.description,
    this.isDone = false,
  });

  final String title;
  final String description;
  final bool isDone;

  static Todo fromJson(String e) {
    final json = jsonDecode(e);
    return Todo(
      title: json['title'],
      description: json['description'],
      isDone: json['isDone'] ?? false,
    );
  }
}
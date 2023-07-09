library my_prj.globals;
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

Color currentColor = const Color(0xFF00FF00);
init() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  currentColor = Color(prefs?.getInt('color') ?? 0xFF00FF00);
}

Future<Color?> getColor() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return Color(prefs.getInt('color') ?? 0xFF00FF00);
}

Future<void> setColor(Color color) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setInt('color', color.value);
  currentColor = color;
}

//This isn't the way...

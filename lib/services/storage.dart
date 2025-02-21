import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todoapp/model/tasks.dart';

class TaskStorageService {
  static const String _storageKey = 'tasks_data';

  // ********************** Save Data Function **************************
  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = _encodeTasks(tasks);
    await prefs.setString(_storageKey, jsonString);
  }

  // ********************* Load Data Function ***************************
  static Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    return jsonString != null ? _decodeTasks(jsonString) : [];
  }

  // ********************* Data Encoding *******************************
  static String _encodeTasks(List<Task> tasks) {
    return jsonEncode(tasks.map((task) => task.toJson()).toList());
  }

  // ********************* Data Decoding *******************************
  static List<Task> _decodeTasks(String jsonString) {
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((json) => Task.fromJson(json)).toList();
  }
}
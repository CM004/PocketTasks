import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const String _storageKey = 'pocket_tasks_v1';

  Future<List<Task>> loadTasks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = prefs.getStringList(_storageKey) ?? [];
      
      debugPrint('Loading ${tasksJson.length} tasks from storage');
      
      final tasks = tasksJson
          .map((taskJson) => Task.fromJson(jsonDecode(taskJson)))
          .toList();
      
      debugPrint('Successfully loaded ${tasks.length} tasks');
      return tasks;
    } catch (e) {
      debugPrint('Error loading tasks: $e');
      // If there's an error loading tasks, return empty list
      return [];
    }
  }

  Future<void> saveTasks(List<Task> tasks) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final tasksJson = tasks
          .map((task) => jsonEncode(task.toJson()))
          .toList();
      
      debugPrint('Saving ${tasks.length} tasks to storage');
      await prefs.setStringList(_storageKey, tasksJson);
      debugPrint('Successfully saved ${tasks.length} tasks');
    } catch (e) {
      // Handle storage error
      debugPrint('Error saving tasks: $e');
    }
  }
} 
import 'package:flutter/foundation.dart';
import '../models/task.dart';
import 'storage_service.dart';

enum TaskFilter { all, active, done }

class TaskManager extends ChangeNotifier {
  final StorageService _storageService = StorageService();
  
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  TaskFilter _currentFilter = TaskFilter.all;
  String _searchQuery = '';
  bool _isInitialized = false;
  
  List<Task> get tasks => _tasks;
  List<Task> get filteredTasks => _filteredTasks;
  TaskFilter get currentFilter => _currentFilter;
  String get searchQuery => _searchQuery;
  bool get isInitialized => _isInitialized;
  
  int get totalTasks => _tasks.length;
  int get completedTasks => _tasks.where((task) => task.done).length;
  int get activeTasks => _tasks.where((task) => !task.done).length;

  TaskManager() {
    _initialize();
  }

  Future<void> _initialize() async {
    await _loadTasks();
    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _loadTasks() async {
    try {
      _tasks = await _storageService.loadTasks();
      _applyFilters();
    } catch (e) {
      debugPrint('Error loading tasks: $e');
      _tasks = [];
      _applyFilters();
    }
  }

  Future<void> _saveTasks() async {
    try {
      await _storageService.saveTasks(_tasks);
    } catch (e) {
      debugPrint('Error saving tasks: $e');
    }
  }

  void _applyFilters() {
    _filteredTasks = _tasks.where((task) {
      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        if (!task.title.toLowerCase().contains(_searchQuery.toLowerCase())) {
          return false;
        }
      }
      
      // Apply status filter
      switch (_currentFilter) {
        case TaskFilter.active:
          return !task.done;
        case TaskFilter.done:
          return task.done;
        case TaskFilter.all:
          return true;
      }
    }).toList();
  }

  Future<void> addTask(String title) async {
    if (title.trim().isEmpty) return;
    
    final task = Task(title: title.trim());
    _tasks.add(task);
    await _saveTasks();
    _applyFilters();
    notifyListeners();
  }

  Future<void> toggleTask(String taskId) async {
    final taskIndex = _tasks.indexWhere((task) => task.id == taskId);
    if (taskIndex != -1) {
      _tasks[taskIndex] = _tasks[taskIndex].copyWith(
        done: !_tasks[taskIndex].done,
      );
      await _saveTasks();
      _applyFilters();
      notifyListeners();
    }
  }

  Future<void> deleteTask(String taskId) async {
    _tasks.removeWhere((task) => task.id == taskId);
    await _saveTasks();
    _applyFilters();
    notifyListeners();
  }

  void setFilter(TaskFilter filter) {
    _currentFilter = filter;
    _applyFilters();
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void clearSearch() {
    _searchQuery = '';
    _applyFilters();
    notifyListeners();
  }
} 
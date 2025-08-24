import 'package:flutter/material.dart';
import '../services/task_manager.dart';
import '../widgets/circular_progress_ring.dart';
import '../widgets/add_task_input.dart';
import '../widgets/debounced_search_field.dart';
import '../widgets/filter_chips.dart';
import '../widgets/task_list_item.dart';
import '../models/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final TaskManager _taskManager;
  Task? _lastDeletedTask;
  Task? _lastToggledTask;

  @override
  void initState() {
    super.initState();
    _taskManager = TaskManager();
    _taskManager.addListener(_onTaskManagerChanged);
  }

  @override
  void dispose() {
    _taskManager.removeListener(_onTaskManagerChanged);
    super.dispose();
  }

  void _onTaskManagerChanged() {
    setState(() {});
  }

  void _addTask(String title) {
    _taskManager.addTask(title);
  }

  void _toggleTask(String taskId) {
    final task = _taskManager.tasks.firstWhere((t) => t.id == taskId);
    _lastToggledTask = task;
    
    _taskManager.toggleTask(taskId);
    
    _showToggleSnackBar(task);
  }

  void _deleteTask(String taskId) {
    final task = _taskManager.tasks.firstWhere((t) => t.id == taskId);
    _lastDeletedTask = task;
    
    _taskManager.deleteTask(taskId);
  }

  void _undoDelete() {
    if (_lastDeletedTask != null) {
      _taskManager.addTask(_lastDeletedTask!.title);
      _lastDeletedTask = null;
    }
  }

  void _undoToggle() {
    if (_lastToggledTask != null) {
      _taskManager.toggleTask(_lastToggledTask!.id);
      _lastToggledTask = null;
    }
  }

  void _showToggleSnackBar(Task task) {
    final action = task.done ? 'completed' : 'marked as active';
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Task $action'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: _undoToggle,
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!_taskManager.isInitialized) {
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            // Header with progress ring and title
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircularProgressRing(
                    completed: _taskManager.completedTasks,
                    total: _taskManager.totalTasks,
                    size: 60,
                    progressColor: Colors.green,
                    backgroundColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.2),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'PocketTasks',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF6750A4)
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Add task input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: AddTaskInput(onAddTask: _addTask),
            ),
            
            const SizedBox(height: 20),
            
            // Search field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: DebouncedSearchField(
                hintText: 'Search',
                onChanged: _taskManager.setSearchQuery,
                onClear: _taskManager.clearSearch,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Filter chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FilterChips(
                currentFilter: _taskManager.currentFilter,
                onFilterChanged: _taskManager.setFilter,
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Task list
            Expanded(
              child: _taskManager.filteredTasks.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.only(bottom: 20),
                      itemCount: _taskManager.filteredTasks.length,
                      itemBuilder: (context, index) {
                        final task = _taskManager.filteredTasks[index];
                        return TaskListItem(
                          task: task,
                          onToggle: () => _toggleTask(task.id),
                          onDelete: () => _deleteTask(task.id),
                          onUndo: _undoDelete,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final isSearching = _taskManager.searchQuery.isNotEmpty;
    final hasFilter = _taskManager.currentFilter != TaskFilter.all;
    
    String message;
    if (isSearching) {
      message = 'No tasks found for "${_taskManager.searchQuery}"';
    } else if (hasFilter) {
      final filterName = _taskManager.currentFilter.name;
      message = 'No $filterName tasks';
    } else {
      message = 'No tasks yet. Add your first task above!';
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isSearching ? Icons.search_off : Icons.task_alt,
            size: 64,
            color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
} 
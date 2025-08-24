import 'package:flutter_test/flutter_test.dart';
import 'package:shoppy/services/task_manager.dart';

void main() {
  group('TaskManager Tests', () {
    late TaskManager taskManager;

    setUp(() {
      taskManager = TaskManager();
    });

    group('Filter Tests', () {
      test('should filter All tasks correctly', () {
        // Add some test tasks
        taskManager.addTask('Task 1');
        taskManager.addTask('Task 2');
        taskManager.addTask('Task 3');
        
        // Toggle one task to done
        taskManager.toggleTask(taskManager.tasks[0].id);
        
        // Set filter to All
        taskManager.setFilter(TaskFilter.all);
        
        // Should show all tasks
        expect(taskManager.filteredTasks.length, equals(3));
      });

      test('should filter Active tasks correctly', () {
        // Add some test tasks
        taskManager.addTask('Active Task 1');
        taskManager.addTask('Active Task 2');
        taskManager.addTask('Done Task 1');
        
        // Toggle one task to done
        taskManager.toggleTask(taskManager.tasks[2].id);
        
        // Set filter to Active
        taskManager.setFilter(TaskFilter.active);
        
        // Should show only active tasks
        expect(taskManager.filteredTasks.length, equals(2));
        expect(taskManager.filteredTasks.every((task) => !task.done), isTrue);
      });

      test('should filter Done tasks correctly', () {
        // Add some test tasks
        taskManager.addTask('Active Task 1');
        taskManager.addTask('Done Task 1');
        taskManager.addTask('Done Task 2');
        
        // Toggle two tasks to done
        taskManager.toggleTask(taskManager.tasks[1].id);
        taskManager.toggleTask(taskManager.tasks[2].id);
        
        // Set filter to Done
        taskManager.setFilter(TaskFilter.done);
        
        // Should show only done tasks
        expect(taskManager.filteredTasks.length, equals(2));
        expect(taskManager.filteredTasks.every((task) => task.done), isTrue);
      });
    });

    group('Search Tests', () {
      test('should filter tasks by search query', () {
        // Add some test tasks
        taskManager.addTask('Buy groceries');
        taskManager.addTask('Walk the dog');
        taskManager.addTask('Call Alice');
        
        // Search for "groceries"
        taskManager.setSearchQuery('groceries');
        
        // Should show only tasks containing "groceries"
        expect(taskManager.filteredTasks.length, equals(1));
        expect(taskManager.filteredTasks[0].title, equals('Buy groceries'));
      });

      test('should filter tasks case-insensitively', () {
        // Add some test tasks
        taskManager.addTask('Buy GROCERIES');
        taskManager.addTask('Walk the dog');
        taskManager.addTask('Call ALICE');
        
        // Search for "alice" (lowercase)
        taskManager.setSearchQuery('alice');
        
        // Should show tasks containing "alice" regardless of case
        expect(taskManager.filteredTasks.length, equals(1));
        expect(taskManager.filteredTasks[0].title, equals('Call ALICE'));
      });

      test('should clear search correctly', () {
        // Add some test tasks
        taskManager.addTask('Task 1');
        taskManager.addTask('Task 2');
        
        // Search for something
        taskManager.setSearchQuery('Task');
        expect(taskManager.filteredTasks.length, equals(2));
        
        // Clear search
        taskManager.clearSearch();
        expect(taskManager.filteredTasks.length, equals(2));
        expect(taskManager.searchQuery, equals(''));
      });
    });

    group('Combined Filter and Search Tests', () {
      test('should combine filter and search correctly', () {
        // Add some test tasks
        taskManager.addTask('Active Task 1');
        taskManager.addTask('Active Task 2');
        taskManager.addTask('Done Task 1');
        taskManager.addTask('Done Task 2');
        
        // Toggle two tasks to done
        taskManager.toggleTask(taskManager.tasks[2].id);
        taskManager.toggleTask(taskManager.tasks[3].id);
        
        // Set filter to Active and search for "Task"
        taskManager.setFilter(TaskFilter.active);
        taskManager.setSearchQuery('Task');
        
        // Should show only active tasks containing "Task"
        expect(taskManager.filteredTasks.length, equals(2));
        expect(taskManager.filteredTasks.every((task) => !task.done), isTrue);
        expect(taskManager.filteredTasks.every((task) => task.title.contains('Task')), isTrue);
      });
    });

    group('Task Count Tests', () {
      test('should calculate task counts correctly', () {
        // Add some test tasks
        taskManager.addTask('Task 1');
        taskManager.addTask('Task 2');
        taskManager.addTask('Task 3');
        
        // Initially all tasks are active
        expect(taskManager.totalTasks, equals(3));
        expect(taskManager.activeTasks, equals(3));
        expect(taskManager.completedTasks, equals(0));
        
        // Toggle one task to done
        taskManager.toggleTask(taskManager.tasks[0].id);
        
        // Check updated counts
        expect(taskManager.totalTasks, equals(3));
        expect(taskManager.activeTasks, equals(2));
        expect(taskManager.completedTasks, equals(1));
      });
    });
  });
} 
# PocketTasks - Task Management App

A clean, modern task management application built with Flutter that focuses on simplicity, performance, and user experience.

## Features

### Core Functionality
- ✅ **Add Tasks**: Create new tasks with validation
- ✅ **Toggle Completion**: Mark tasks as done/undone with undo support
- ✅ **Delete Tasks**: Swipe to delete with undo functionality
- ✅ **Search**: Debounced search (300ms) for filtering tasks
- ✅ **Filter**: All / Active / Done filter options
- ✅ **Local Storage**: Persistent storage using shared_preferences
- ✅ **Undo System**: SnackBar-based undo for both toggle and delete actions

### UI/UX Features
- 🎨 **Modern Design**: Clean Material Design 3 interface
- 🌓 **Theme Support**: Light and dark theme support
- 📱 **Responsive**: Optimized for mobile devices
- 🎯 **Custom Progress Ring**: Visual task completion indicator
- 📝 **Inline Validation**: Real-time error feedback for empty inputs
- 🔍 **Smart Search**: Debounced search with clear functionality

### Technical Features
- 🚀 **Performance**: ListView.builder for efficient rendering
- 🔄 **State Management**: ChangeNotifier-based reactive architecture
- 💾 **Persistence**: JSON-based local storage with error handling
- 🧪 **Testing**: Comprehensive unit tests for core functionality
- 📦 **Modular**: Clean separation of concerns with dedicated services

## Architecture

```
lib/
├── models/
│   └── task.dart              # Task data model
├── services/
│   ├── storage_service.dart   # Local storage service
│   └── task_manager.dart      # Business logic & state management
├── widgets/
│   ├── circular_progress_ring.dart  # Custom painter widget
│   ├── add_task_input.dart          # Task input with validation
│   ├── debounced_search_field.dart  # Search with debouncing
│   ├── filter_chips.dart            # Filter selection chips
│   └── task_list_item.dart          # Individual task display
├── screens/
│   └── home_screen.dart       # Main application screen
└── main.dart                  # App entry point
```

## Getting Started

### Prerequisites
- Flutter SDK (^3.8.1)
- Dart SDK
- Android Studio / VS Code

### Installation
1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

### Dependencies
- `shared_preferences`: Local storage
- `uuid`: Unique identifier generation
- `flutter_test`: Testing framework

## Testing

Run the test suite:
```bash
flutter test
```

The test suite covers:
- Task filtering (All/Active/Done)
- Search functionality
- Combined filter and search
- Task counting logic

## Key Implementation Details

### Custom Painter
The circular progress ring uses `CustomPainter` to draw:
- Background circle with configurable colors
- Progress arc based on completion ratio
- Smooth animations and proper scaling

### Debounced Search
Search input is debounced by 300ms to:
- Reduce unnecessary filtering operations
- Improve performance with large task lists
- Provide smooth user experience

### State Management
Uses `ChangeNotifier` pattern for:
- Reactive UI updates
- Clean separation of business logic
- Efficient state propagation

### Local Storage
Tasks are stored as JSON in shared_preferences:
- Automatic serialization/deserialization
- Error handling for corrupted data
- Versioned storage key (`pocket_tasks_v1`)

## Performance Considerations

- **ListView.builder**: Efficient rendering for large lists
- **Debounced search**: Prevents excessive filtering
- **Optimized rebuilds**: Only necessary widgets rebuild
- **Memory management**: Proper disposal of controllers and listeners

## Future Enhancements

- [ ] Task categories/tags
- [ ] Due dates and reminders
- [ ] Task priority levels
- [ ] Cloud synchronization
- [ ] Export/import functionality
- [ ] Advanced filtering options

## License

This project is created for educational purposes and demonstration of Flutter development best practices.

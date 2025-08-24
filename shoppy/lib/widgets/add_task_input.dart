import 'package:flutter/material.dart';

class AddTaskInput extends StatefulWidget {
  final Function(String) onAddTask;

  const AddTaskInput({
    super.key,
    required this.onAddTask,
  });

  @override
  State<AddTaskInput> createState() => _AddTaskInputState();
}

class _AddTaskInputState extends State<AddTaskInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showError = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addTask() {
    final title = _controller.text.trim();
    
    if (title.isEmpty) {
      setState(() {
        _showError = true;
        _errorMessage = 'Task title cannot be empty';
      });
      _focusNode.requestFocus();
      return;
    }

    setState(() {
      _showError = false;
      _errorMessage = '';
    });

    widget.onAddTask(title);
    _controller.clear();
    _focusNode.unfocus();
  }

  void _onChanged(String value) {
    if (_showError && value.trim().isNotEmpty) {
      setState(() {
        _showError = false;
        _errorMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: _onChanged,
                onSubmitted: (_) => _addTask(),
                decoration: InputDecoration(
                  hintText: 'Add Task',
                  hintStyle: TextStyle(
                    color: Theme.of(context).hintColor.withValues(alpha: 0.7),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _showError
                          ? Colors.red
                          : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _showError
                          ? Colors.red
                          : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: _showError
                          ? Colors.red
                          : Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              onPressed: _addTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Add',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        if (_showError) ...[
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Text(
              _errorMessage,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
} 
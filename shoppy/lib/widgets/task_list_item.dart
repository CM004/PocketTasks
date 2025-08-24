import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback? onUndo;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onDelete,
    this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 24,
        ),
      ),
      onDismissed: (direction) {
        onDelete();
        if (onUndo != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Task deleted'),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: onUndo!,
              ),
              duration: const Duration(seconds: 3),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: GestureDetector(
            onTap: onToggle,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task.done
                    ? Theme.of(context).colorScheme.primary
                    : Colors.transparent,
                border: Border.all(
                                  color: task.done
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: task.done
                  ? Icon(
                      Icons.check,
                      size: 16,
                      color: Theme.of(context).colorScheme.onPrimary,
                    )
                  : null,
            ),
          ),
          title: Text(
            task.title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: task.done
                  ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)
                  : Theme.of(context).colorScheme.onSurface,
              decoration: task.done ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            'Created ${_formatDate(task.createdAt)}',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          onTap: onToggle,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        return '${difference.inMinutes} minutes ago';
      }
      return '${difference.inHours} hours ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
} 
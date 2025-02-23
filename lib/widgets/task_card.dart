import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/model/tasks.dart';

class TaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onDismissed;

  const TaskCard({Key? key, required this.task, required this.onDismissed})
      : super(key: key);

  Color _getStatusColor(BuildContext context) {
    if (task.completed) return Colors.green;
    if (task.dueDate.isBefore(DateTime.now())) return Colors.red;
    return Theme.of(context).primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEE, MMM d • hh:mm a');
    final dueDateStr = dateFormat.format(task.dueDate);
    final statusColor = _getStatusColor(context);

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.red.shade400, Colors.red.shade600],
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(Icons.delete_forever, color: Colors.white),
              SizedBox(width: 8),
              Text('Delete',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ],
          ),
        ),
      ),
      onDismissed: (direction) => onDismissed?.call(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 24,
                    decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87),
                    ),
                  ),
                  if (task.priority != TaskPriority.medium)
                    Icon(
                        task.priority == TaskPriority.high
                            ? Icons.keyboard_arrow_up_rounded
                            : Icons.keyboard_arrow_down_rounded,
                        color: task.priority.color,
                        size: 20),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.access_time_filled,
                      size: 16, color: Colors.grey.shade600),
                  const SizedBox(width: 8),
                  Text(
                    dueDateStr,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500),
                  ),
                  const Spacer(),
                  if (task.category != null)
                    Row(
                      children: [
                        Icon(task.category!.icon,
                            size: 16, color: task.category!.color),
                        const SizedBox(width: 4),
                        Text(
                          task.category!.name,
                          style: TextStyle(
                              fontSize: 13,
                              color: task.category!.color,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Stack(
                children: [
                  Container(
                    height: 6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                  SizedBox(
                    height: 6,
                    child: AnimatedFractionallySizedBox(
                      duration: const Duration(milliseconds: 300),
                      widthFactor: task.progress,
                      heightFactor: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: statusColor,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${(task.progress * 100).toStringAsFixed(0)}% Complete',
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500),
                  ),
                  if (task.subtasks.isNotEmpty)
                    Text(
                      '${task.subtasks.where((s) => s.completed).length}'
                      '/${task.subtasks.length} tasks',
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

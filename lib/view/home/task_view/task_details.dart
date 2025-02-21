import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/model/tasks.dart';

void showTaskDetailsModal({
  required BuildContext context,
  required Task task,
  required VoidCallback onTaskFinished,
  required VoidCallback onDeleteTask,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: TaskDetailsModal(
          task: task,
          onTaskFinished: onTaskFinished,
          onDeleteTask: onDeleteTask,
        ),
      );
    },
  );
}

class TaskDetailsModal extends StatelessWidget {
  final Task task;
  final VoidCallback onTaskFinished;
  final VoidCallback onDeleteTask;

  const TaskDetailsModal({
    Key? key,
    required this.task,
    required this.onTaskFinished,
    required this.onDeleteTask,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final dateFormat = DateFormat('EEE, MMM d • hh:mm a');
    final timeLeft = task.dueDate.difference(DateTime.now());
    final timeLeftText = timeLeft.isNegative 
        ? 'Overdue by ${DateFormat('d').format(DateTime.now().subtract(timeLeft))} days'
        : 'Due in ${timeLeft.inDays}d ${timeLeft.inHours.remainder(24)}h';

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TASK DETAILS',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                        letterSpacing: 1.2,
                      ),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.grey[600]),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Task Title with Status
            Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: task.completed ? Colors.green : Colors.orange,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    task.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[900],
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Info Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              childAspectRatio: 3.5,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _InfoItem(
                  icon: Icons.calendar_today,
                  title: 'Created',
                  value: DateFormat('MMM d, y').format(task.createdAt),
                ),
                _InfoItem(
                  icon: Icons.timelapse,
                  title: 'Time Left',
                  value: timeLeftText,
                  warning: timeLeft.inHours < 24,
                ),
                _InfoItem(
                  icon: Icons.category,
                  title: 'Category',
                  value: task.category?.name ?? 'General',
                  color: task.category?.color ?? Colors.blue,
                ),
                _InfoItem(
                  icon: Icons.priority_high,
                  title: 'Priority',
                  value: task.priority.label,
                  color: task.priority.color,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Progress Section
            _ProgressSection(
              progress: task.progress,
              subtasks: task.subtasks,
            ),
            const SizedBox(height: 24),

            // Description
            Text(
              'DESCRIPTION',
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              task.description,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 16,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: _ActionButton(
                    icon: Icons.check_circle,
                    label: 'Complete',
                    color: Colors.green,
                    onPressed: onTaskFinished),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ActionButton(
                    icon: Icons.delete,
                    label: 'Delete',
                    color: Colors.red,
                    onPressed: onDeleteTask,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color? color;
  final bool warning;

  const _InfoItem({
    required this.icon,
    required this.title,
    required this.value,
    this.color,
    this.warning = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color ?? Colors.grey[600]),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title.toUpperCase(),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: warning ? Colors.orange : Colors.grey[800],
                fontWeight: warning ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ProgressSection extends StatelessWidget {
  final double progress;
  final List<Subtask>? subtasks;

  const _ProgressSection({required this.progress, this.subtasks});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'PROGRESS'.toUpperCase(),
              style: TextStyle(
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          color: Colors.blue,
          minHeight: 8,
          borderRadius: BorderRadius.circular(4),
        ),
        if (subtasks != null) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: subtasks!
                .map((subtask) => Chip(
                      avatar: Icon(
                        subtask.completed 
                            ? Icons.check_circle 
                            : Icons.radio_button_unchecked,
                        size: 18,
                        color: subtask.completed ? Colors.green : Colors.grey,
                      ),
                      label: Text(subtask.title),
                      backgroundColor: Colors.grey[100],
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      onPressed: onPressed,
    );
  }
}
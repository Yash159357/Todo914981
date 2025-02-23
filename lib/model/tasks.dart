import 'package:flutter/material.dart';

class Task {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime dueDate;
  bool completed;
  final String description;
  final TaskCategory? category;
  final TaskPriority priority;
  final List<Subtask> subtasks;
  double progress;

  Task({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.dueDate,
    required this.description,
    this.completed = false,
    this.category,
    this.priority = TaskPriority.medium,
    this.subtasks = const [],
    this.progress = 0,
  });
  Task copyWith({
    bool? completed,
    double? progress,
    List<Subtask>? subtasks,
  }) {
    return Task(
      id: id,
      title: title,
      createdAt: createdAt,
      dueDate: dueDate,
      completed: completed ?? this.completed,
      description: description,
      category: category,
      priority: priority,
      subtasks: subtasks ?? this.subtasks,
      progress: progress ?? this.progress,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Task && id == other.id;

  @override
  int get hashCode => id.hashCode;
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'completed': completed,
      'description': description,
      'category': category?.toJson(),
      'priority': priority.toString().split('.').last,
      'subtasks': subtasks.map((s) => s.toJson()).toList(),
      'progress': progress,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
      dueDate: DateTime.parse(json['dueDate']),
      completed: json['completed'],
      description: json['description'],
      category: json['category'] != null
          ? TaskCategory.fromJson(json['category'])
          : null,
      priority: TaskPriority.values.firstWhere(
        (p) => p.toString() == 'TaskPriority.${json['priority']}',
        orElse: () => TaskPriority.medium,
      ),
      subtasks:
          (json['subtasks'] as List).map((s) => Subtask.fromJson(s)).toList(),
      progress: json['progress'],
    );
  }
}

enum TaskPriority {
  low(Colors.green, 'Low'),
  medium(Colors.orange, 'Medium'),
  high(Colors.red, 'High');

  final Color color;
  final String label;
  const TaskPriority(this.color, this.label);
}

class TaskCategory {
  final String name;
  final Color color;
  final IconData icon;

  const TaskCategory({
    required this.name,
    required this.color,
    required this.icon,
  });
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'color': color.value,
      'icon': icon.codePoint,
    };
  }

  factory TaskCategory.fromJson(Map<String, dynamic> json) {
    return TaskCategory(
      name: json['name'],
      color: Color(json['color']),
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
    );
  }
}

class Subtask {
  final String title;
  bool completed;

  Subtask({required this.title, this.completed = false});
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'completed': completed,
    };
  }

  factory Subtask.fromJson(Map<String, dynamic> json) {
    return Subtask(
      title: json['title'],
      completed: json['completed'],
    );
  }
}

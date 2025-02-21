import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:todoapp/model/tasks.dart';
import 'package:todoapp/controller/task_list_cubit.dart';

void showCreateTaskModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return const CreateTaskModal();
    },
  );
}

class CreateTaskModal extends StatefulWidget {
  const CreateTaskModal({super.key});

  @override
  State<CreateTaskModal> createState() => _CreateTaskModalState();
}

class _CreateTaskModalState extends State<CreateTaskModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now().add(const Duration(days: 1));
  TaskPriority _priority = TaskPriority.medium;
  TaskCategory? _selectedCategory;
  final List<Subtask> _subtasks = [];

  void _addSubtask(String title) {
    setState(() {
      _subtasks.add(Subtask(title: title));
    });
  }

  void _removeSubtask(int index) {
    setState(() {
      _subtasks.removeAt(index);
    });
  }

  void _submitTask() {
    if (_formKey.currentState!.validate()) {
      final newTask = Task(
        id: const Uuid().v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        createdAt: DateTime.now(),
        dueDate: _dueDate,
        category: _selectedCategory,
        priority: _priority,
        subtasks: _subtasks,
        progress: 0.0,
      );

      context.read<TaskListCubit>().addTask(newTask);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Create New Task',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Due Date Picker
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Due Date'),
                subtitle: Text(DateFormat('EEE, MMM d, y • hh:mm a').format(_dueDate)),
                onTap: () async {
                  final selectedDate = await showDatePicker(
                    context: context,
                    initialDate: _dueDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _dueDate = selectedDate;
                    });
                  }
                },
              ),
              const SizedBox(height: 16),

              // Priority Selector
              const Text('Priority'),
              Wrap(
                spacing: 8,
                children: TaskPriority.values.map((priority) {
                  return ChoiceChip(
                    label: Text(priority.label),
                    selected: _priority == priority,
                    onSelected: (selected) {
                      setState(() {
                        _priority = priority;
                      });
                    },
                    selectedColor: priority.color.withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: _priority == priority ? priority.color : Colors.grey[700],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Category Selector
              const Text('Category'),
              Wrap(
                spacing: 8,
                children: [
                  _buildCategoryChip('Work', Colors.blue, Icons.work),
                  _buildCategoryChip('Personal', Colors.green, Icons.person),
                  _buildCategoryChip('Travel', Colors.purple, Icons.flight),
                  _buildCategoryChip('Learning', Colors.orange, Icons.school),
                ],
              ),
              const SizedBox(height: 16),

              // Subtasks Section
              const Text('Subtasks'),
              ..._subtasks.map((subtask) {
                return ListTile(
                  title: Text(subtask.title),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeSubtask(_subtasks.indexOf(subtask)),
                  ),
                );
              }).toList(),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Add Subtask',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onFieldSubmitted: (value) {
                  if (value.isNotEmpty) {
                    _addSubtask(value);
                  }
                },
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitTask,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Create Task',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String name, Color color, IconData icon) {
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(name),
        ],
      ),
      selected: _selectedCategory?.name == name,
      onSelected: (selected) {
        setState(() {
          _selectedCategory = TaskCategory(name: name, color: color, icon: icon);
        });
      },
      selectedColor: color.withOpacity(0.2),
      labelStyle: TextStyle(
        color: _selectedCategory?.name == name ? color : Colors.grey[700],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/controller/task_list_cubit.dart';
import 'package:todoapp/model/tasks.dart';
import 'package:todoapp/widgets/task_card.dart';
import 'package:todoapp/view/home/task_view/task_details.dart';
import 'package:go_router/go_router.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  SearchFilter _selectedFilter = SearchFilter.title;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Task> _filterTasks(List<Task> allTasks) {
    if (_searchQuery.isEmpty) return allTasks;

    return allTasks.where((task) {
      final query = _searchQuery.toLowerCase();
      if (_selectedFilter == SearchFilter.title) {
        return task.title.toLowerCase().contains(query);
      } else {
        return task.description.toLowerCase().contains(query);
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskListCubit, List<Task>>(
      builder: (context, tasks) {
        final filteredTasks = _filterTasks(tasks);

        return Column(
          children: [
            // Search Bar and Filter
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search tasks...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onChanged: (value) {
                        setState(
                          () {
                            _searchQuery = value.trim();
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black54),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 6.5,
                    ),
                    child: DropdownButton<SearchFilter>(
                      value: _selectedFilter,
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(
                          value: SearchFilter.title,
                          child: Text('Title'),
                        ),
                        DropdownMenuItem(
                          value: SearchFilter.description,
                          child: Text('Description'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedFilter = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Task List or Loading/Empty State
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: _searchQuery.isNotEmpty && filteredTasks.isEmpty
                    ? const Center(
                        child: Text('No tasks found',
                            style: TextStyle(fontSize: 16)),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: filteredTasks.length,
                        itemBuilder: (context, index) {
                          final task = filteredTasks[index];
                          return GestureDetector(
                            onTap: () {
                              var task = filteredTasks[index];
                              showTaskDetailsModal(
                                context: context,
                                task: task,
                                // ************* behaviour functions******************************
                                onTaskFinished: () {
                                  // Mark task as finished.
                                  setState(() {
                                    final updatedTask = task.copyWith(
                                        completed: !task.completed);
                                    context
                                        .read<TaskListCubit>()
                                        .updateTask(updatedTask);
                                    context.pop();
                                  });
                                },
                                onDeleteTask: () {
                                  // Delete the task.
                                  setState(() {
                                    context
                                        .read<TaskListCubit>()
                                        .deleteTask(task.id);
                                    // TaskStorageService.saveTasks(_allTasks);
                                    context.pop();
                                  });
                                },
                              );
                            },
                            child: TaskCard(
                              task: task,
                              onDismissed: () {
                                context
                                    .read<TaskListCubit>()
                                    .deleteTask(task.id);
                              },
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        );
      },
    );
  }
}

enum SearchFilter { title, description }

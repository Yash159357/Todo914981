import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todoapp/model/tasks.dart';
import 'package:todoapp/services/storage.dart';

class TaskListCubit extends Cubit<List<Task>> {
  TaskListCubit() : super([]) {
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    // Only load from SharedPreferences, never use dummy data
    final tasks = await TaskStorageService.loadTasks();
    emit(tasks);
  }

  // ****************** Unified Save Method **************************
  Future<void> _saveTasks() async {
    await TaskStorageService.saveTasks(state);
  }

  // ****************** Add Task with Auto-Save **********************
  void addTask(Task task) async {
    final updatedTasks = List<Task>.from(state)..add(task);
    emit(updatedTasks);
    await _saveTasks(); // Immediate save after state change
  }

  // ****************** Delete Task with Auto-Save ********************
  void deleteTask(String id) async {
    final updatedTasks = state.where((task) => task.id != id).toList();
    emit(updatedTasks);
    await _saveTasks(); // Immediate save after state change
  }

  // ****************** Update Task with Auto-Save ********************
  void updateTask(Task updatedTask) async {
    final updatedTasks = state.map((task) {
      return task.id == updatedTask.id ? updatedTask : task;
    }).toList();
    
    emit(updatedTasks);
    await _saveTasks(); // Immediate save after state change
  }
}
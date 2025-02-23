import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:todoapp/controller/task_list_cubit.dart';
import 'package:todoapp/model/tasks.dart';
import 'package:todoapp/services/firebase_services.dart';
import 'package:todoapp/view/home/create_task.dart/create_task.dart';
import 'package:todoapp/view/home/profile_screen/profile_screen.dart';
import 'package:todoapp/view/home/tasks_screen/tasks_screen.dart';
import 'package:todoapp/widgets/advert_crousal.dart';
import 'package:todoapp/widgets/greeting_card.dart';
import 'package:todoapp/widgets/task_card.dart';
import 'package:todoapp/widgets/task_segment.dart';
import 'package:todoapp/view/home/task_view/task_details.dart';
import 'package:todoapp/services/storage.dart';

enum BottomTab { home, tasks, profile }

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  // ************* tab and tasks switchers **********************
  BottomTab _currentTab = BottomTab.home;
  TaskFilter _selectedFilter = TaskFilter.today;

  // List<Task> _allTasks = [];

  @override
  void initState() {
    super.initState();
    // ******************* set data in alltasks *********************
    // _allTasks = context.read<TaskListCubit>().state;
    // context.read<TaskListCubit>().stream.listen((tasks) {
    //   setState(() {
    //     _allTasks = tasks;
    //   });
    // });
  }

  @override
  void dispose() {
    // context.read<TaskListCubit>().saveBeforeClose();
    super.dispose();
  }

  // ************* filtering tasks as per task switcher ******************
  List<Task> _filteredTasks(List<Task> state) {
    DateTime now = DateTime.now();
    switch (_selectedFilter) {
      case TaskFilter.completed:
        return state.where((task) => task.completed).toList();
      case TaskFilter.today:
        return state
            .where((task) =>
                task.dueDate.year == now.year &&
                task.dueDate.month == now.month &&
                task.dueDate.day == now.day &&
                !task.completed)
            .toList();
      case TaskFilter.pending:
        return state
            .where((task) =>
                !task.completed &&
                (task.dueDate.isAfter(now) && task.dueDate.day != now.day))
            .toList();
    }
  }

  void _onFilterChanged(TaskFilter filter) {
    setState(() {
      _selectedFilter = filter;
    });
  }

  void _onBottomTabTapped(BottomTab tab) {
    setState(() {
      _currentTab = tab;
    });
  }

  Widget _buildBody(List<Task> state) {
    if (_currentTab == BottomTab.home) {
      return SingleChildScrollView(
        child: Column(
          children: [
            // ************************ greeting card *********************
            const GreetingCard(),
            // ************************ adverts ***************************
            Divider(color: Colors.grey.shade300, endIndent: 10, indent: 10),
            const SizedBox(height: 8),
            const AdvertisementCarousel(),
            // *********************** task segmented controller *********
            const SizedBox(height: 8),
            Divider(color: Colors.grey.shade300, endIndent: 10, indent: 10),
            const SizedBox(height: 4),

            TaskSegmentedControl(
              selectedFilter: _selectedFilter,
              onFilterChanged: _onFilterChanged,
            ),
            // ********************* Display filtered tasks ************
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: _filteredTasks(state).length,
              itemBuilder: (context, index) {
                var task = _filteredTasks(state)[index];

                return GestureDetector(
                  onTap: () {
                    // var task = _filteredTasks(state)[index];
                    showTaskDetailsModal(
                      context: context,
                      task: task,
                      // ************* behaviour functions******************************
                      onTaskFinished: () {
                        // Mark task as finished.
                        setState(() {
                          final updatedTask =
                              task.copyWith(completed: !task.completed);
                          context.read<TaskListCubit>().updateTask(updatedTask);
                          context.pop();
                        });
                      },
                      onDeleteTask: () {
                        // Delete the task.
                        setState(() {
                          context.read<TaskListCubit>().deleteTask(task.id);
                          // TaskStorageService.saveTasks(_allTasks);
                          context.pop();
                        });
                      },
                    );
                  },
                  child: TaskCard(
                    task: _filteredTasks(state)[index],
                    onDismissed: () {
                        // Delete the task.
                        setState(() {
                          context.read<TaskListCubit>().deleteTask(task.id);
                          // TaskStorageService.saveTasks(_allTasks);
                          // context.pop();
                        });
                      },
                  ),
                );
              },
            ),
          ],
        ),
      );
    } else if (_currentTab == BottomTab.tasks) {
      return const TasksScreen();
    } else if (_currentTab == BottomTab.profile) {
      return const ProfileScreen();
    }
    return Container();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ********************** AppBar **************************************
      appBar: AppBar(
        title: const Text.rich(
          TextSpan(
            text: 'Todo',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            children: [
              TextSpan(
                text: 'App',
                style: TextStyle(color: Color(0xFF2575FC)),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Menu'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.settings),
                      title: const Text('Settings'),
                      onTap: () {}, // Dummy
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout),
                      title: const Text('Logout'),
                      onTap: () {
                        AuthService().logout();
                        context.pushReplacementNamed("auth");
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showCreateTaskModal(context);
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentTab.index,
        onTap: (index) => _onBottomTabTapped(BottomTab.values[index]),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Tasks'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: SafeArea(
        child:
            BlocBuilder<TaskListCubit, List<Task>>(builder: (context, state) {
          return _buildBody(state);
        }),
      ),
    );
  }
}

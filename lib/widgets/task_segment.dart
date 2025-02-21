import 'package:flutter/material.dart';

enum TaskFilter { completed, today, pending }

class TaskSegmentedControl extends StatelessWidget {
  final TaskFilter selectedFilter;
  final ValueChanged<TaskFilter> onFilterChanged;

  const TaskSegmentedControl({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // _buildSegment(context, TaskFilter.completed, 'Completed'),
          // _buildSegment(context, TaskFilter.today, 'Today'),
          // _buildSegment(context, TaskFilter.pending, 'Pending'),

          // *************** completed *************************************
          Expanded(
            child: GestureDetector(
              onTap: () => onFilterChanged(TaskFilter.completed),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: (selectedFilter == TaskFilter.completed)
                      ? Colors.blue
                      : Colors.grey[200],
                  border: const Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    top: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    left: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    right: BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  borderRadius:
                      const BorderRadius.horizontal(left: Radius.circular(20)),
                ),
                child: Center(
                  child: Text(
                    "Completed",
                    style: TextStyle(
                      color: (selectedFilter == TaskFilter.completed)
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // *********************** today ***********************************
          Expanded(
            child: GestureDetector(
              onTap: () => onFilterChanged(TaskFilter.today),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: (selectedFilter == TaskFilter.today)
                      ? Colors.blue
                      : Colors.grey[200],
                  border: const Border.symmetric(
                    horizontal: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    vertical: BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                  ),
                  // borderRadius:
                  //     const BorderRadius.horizontal(left: Radius.circular(20)),
                ),
                child: Center(
                  child: Text(
                    "Today",
                    style: TextStyle(
                      color: (selectedFilter == TaskFilter.today)
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // ************************* pending ********************************
          Expanded(
            child: GestureDetector(
              onTap: () => onFilterChanged(TaskFilter.pending),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: (selectedFilter == TaskFilter.pending)
                      ? Colors.blue
                      : Colors.grey[200],
                  border: const Border(
                    bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    top: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    right: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ),
                    left: BorderSide(
                      color: Colors.grey,
                      width: 0.5,
                    ),
                    
                  ),
                  borderRadius:
                      const BorderRadius.horizontal(right: Radius.circular(20)),
                ),
                child: Center(
                  child: Text(
                    "Pending",
                    style: TextStyle(
                      color: (selectedFilter == TaskFilter.pending)
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegment(BuildContext context, TaskFilter filter, String label) {
    bool isSelected = selectedFilter == filter;
    return Expanded(
      child: GestureDetector(
        onTap: () => onFilterChanged(filter),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.grey[200],
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

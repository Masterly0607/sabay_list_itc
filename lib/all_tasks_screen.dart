import 'package:flutter/material.dart';
import 'task_detail_screen.dart';

// Task model
class Task {
  final String id;
  final String title;
  final String time;
  final bool isCompleted;
  final Color borderColor;
  final String description;

  Task({
    required this.id,
    required this.title,
    required this.time,
    required this.isCompleted,
    required this.borderColor,
    this.description = 'No description',
  });

  Task copyWith({
    String? id,
    String? title,
    String? time,
    bool? isCompleted,
    Color? borderColor,
    String? description,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
      borderColor: borderColor ?? this.borderColor,
      description: description ?? this.description,
    );
  }
}

class AllTasksScreen extends StatefulWidget {
  const AllTasksScreen({super.key});

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  final TextEditingController _searchController = TextEditingController();
  
  List<Task> tasks = [
    Task(
      id: '1',
      title: 'complete project proposal',
      time: '8 AM - 10 AM',
      isCompleted: false,
      borderColor: const Color(0xFF9C88FF),
      description: 'Finish the project proposal for the client meeting',
    ),
    Task(
      id: '2',
      title: 'Review team updates',
      time: '8 AM - 10 AM',
      isCompleted: false,
      borderColor: const Color(0xFFFFB366),
      description: 'Review all team member updates and provide feedback',
    ),
    Task(
      id: '3',
      title: 'Gym workout',
      time: '8 AM - 10 AM',
      isCompleted: true,
      borderColor: const Color(0xFF66D9EF),
      description: 'Complete full body workout routine',
    ),
  ];

  List<Task> get filteredTasks {
    if (_searchController.text.isEmpty) {
      return tasks;
    }
    return tasks.where((task) => 
      task.title.toLowerCase().contains(_searchController.text.toLowerCase())
    ).toList();
  }

  void _toggleTaskCompletion(String taskId) {
    setState(() {
      final taskIndex = tasks.indexWhere((task) => task.id == taskId);
      if (taskIndex != -1) {
        tasks[taskIndex] = tasks[taskIndex].copyWith(
          isCompleted: !tasks[taskIndex].isCompleted,
        );
      }
    });
  }

  void _addNewTask() {
    showDialog(
      context: context,
      builder: (context) => _NewTaskDialog(
        onTaskAdded: (task) {
          setState(() {
            tasks.add(task);
          });
        },
      ),
    );
  }

  void _navigateToTaskDetail(Task task) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(
          task: task,
          onTaskUpdated: (updatedTask) {
            setState(() {
              final taskIndex = tasks.indexWhere((t) => t.id == task.id);
              if (taskIndex != -1) {
                tasks[taskIndex] = updatedTask;
              }
            });
          },
          onTaskDeleted: (taskId) {
            setState(() {
              tasks.removeWhere((t) => t.id == taskId);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC1D1),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              const SizedBox(height: 20),
              const Text(
                'All Tasks',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              
              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(() {}),
                        decoration: const InputDecoration(
                          hintText: 'Search Task',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9EA6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // Task List
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: task.borderColor,
                          width: 3,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        onTap: () => _navigateToTaskDetail(task),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            decoration: task.isCompleted 
                              ? TextDecoration.lineThrough 
                              : null,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () => _toggleTaskCompletion(task.id),
                                child: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 2,
                                    ),
                                    color: task.isCompleted 
                                      ? Colors.green 
                                      : Colors.transparent,
                                  ),
                                  child: task.isCompleted
                                    ? const Icon(
                                        Icons.check,
                                        size: 14,
                                        color: Colors.white,
                                      )
                                    : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                task.time,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // New Task Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: _addNewTask,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9EA6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'New Task',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Bottom Navigation
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.home, color: Colors.grey),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9EA6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.list,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.person, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewTaskDialog extends StatefulWidget {
  final Function(Task) onTaskAdded;

  const _NewTaskDialog({required this.onTaskAdded});

  @override
  State<_NewTaskDialog> createState() => _NewTaskDialogState();
}

class _NewTaskDialogState extends State<_NewTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<Color> _borderColors = [
    const Color(0xFF9C88FF),
    const Color(0xFFFFB366),
    const Color(0xFF66D9EF),
    const Color(0xFFFF6B9D),
  ];
  Color _selectedColor = const Color(0xFF9C88FF);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Task'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Task Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          const Text('Choose Color:'),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _borderColors.map((color) {
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = color),
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: _selectedColor == color
                      ? Border.all(color: Colors.black, width: 2)
                      : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              final newTask = Task(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: _titleController.text,
                time: '8 AM - 10 AM',
                isCompleted: false,
                borderColor: _selectedColor,
                description: _descriptionController.text.isEmpty 
                  ? 'No description' 
                  : _descriptionController.text,
              );
              widget.onTaskAdded(newTask);
              Navigator.pop(context);
            }
          },
          child: const Text('Add Task'),
        ),
      ],
    );
  }
}
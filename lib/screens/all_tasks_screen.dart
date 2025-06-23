import 'package:flutter/material.dart';
import 'package:sabay_list_itc/screens/task_detail_screen.dart';
import 'package:sabay_list_itc/services/task_service.dart';
import 'package:intl/intl.dart';

class AllTasksScreen extends StatefulWidget {
  const AllTasksScreen({super.key});

  @override
  State<AllTasksScreen> createState() => _AllTasksScreenState();
}

class _AllTasksScreenState extends State<AllTasksScreen> {
  final TextEditingController _searchController = TextEditingController();
  late TaskService _taskService;

  @override
  void initState() {
    super.initState();
    _taskService = TaskService();
    _taskService.addListener(_onTasksChanged);
  }

  @override
  void dispose() {
    _taskService.removeListener(_onTasksChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onTasksChanged() {
    setState(() {});
  }

  List<Task> get filteredTasks {
    return _taskService.searchTasks(_searchController.text);
  }

  void _addNewTask() {
    showDialog(
      context: context,
      builder: (context) => _NewTaskDialog(
        onTaskAdded: (task) {
          _taskService.addTask(task);
        },
      ),
    );
  }

  void _navigateToTaskDetail(Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDetailScreen(
          task: task,
          onTaskUpdated: (updatedTask) {
            _taskService.updateTask(updatedTask as Task);
          },
          onTaskDeleted: (taskId) {
            _taskService.deleteTask(taskId);
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
        child: Column(
          children: [
            // Header and search section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'All Tasks',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  const SizedBox(height: 20),
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
                              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                          icon: const Icon(Icons.search, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            // Tasks list
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView.builder(
                  itemCount: filteredTasks.length,
                  itemBuilder: (context, index) {
                    final task = filteredTasks[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: task.borderColor, width: 3),
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
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () => _taskService.toggleTaskCompletion(task.id),
                                    child: Container(
                                      width: 20,
                                      height: 20,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.grey, width: 2),
                                        color: task.isCompleted ? Colors.green : Colors.transparent,
                                      ),
                                      child: task.isCompleted
                                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                                          : null,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    task.time,
                                    style: const TextStyle(color: Colors.grey, fontSize: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Due: ${DateFormat('MMM dd, yyyy').format(task.deadline)}',
                                style: TextStyle(
                                  color: task.deadline.isBefore(DateTime.now()) && !task.isCompleted
                                      ? Colors.red
                                      : Colors.grey,
                                  fontSize: 12,
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
            ),
            // New Task button with minimal spacing
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                onPressed: _addNewTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9EA6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  'New Task',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            // Minimal space for bottom navigation
            const SizedBox(height: 20),
          ],
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
  DateTime _selectedDeadline = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Task'),
      content: SingleChildScrollView(
        child: Column(
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
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Deadline'),
                    subtitle: Text(DateFormat('MMM dd, yyyy').format(_selectedDeadline)),
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDeadline,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                      );
                      if (date != null) {
                        setState(() {
                          _selectedDeadline = date;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Time'),
                    subtitle: Text(_selectedTime.format(context)),
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: _selectedTime,
                      );
                      if (time != null) {
                        setState(() {
                          _selectedTime = time;
                        });
                      }
                    },
                  ),
                ),
              ],
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
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty) {
              final deadline = DateTime(
                _selectedDeadline.year,
                _selectedDeadline.month,
                _selectedDeadline.day,
                _selectedTime.hour,
                _selectedTime.minute,
              );
              
              final newTask = Task(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: _titleController.text,
                time: _selectedTime.format(context),
                deadline: deadline,
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
// Importing required packages
import 'package:flutter/material.dart'; // Flutter UI widgets
import 'package:sabay_list_itc/services/task_service.dart'; // Task model/service (custom)
import 'package:intl/intl.dart'; // For formatting dates

// Stateful widget for creating/editing a task
class TaskFormScreen extends StatefulWidget {
  final Task? task; // Optional: the task to edit, if any
  final Function(Task) onTaskSaved; // Callback to notify parent when task is saved

  const TaskFormScreen({super.key, this.task, required this.onTaskSaved});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

// The State of TaskFormScreen holds form data and handles user interactions
class _TaskFormScreenState extends State<TaskFormScreen> {
  // Controllers for text inputs
  final _descriptionController = TextEditingController();
  final _taskNameController = TextEditingController();

  // Selected date and time defaults
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  // Default selected border color
  Color _selectedColor = const Color(0xFF9C88FF);

  // List of available colors user can pick
  final List<Color> _borderColors = [
    const Color(0xFF9C88FF),
    const Color(0xFFFFB366),
    const Color(0xFF66D9EF),
    const Color(0xFFFF6B9D),
  ];

  @override
  void initState() {
    super.initState();
    // If editing an existing task, populate fields with its data
    if (widget.task != null) {
      _taskNameController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedDate = widget.task!.deadline;
      _selectedTime = TimeOfDay.fromDateTime(widget.task!.deadline);
      _selectedColor = widget.task!.borderColor;
    }
  }

  @override
  void dispose() {
    // Dispose controllers when widget is destroyed
    _descriptionController.dispose();
    _taskNameController.dispose();
    super.dispose();
  }

  // Show date picker dialog
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        // Custom theme for the date picker
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF9EA6), // Pink primary color
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    // Update selected date if user picked one
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Show time picker dialog
  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF9EA6),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    // Update selected time if user picked one
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Save the task and notify parent widget
  void _saveTask() {
    // Validate: Task name cannot be empty
    if (_taskNameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a task name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Combine date and time into a single DateTime object
    final deadline = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    // Create a new Task object
    final task = Task(
      id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(), // Use existing ID or generate new
      title: _taskNameController.text.trim(),
      time: _selectedTime.format(context),
      deadline: deadline,
      isCompleted: widget.task?.isCompleted ?? false,
      borderColor: _selectedColor,
      description: _descriptionController.text.trim().isEmpty
          ? 'No description'
          : _descriptionController.text.trim(),
    );

    // Notify parent via callback
    widget.onTaskSaved(task);
    // Close the form screen
    Navigator.pop(context, task);
  }

  // Helper to format date nicely
  String _formatDate(DateTime date) {
    return DateFormat('EEEE dd MMM').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFC1D1), // Pink background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top header with back button and title
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                  ),
                  const Expanded(
                    child: Text(
                      'Task Form',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Spacer to align title
                ],
              ),
              const SizedBox(height: 30),

              // Main form card
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // List Schedule header with icon
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF9EA6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'List schedule',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Decorative image
                        Container(
                          width: double.infinity,
                          height: 120,
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('assets/task_form.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Static title text
                        const Text(
                          'Title',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Date picker input
                        InkWell(
                          onTap: _selectDate,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFC1D1).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/calendar.png',
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _formatDate(_selectedDate),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Time picker input
                        InkWell(
                          onTap: _selectTime,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  'assets/clock.png',
                                  width: 20,
                                  height: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _selectedTime.format(context),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const Spacer(),
                                const Icon(Icons.keyboard_arrow_right, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Task name input
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF9EA6),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.work, color: Colors.white, size: 16),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: _taskNameController,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter task name (e.g., Work, Workout)',
                                    border: InputBorder.none,
                                    hintStyle: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Color selection circles
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _borderColors.map((color) {
                            return GestureDetector(
                              onTap: () => setState(() => _selectedColor = color),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: color,
                                  shape: BoxShape.circle,
                                  border: _selectedColor == color
                                      ? Border.all(color: Colors.black, width: 3)
                                      : null,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),

                        // Description input
                        TextField(
                          controller: _descriptionController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Enter description (optional)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFFF9EA6)),
                            ),
                            contentPadding: const EdgeInsets.all(16),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Save button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _saveTask,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF9EA6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 2,
                            ),
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

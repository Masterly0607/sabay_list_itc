import 'package:flutter/material.dart';
import 'package:sabay_list_itc/services/task_service.dart';
import 'package:sabay_list_itc/screens/task_detail_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
const HomeScreen({super.key});

@override
State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
@override
Widget build(BuildContext context) {
  return const HomeScreenContent();
}
}

class HomeScreenContent extends StatefulWidget {
const HomeScreenContent({super.key});

@override
State<HomeScreenContent> createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent> {
late TaskService _taskService;
int selectedDateIndex = 0;
bool isTaskDropdownExpanded = false;
bool isCompletionDropdownExpanded = false; // Add this for completion dropdown

@override
void initState() {
  super.initState();
  _taskService = TaskService();
  _taskService.addListener(_onTasksChanged);
  final taskDates = _taskService.taskDates;
  final today = DateTime.now();
  final todayIndex = taskDates.indexWhere((date) => 
    date.year == today.year && 
    date.month == today.month && 
    date.day == today.day
  );
  if (todayIndex != -1) {
    selectedDateIndex = todayIndex;
  }
}

@override
void dispose() {
  _taskService.removeListener(_onTasksChanged);
  super.dispose();
}

void _onTasksChanged() {
  setState(() {});
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
  final taskDates = _taskService.taskDates;
  
  return Scaffold(
    backgroundColor: const Color(0xFFFFC1D1),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            if (taskDates.isNotEmpty) _buildDateSelector(taskDates),
            const SizedBox(height: 24),
            _buildDailyLifeRecommendation(),
            const SizedBox(height: 24),
            _buildDashboard(),
            const SizedBox(height: 24),
            _buildTaskCompletion(),
            const SizedBox(height: 100),
          ],
        ),
      ),
    ),
  );
}

Widget _buildHeader() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const Row(
        children: [
          Text(
            '👋 ',
            style: TextStyle(fontSize: 24),
          ),
          Text(
            'Hello Jennie',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
      Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: ClipOval(
          child: Image.asset(
            'path/of/profile_image.png',
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: const Icon(Icons.person, color: Colors.grey),
              );
            },
          ),
        ),
      ),
    ],
  );
}

Widget _buildDateSelector(List<DateTime> taskDates) {
  return SizedBox(
    height: 80,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: taskDates.length,
      itemBuilder: (context, index) {
        final date = taskDates[index];
        final isSelected = index == selectedDateIndex;
        
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedDateIndex = index;
            });
          },
          child: Container(
            width: 60,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              color: isSelected 
                  ? const Color(0xFFFF9EA6)
                  : Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(20),
              boxShadow: isSelected ? [
                BoxShadow(
                  color: const Color(0xFFFF9EA6).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ] : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('dd').format(date),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  DateFormat('EEE').format(date),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  );
}

Widget _buildDailyLifeRecommendation() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'Daily Life Recoment',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          _buildRecommendationAvatar('path/of/avatar1.png', Colors.orange),
          const SizedBox(width: 12),
          _buildRecommendationAvatar('path/of/avatar2.png', Colors.blue),
          const SizedBox(width: 12),
          _buildRecommendationAvatar('path/of/avatar3.png', Colors.green),
          const SizedBox(width: 12),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 20,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildRecommendationAvatar(String imagePath, Color fallbackColor) {
  return Container(
    width: 50,
    height: 50,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white, width: 2),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: ClipOval(
      child: Image.asset(
        imagePath,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: fallbackColor.withOpacity(0.7),
            child: const Icon(Icons.person, color: Colors.white),
          );
        },
      ),
    ),
  );
}

Widget _buildDashboard() {
  return Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 15,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9EA6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.dashboard,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Welcome back! Here\'s an overview of your tasks',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: _buildDashboardCard(
                'Total Task',
                _taskService.totalTasks.toString(),
                '${_taskService.completedTasks} completed, ${_taskService.pendingTasks} pending',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDashboardCard(
                'Due Today',
                _taskService.dueTodayTasks.length.toString(),
                'Task priority',
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _buildDashboardCard(String title, String count, String subtitle) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey[50],
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          count,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  );
}

Widget _buildTaskCompletion() {
  final completedTasks = _taskService.completedTasksList;
  final allTasks = _taskService.allTasks;
  
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Tasks dropdown
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isTaskDropdownExpanded = !isTaskDropdownExpanded;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Tasks (${allTasks.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      AnimatedRotation(
                        turns: isTaskDropdownExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isTaskDropdownExpanded)
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: allTasks.length,
                    itemBuilder: (context, index) {
                      final task = allTasks[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: task.borderColor.withOpacity(0.3)),
                        ),
                        child: ListTile(
                          dense: true,
                          onTap: () => _navigateToTaskDetail(task),
                          leading: GestureDetector(
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
                                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                                  : null,
                            ),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            task.time,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          trailing: Container(
                            width: 4,
                            height: 30,
                            decoration: BoxDecoration(
                              color: task.borderColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
      const SizedBox(width: 16),
      // Completion dropdown (same size as tasks)
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isCompletionDropdownExpanded = !isCompletionDropdownExpanded;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Completion (${completedTasks.length})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      AnimatedRotation(
                        turns: isCompletionDropdownExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: const Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (isCompletionDropdownExpanded)
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    ),
                  ),
                  child: completedTasks.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text(
                            'No completed tasks yet',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: completedTasks.length,
                          itemBuilder: (context, index) {
                            final task = completedTasks[index];
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.green.withOpacity(0.3)),
                              ),
                              child: ListTile(
                                dense: true,
                                onTap: () => _navigateToTaskDetail(task),
                                leading: Container(
                                  width: 20,
                                  height: 20,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                    border: Border.all(color: Colors.green, width: 2),
                                  ),
                                  child: const Icon(Icons.check, size: 12, color: Colors.white),
                                ),
                                title: Text(
                                  task.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  task.time,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                trailing: Container(
                                  width: 4,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
            ],
          ),
        ),
      ),
    ],
  );
}
}
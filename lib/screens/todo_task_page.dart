import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TodoTaskPage extends StatelessWidget {
  final List<Task> tasks = [
    Task(
      id: '1',
      title: 'Gym workout',
      time: '8 AM - 10 AM',
      isCompleted: false,
      borderColor: Color(0xFFFFB366),
    ),
    Task(
      id: '2',
      title: 'Complete project proposal',
      time: '10 AM - 12 PM',
      isCompleted: false,
      borderColor: Color(0xFFFF6B9D),
    ),
    Task(
      id: '3',
      title: 'Clean and wash',
      time: '2 PM - 4 PM',
      isCompleted: true,
      borderColor: Color(0xFF66D9EF),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFC1D1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Alert your complete',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image placeholder
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Image.asset(
                'assets/workout_image.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Center(
                  child: Icon(Icons.image, size: 50, color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Due Working Today Section
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Color(0xFFFF9EA6),
                            width: 2,
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Due Working Today',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Display only non-completed tasks
                  ...tasks
                      .where((task) => !task.isCompleted)
                      .map((task) => _buildTaskCard(task, context))
                      .toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle task tap if needed
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color(0xFFFFE6EA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: task.borderColor, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  task.time,
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                // Handle task completion toggle
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Task {
  final String id;
  final String title;
  final String time;
  final bool isCompleted;
  final Color borderColor;

  Task({
    required this.id,
    required this.title,
    required this.time,
    required this.isCompleted,
    required this.borderColor,
  });
}

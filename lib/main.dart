import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Today Tasks',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.pinkAccent),
      ),
      home: const TodayTasksPage(),
    );
  }
}

class TodayTasksPage extends StatelessWidget {
  const TodayTasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.pinkAccent, Colors.pink],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.arrow_back_ios, color: Colors.white),
                        SizedBox(width: 8),
                        Text(
                          "Alert your complete",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        'assets/fitness.png',
                        height: 180,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "🕹️ Due Working Today",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TaskCard(
                      title: "Gym workout",
                      time: "8 AM - 10 AM",
                      icon: Icons.access_time,
                      iconColor: Colors.orange,
                      isDone: true,
                      shadowColor: Colors.orange.shade100,
                    ),
                    TaskCard(
                      title: "complete project proposal",
                      time: "8 AM - 10 AM",
                      icon: Icons.timelapse,
                      iconColor: Colors.purple,
                      isDone: false,
                      shadowColor: Colors.purple.shade100,
                    ),
                    TaskCard(
                      title: "Clean and wash",
                      time: "8 AM - 10 AM",
                      icon: Icons.water_drop,
                      iconColor: Colors.cyan,
                      isDone: false,
                      shadowColor: Colors.cyan.shade100,
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

class TaskCard extends StatelessWidget {
  final String title;
  final String time;
  final IconData icon;
  final Color iconColor;
  final bool isDone;
  final Color shadowColor;

  const TaskCard({
    super.key,
    required this.title,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.isDone,
    required this.shadowColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                isDone ? Icons.check_circle : Icons.cancel,
                color: isDone ? Colors.green : Colors.red,
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(icon, size: 16, color: iconColor),
              const SizedBox(width: 8),
              Text(
                time,
                style: const TextStyle(color: Colors.black54),
              )
            ],
          )
        ],
      ),
    );
  }
}

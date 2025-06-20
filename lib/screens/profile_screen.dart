import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import '../widgets/friend_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE0EB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text("Profile Information", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(value: 0.3, strokeWidth: 4, color: Colors.orange),
                      ),
                      const Text("30%", style: TextStyle(fontSize: 10)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(radius: 40, backgroundImage: AssetImage("assets/jennie.png")),
                    const SizedBox(height: 10),
                    const Text("👋 Hello Jennie", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                      },
                      icon: const Icon(Icons.edit, color: Colors.pink),
                      label: const Text("Edit Profile", style: TextStyle(color: Colors.pink)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const Text("Share with friend", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    FriendCard(name: "Amey", asset: "assets/amey.png", buttonColor: Colors.red),
                    FriendCard(name: "Jamson", asset: "assets/jamson.png", buttonColor: Colors.orange),
                    FriendCard(name: "Rose", asset: "assets/rose.png", buttonColor: Colors.teal),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.menu), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
    );
  }
}
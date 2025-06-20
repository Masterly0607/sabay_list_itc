import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFE0EB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text("Edit Profile", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Stack(
                alignment: Alignment.center,
                children: [
                  const CircleAvatar(radius: 50, backgroundImage: AssetImage("assets/jennie.png")),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: Colors.black54,
                      child: const Text("Upload new photo", style: TextStyle(color: Colors.white, fontSize: 10)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const CustomInput(label: "Name"),
              const CustomInput(label: "Email"),
              const CustomInput(label: "Favorite"),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text("Back"), style: ElevatedButton.styleFrom(backgroundColor: Colors.blue)),
                  ElevatedButton(onPressed: () {}, child: const Text("Save"), style: ElevatedButton.styleFrom(backgroundColor: Colors.red)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CustomInput extends StatelessWidget {
  final String label;
  const CustomInput({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 5),
          TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
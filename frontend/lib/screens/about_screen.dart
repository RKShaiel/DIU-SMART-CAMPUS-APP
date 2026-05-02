import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(title: const Text("About App"), backgroundColor: const Color(0xFF1F6F5F)),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(Icons.business_center, size: 80, color: Color(0xFF6FCF97)),
            SizedBox(height: 20),
            Text("DIU Smart Campus", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            Text("Version 1.0.4", style: TextStyle(color: Colors.white70)),
            Divider(color: Colors.white24, height: 40),
            Text(
              "This app is designed to provide students and faculty of Daffodil International University "
              "with real-time updates on class routines, exam seat plans, and bus schedules.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
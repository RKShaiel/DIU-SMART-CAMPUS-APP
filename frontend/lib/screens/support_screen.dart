import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1B2A),
      appBar: AppBar(title: const Text("Help & Support"), backgroundColor: const Color(0xFF1F6F5F)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _supportTile(Icons.email, "Email Us", "support@diu.edu.bd"),
          _supportTile(Icons.web, "Official Website", "www.daffodilvarsity.edu.bd"),
          _supportTile(Icons.phone, "Help Desk", "+880 123456789"),
          const Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text("Frequently Asked Questions", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const ExpansionTile(
            title: Text("How to find my seat plan?", style: TextStyle(color: Color(0xFF6FCF97))),
            children: [Padding(padding: EdgeInsets.all(8.0), child: Text("Go to 'Exam Info' and select your batch.", style: TextStyle(color: Colors.white70)))],
          ),
        ],
      ),
    );
  }

  Widget _supportTile(IconData icon, String title, String subtitle) {
    return Card(
      color: const Color(0xFF1B263B),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF2FA084)),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        subtitle: Text(subtitle, style: const TextStyle(color: Colors.white70)),
      ),
    );
  }
}
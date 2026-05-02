import 'package:flutter/material.dart';
import 'routine_screen.dart';
import 'notices_screen.dart';
import 'bus_screen.dart';
import 'exam_screen.dart';
import 'settings_screen.dart';
import 'login_screen.dart';
import 'about_screen.dart'; // New Screen
import 'support_screen.dart'; // New Screen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Colors from your provided palette
  static const Color primaryGreen = Color(0xFF1F6F5F);
  static const Color accentGreen = Color(0xFF2FA084);
  static const Color lightGrey = Color(0xFFEEEEEE);
  static const Color backgroundDark = Color(0xFF0D1B2A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundDark,

      // 🔥 Drawer with Visible Colors
      drawer: Drawer(
        backgroundColor: backgroundDark,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: primaryGreen),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.school, size: 50, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "DIU Smart Campus",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            _drawerItem(context, Icons.home, "Home", const HomeScreen()),
            _drawerItem(context, Icons.person, "Profile", const LoginScreen()),
            _drawerItem(context, Icons.settings, "Settings", const SettingsScreen()),
            _drawerItem(context, Icons.info, "About", const AboutScreen()),
            _drawerItem(context, Icons.support_agent, "Support", const SupportScreen()),
          ],
        ),
      ),

      // 🔥 AppBar - Made Visible with Primary Green
      appBar: AppBar(
        backgroundColor: primaryGreen,
        elevation: 4,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "DIU Smart Campus",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount =
              constraints.maxWidth >= 1200
                  ? 4
                  : (constraints.maxWidth >= 800 ? 3 : 2);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.count(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
              children: [
                _card(
                  context,
                  'Routine',
                  Icons.calendar_today,
                  Colors.purple,
                  const RoutineScreen(),
                ),
                _card(
                  context,
                  'Notices',
                  Icons.notifications,
                  Colors.orange,
                  const NoticesScreen(),
                ),
                _card(
                  context,
                  'Bus Schedule',
                  Icons.directions_bus,
                  Colors.green,
                  const BusScreen(),
                ),
                _card(
                  context,
                  'Exam Info',
                  Icons.assignment,
                  Colors.teal,
                  const ExamScreen(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context,
    IconData icon,
    String title,
    Widget page,
  ) {
    return ListTile(
      leading: Icon(icon, color: accentGreen),
      title: Text(
        title,
        style: const TextStyle(color: lightGrey),
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
    );
  }

  Widget _card(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Widget page,
  ) {
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => page),
      ),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.95),
              color.withValues(alpha: 0.75),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.08),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 34, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
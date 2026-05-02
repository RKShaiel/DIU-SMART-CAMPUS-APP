import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController deptController = TextEditingController();
  final TextEditingController sectionController = TextEditingController();

  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      final profileProvider =
          Provider.of<ProfileProvider>(context, listen: false);

      nameController.text = profileProvider.name;
      idController.text = profileProvider.studentId;
      deptController.text = profileProvider.department;
      sectionController.text = profileProvider.section;

      _initialized = true;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    idController.dispose();
    deptController.dispose();
    sectionController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    await profileProvider.saveProfile(
      name: nameController.text.trim(),
      studentId: idController.text.trim(),
      department: deptController.text.trim(),
      section: sectionController.text.trim(),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile saved successfully')),
    );
  }

  InputDecoration inputStyle(
    BuildContext context,
    String hint,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(
        icon,
        color: isDark ? Colors.white70 : Colors.black54,
      ),
      hintStyle: TextStyle(
        color: isDark ? Colors.white38 : Colors.black45,
      ),
      filled: true,
      fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.black12,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDark ? Colors.white.withOpacity(0.08) : Colors.black12,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFF6366F1)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final backgroundColor = isDark ? const Color(0xFF0F172A) : Colors.white;
    final primaryTextColor = isDark ? Colors.white : Colors.black;
    final secondaryTextColor = isDark ? Colors.white70 : Colors.black54;
    final cardColor =
        isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'Student Profile',
          style: TextStyle(color: primaryTextColor),
        ),
        iconTheme: IconThemeData(color: primaryTextColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              style: TextStyle(color: primaryTextColor),
              decoration: inputStyle(
                context,
                'Enter your name',
                Icons.person,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: idController,
              style: TextStyle(color: primaryTextColor),
              decoration: inputStyle(
                context,
                'Enter student ID',
                Icons.badge,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: deptController,
              style: TextStyle(color: primaryTextColor),
              decoration: inputStyle(
                context,
                'Enter department',
                Icons.school,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: sectionController,
              style: TextStyle(color: primaryTextColor),
              decoration: inputStyle(
                context,
                'Enter section',
                Icons.groups,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: saveProfile,
                icon: const Icon(Icons.save),
                label: const Text('Save Profile'),
              ),
            ),
            const SizedBox(height: 24),
            if (profileProvider.name.isNotEmpty)
              Card(
                color: cardColor,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 32,
                        child: Icon(Icons.person, size: 32),
                      ),
                      const SizedBox(height: 16),
                      _infoTile(
                        'Name',
                        profileProvider.name,
                        primaryTextColor,
                        secondaryTextColor,
                      ),
                      _infoTile(
                        'Student ID',
                        profileProvider.studentId,
                        primaryTextColor,
                        secondaryTextColor,
                      ),
                      _infoTile(
                        'Department',
                        profileProvider.department,
                        primaryTextColor,
                        secondaryTextColor,
                      ),
                      _infoTile(
                        'Section',
                        profileProvider.section,
                        primaryTextColor,
                        secondaryTextColor,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(
    String title,
    String value,
    Color titleColor,
    Color valueColor,
  ) {
    return ListTile(
      leading: Icon(Icons.arrow_right, color: valueColor),
      title: Text(
        title,
        style: TextStyle(color: valueColor),
      ),
      subtitle: Text(
        value,
        style: TextStyle(
          color: titleColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

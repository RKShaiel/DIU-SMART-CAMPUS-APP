import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final bool isDark = themeProvider.darkMode;
    final bool highContrast = themeProvider.highContrast;
    final double textScale = themeProvider.textScale;
    final double previewFontSize = 16 * textScale;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        title: Text(
          'Settings & Accessibility',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color:
                isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SwitchListTile(
              title: Text(
                'Dark Mode',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              subtitle: Text(
                'Enable dark theme for comfortable viewing',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              value: themeProvider.darkMode,
              onChanged: (value) {
                themeProvider.setDarkMode(value);
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color:
                isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: SwitchListTile(
              title: Text(
                'High Contrast',
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              subtitle: Text(
                'Improve readability with stronger contrast',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
              value: themeProvider.highContrast,
              onChanged: (value) {
                themeProvider.setHighContrast(value);
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            color:
                isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Text Size',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Adjust font size for better accessibility',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 14 * textScale,
                    ),
                  ),
                  Slider(
                    value: themeProvider.textScale * 16,
                    min: 12,
                    max: 24,
                    divisions: 6,
                    label: (themeProvider.textScale * 16).toStringAsFixed(0),
                    onChanged: (value) {
                      themeProvider.setTextScale(value / 16);
                    },
                  ),
                  Text(
                    'Preview Text Size',
                    style: TextStyle(
                      color: highContrast
                          ? (isDark ? Colors.yellow : Colors.blueGrey.shade900)
                          : (isDark ? Colors.white : Colors.black),
                      fontSize: previewFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            color:
                isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Accessibility Summary',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '• Dark mode for comfortable viewing\n'
                    '• High contrast mode for readability\n'
                    '• Adjustable text size for accessibility',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.black54,
                      fontSize: 15 * textScale,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

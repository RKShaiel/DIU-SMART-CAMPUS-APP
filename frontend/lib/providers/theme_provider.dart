import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeProvider extends ChangeNotifier {
  bool _darkMode = true;
  bool _highContrast = false;
  double _textScale = 1.0;

  bool get darkMode => _darkMode;
  bool get highContrast => _highContrast;
  double get textScale => _textScale;

  void loadFromHive() {
    final box = Hive.box('settingsBox');
    _darkMode = box.get('darkMode', defaultValue: true);
    _highContrast = box.get('highContrast', defaultValue: false);
    _textScale = box.get('textScale', defaultValue: 1.0);
    notifyListeners();
  }

  Future<void> setDarkMode(bool value) async {
    _darkMode = value;
    final box = Hive.box('settingsBox');
    await box.put('darkMode', value);
    notifyListeners();
  }

  Future<void> setHighContrast(bool value) async {
    _highContrast = value;
    final box = Hive.box('settingsBox');
    await box.put('highContrast', value);
    notifyListeners();
  }

  Future<void> setTextScale(double value) async {
    _textScale = value;
    final box = Hive.box('settingsBox');
    await box.put('textScale', value);
    notifyListeners();
  }
}

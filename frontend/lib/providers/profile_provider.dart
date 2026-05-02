import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ProfileProvider extends ChangeNotifier {
  String _name = '';
  String _studentId = '';
  String _department = '';
  String _section = '';

  String get name => _name;
  String get studentId => _studentId;
  String get department => _department;
  String get section => _section;

  void loadFromHive() {
    final box = Hive.box('profileBox');
    _name = box.get('name', defaultValue: '');
    _studentId = box.get('studentId', defaultValue: '');
    _department = box.get('department', defaultValue: '');
    _section = box.get('section', defaultValue: '');
    notifyListeners();
  }

  Future<void> saveProfile({
    required String name,
    required String studentId,
    required String department,
    required String section,
  }) async {
    _name = name;
    _studentId = studentId;
    _department = department;
    _section = section;

    final box = Hive.box('profileBox');
    await box.put('name', name);
    await box.put('studentId', studentId);
    await box.put('department', department);
    await box.put('section', section);

    notifyListeners();
  }
}

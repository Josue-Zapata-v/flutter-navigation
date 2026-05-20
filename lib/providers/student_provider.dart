import 'package:flutter/foundation.dart';
import '../models/student.dart';

class StudentProvider extends ChangeNotifier {
  final List<Student> _students = [
    Student(
      id: '1',
      firstName: 'María',
      lastName: 'García López',
      birthDate: DateTime(2005, 3, 15),
    ),
    Student(
      id: '2',
      firstName: 'Carlos',
      lastName: 'Mendoza Ríos',
      birthDate: DateTime(2004, 7, 22),
    ),
  ];

  List<Student> get students => List.unmodifiable(_students);

  int get studentCount => _students.length;

  void addStudent({
    required String firstName,
    required String lastName,
    required DateTime birthDate,
  }) {
    final newStudent = Student(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      firstName: firstName,
      lastName: lastName,
      birthDate: birthDate,
    );
    _students.add(newStudent);
    notifyListeners();
  }

  void removeStudent(String id) {
    _students.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}
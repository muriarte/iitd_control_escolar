import 'dart:async';
//import '../services/api_services/school_api_provider.dart';
import '../domain/students/student.dart';
import '../domain/students/student_repository.dart';

class StudentsFromMemoryRepository extends StudentRepository {
  final students = [
    Student(1, "Juan", "Perez", 24),
    Student(2, "Elena", "Lara", 22),
    Student(3, "Raul", "Lopez", 42)
  ];

  Future<List<Student>> getAll() async {
    return students;
  }

  Future<Student> save(Student student) async {
    for (final st in students) {
      if (st.id == student.id) {
        st.firstName = student.firstName;
        st.lastName = student.lastName;
        st.age = student.age;
        return st;
      }
    }
    if (student.id > 0) {
      var st = Student.byObject(student);
      students.add(st);
      return st;
    }
    var maxId = _getMaxId();
    var st = Student(maxId, student.firstName, student.lastName, student.age);
    students.add(st);
    return st;
  }

  int _getMaxId() {
    var maxId = 0;
    for (final st in students) {
      if (st.id > maxId) {
        maxId = st.id;
      }
    }
    return maxId;
  }

  Future<bool> delete(int id) async {
    return true;
  }
}

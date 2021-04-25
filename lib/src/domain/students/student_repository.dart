import 'package:iitd_control_escolar/src/domain/students/student.dart';

abstract class StudentRepository {
  Future<List<Student>> getAll();
  Future<Student> save(Student student);
  Future<bool> delete(int id);
}
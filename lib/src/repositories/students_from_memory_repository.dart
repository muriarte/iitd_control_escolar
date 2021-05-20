import 'dart:async';
//import '../services/api_services/school_api_provider.dart';
import '../domain/students/student.dart';
import '../domain/students/student_repository.dart';

class StudentsFromMemoryRepository extends StudentRepository {
  final students = [
    Student(1, "Juan", "Perez", DateTime(2010, 3, 15), "", "", "", "", "", "",
        "", "", "", "", "", "", DateTime(2020, 12, 18), "", ""),
    Student(2, "Elena", "Lara", DateTime(2010, 3, 16), "", "", "", "", "", "",
        "", "", "", "", "", "", DateTime(2020, 12, 19), "", ""),
    Student(3, "Raul", "Lopez", DateTime(2010, 3, 17), "", "", "", "", "", "",
        "", "", "", "", "", "", DateTime(2020, 12, 20), "", "")
  ];

  Future<List<Student>> getAll() async {
    return students;
  }

  Future<Student> save(Student student) async {
    for (final st in students) {
      if (st.id == student.id) {
        st.nombres = student.nombres;
        st.apellidos = student.apellidos;
        st.nacimiento = student.nacimiento;
        st.sexo = student.sexo;
        st.calle = student.calle;
        st.numeroExt = student.numeroExt;
        st.numeroInt = student.numeroInt;
        st.colonia = student.colonia;
        st.municipio = student.municipio;
        st.estado = student.estado;
        st.pais = student.pais;
        st.cp = student.cp;
        st.telCelular = student.telCelular;
        st.telCasa = student.telCasa;
        st.email = student.email;
        st.fechaInicio = student.fechaInicio;
        st.observaciones = student.observaciones;
        st.activo = student.activo;
        return st;
      }
    }
    if (student.id > 0) {
      var st = Student.byObject(student);
      students.add(st);
      return st;
    }
    var maxId = _getMaxId();
    var st = Student(
      maxId,
      student.nombres,
      student.apellidos,
      student.nacimiento,
      student.sexo,
      student.calle,
      student.numeroExt,
      student.numeroInt,
      student.colonia,
      student.municipio,
      student.estado,
      student.pais,
      student.cp,
      student.telCelular,
      student.telCasa,
      student.email,
      student.fechaInicio,
      student.observaciones,
      student.activo,
    );
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

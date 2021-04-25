import 'package:equatable/equatable.dart';
import 'package:iitd_control_escolar/src/domain/students/student.dart';

abstract class StudentListingState extends Equatable {
  StudentListingState();

  factory StudentListingState.initial() => StudentListingInitialState();

  factory StudentListingState.loading() => StudentListingLoadingState();

  factory StudentListingState.loaded(
          List<Student> students, Student? selectedStudent) =>
      StudentListingLoadedState(students, selectedStudent);

  factory StudentListingState.error(String msg) =>
      StudentListingErrorState(msg);
}

class StudentListingInitialState extends StudentListingState {
  @override
  List<Object> get props => [];
}

class StudentListingLoadingState extends StudentListingState {
  @override
  List<Object> get props => [];
}

class StudentListingLoadedState extends StudentListingState {
  final List<Student> students;
  final Student? selectedStudent;

  /// Para forzar la detección de un cambio de state en el BLoC
  ///  ya que el operador == no detecta cambios en los elementos de students
  ///  asi que cuando actualizamos, insertamos o eliminamos un elemento de
  ///  students debemos incrementar este campo para forzar una diferenciacion
  ///  de students.
  /// Con esta solución evitamos tener que calcular un hashcode de students
  /// que tome en cuenta todos los elementos de la lista de students.
  final int differentiator;

  // Construye un StudenLoadedState que incluye un diferenciador por omision de cero
  StudentListingLoadedState(List<Student> students, Student? selectedStudent)
      : students = students,
        selectedStudent = selectedStudent,
        differentiator = 0;

  // Construye un StudenLoadedState que incluye un diferenciador especifico
  StudentListingLoadedState.withDifferentiator(
      List<Student> students, Student? selectedStudent, int differentiator)
      : students = students,
        selectedStudent = selectedStudent,
        differentiator = (differentiator >= 999999999 ? 0 : differentiator);

  @override
  List<Object> get props =>
      [students, selectedStudent ?? "null", differentiator];

  // Construye una version diferenciada (para propositos del operador ==) del StudentsLoadedState
  factory StudentListingLoadedState.differentiated(
      StudentListingLoadedState original) {
    return StudentListingLoadedState.withDifferentiator(original.students,
        original.selectedStudent, original.differentiator + 1);
  }
}

class StudentListingErrorState extends StudentListingState {
  StudentListingErrorState(this.msg);

  final String msg;
  String get message => msg;

  @override
  List<Object> get props => [];
}

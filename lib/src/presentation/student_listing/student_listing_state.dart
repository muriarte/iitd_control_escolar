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
  final bool askDeleteConfirmation;
  final bool showFilters;
  final String nameFilter;
  final bool activesFilter;

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
        differentiator = 0,
        askDeleteConfirmation = false,
        showFilters = false,
        nameFilter = '',
        activesFilter = true;

  // Construye un StudenLoadedState que incluye un diferenciador especifico
  StudentListingLoadedState.withDifferentiator(
      List<Student> students,
      Student? selectedStudent,
      int differentiator,
      bool showFilters,
      String nameFilter,
      bool activesFilter)
      : students = students,
        selectedStudent = selectedStudent,
        differentiator = (differentiator >= 999999999 ? 0 : differentiator),
        askDeleteConfirmation = false,
        showFilters = showFilters,
        nameFilter = nameFilter,
        activesFilter = activesFilter;

  // Construye un StudenLoadedState que incluye un diferenciador especifico y askDeleteConfirmation=true
  StudentListingLoadedState.withDeleteConfirmation(
      List<Student> students,
      Student? selectedStudent,
      int differentiator,
      bool showFilters,
      String nameFilter,
      bool activesFilter)
      : students = students,
        selectedStudent = selectedStudent,
        differentiator = (differentiator >= 999999999 ? 0 : differentiator),
        askDeleteConfirmation = true,
        showFilters = showFilters,
        nameFilter = nameFilter,
        activesFilter = activesFilter;

  // Construye un StudenLoadedState que incluye un diferenciador especifico y askDeleteConfirmation=true
  StudentListingLoadedState.withFilters(
      List<Student> students,
      Student? selectedStudent,
      int differentiator,
      bool showFilters,
      String nameFilter,
      bool activesFilter)
      : students = students,
        selectedStudent = selectedStudent,
        differentiator = (differentiator >= 999999999 ? 0 : differentiator),
        askDeleteConfirmation = false,
        showFilters = showFilters,
        nameFilter = nameFilter,
        activesFilter = activesFilter;

  @override
  List<Object> get props => [
        students,
        selectedStudent ?? "null",
        differentiator,
        askDeleteConfirmation,
        showFilters,
      ];

  // Construye una version diferenciada (para propositos del operador ==) del StudentsLoadedState
  factory StudentListingLoadedState.differentiated(
      StudentListingLoadedState original) {
    return StudentListingLoadedState.withDifferentiator(
        original.students,
        original.selectedStudent,
        original.differentiator + 1,
        original.showFilters,
        original.nameFilter,
        original.activesFilter);
  }

  factory StudentListingLoadedState.differentiatedAndWithDeleteConfirmation(
      StudentListingLoadedState original) {
    return StudentListingLoadedState.withDeleteConfirmation(
        original.students,
        original.selectedStudent,
        original.differentiator + 1,
        original.showFilters,
        original.nameFilter,
        original.activesFilter);
  }

  factory StudentListingLoadedState.differentiatedAndWithShowFilter(
      StudentListingLoadedState original, bool showFilters) {
    return StudentListingLoadedState.withFilters(
        original.students,
        original.selectedStudent,
        original.differentiator + 1,
        showFilters,
        original.nameFilter,
        original.activesFilter);
  }

  factory StudentListingLoadedState.differentiatedAndWithFilters(
      StudentListingLoadedState original, String nameFilter, bool activesFilter) {
    return StudentListingLoadedState.withFilters(
        original.students,
        original.selectedStudent,
        original.differentiator + 1,
        original.showFilters,
        nameFilter,
        activesFilter);
  }

}

class StudentListingErrorState extends StudentListingState {
  StudentListingErrorState(this.msg);

  final String msg;
  String get message => msg;

  @override
  List<Object> get props => [];
}

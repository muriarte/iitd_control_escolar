//import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iitd_control_escolar/src/domain/students/student.dart';
import 'package:iitd_control_escolar/src/presentation/student_listing/student_listing_state.dart';
import 'package:iitd_control_escolar/src/domain/students/student_repository.dart';
// import 'package:iitd_control_escolar/src/repositories/item_not_found_exception.dart';

class StudentListingBloc extends Cubit<StudentListingState> {
  StudentListingBloc(this.studentsRepo) : super(StudentListingInitialState());

  final StudentRepository studentsRepo;

  Future<void> getStudentList() async {
    if (state is StudentListingInitialState) {
      emit(StudentListingLoadingState());

      try {
        List<Student> items = await studentsRepo.getAll();
        items.sort((a, b) => (a.apellidos + " " + a.nombres)
            .toLowerCase()
            .compareTo((b.apellidos + " " + b.nombres).toLowerCase()));

        developer.log("${items.length} students returned",
            name: "students_listing_bloc");

        var st = StudentListingState.loaded(items, items[0]);

        emit(st);
      } catch (ex) {
        emit(StudentListingErrorState(
            "Error al obtener listado de estudiantes: " + ex.toString()));
      }
    }
  }

  /// Establece el item seleccionado de la lista de estudiantes
  Future<void> setSelectedItem(Student selectedItem) async {
    final st = state as StudentListingLoadedState;

    developer.log("setSelectedState emitting loadedState",
        name: "students_listing_bloc");

    emit(StudentListingLoadedState.withDifferentiator(
        st.students,
        selectedItem,
        st.differentiator + 1,
        st.showFilters,
        st.nameFilter,
        st.activesFilter));
  }

  /// Establece el item seleccionado de la lista de estudiantes
  Future<void> setShowFilters(bool showFilter) async {
    final st = state as StudentListingLoadedState;

    developer.log("setShowFilter emitting loadedState",
        name: "students_listing_bloc");

    emit(StudentListingLoadedState.differentiatedAndWithShowFilter(
        st, showFilter));
  }

  /// Establece el item seleccionado de la lista de estudiantes
  Future<void> setFilters(String nameFilter, bool activesFilter) async {
    final st = state as StudentListingLoadedState;

    developer.log(
        "setFilters emitting loadedState [$nameFilter][$activesFilter]",
        name: "students_listing_bloc");

    emit(StudentListingLoadedState.differentiatedAndWithFilters(
        st, nameFilter, activesFilter));
  }

  /// Nuevo estudiante
  Future<void> newItem() async {
    final st = state as StudentListingLoadedState;
    var student = Student.newEmpty();
    emit(StudentListingLoadedState.withDifferentiator(
        st.students,
        student,
        st.differentiator + 1,
        st.showFilters,
        st.nameFilter,
        st.activesFilter));
  }

  /// Actualiza los datos del estudiante
  Future<void> updateItem(Student student) async {
    final isNew = student.id == 0;
    final st = state as StudentListingLoadedState;
    var studentSaved = await studentsRepo.save(student);

    var idx =
        st.students.indexWhere((element) => element.id == studentSaved.id);
    if (idx >= 0) {
      st.students[idx] = studentSaved;
    } else if (isNew) {
      st.students.add(studentSaved);
      // Hemos desordenado la lista al insertar un elemento al final, la ordenamos de nuevo
      st.students.sort((a, b) => (a.apellidos + " " + a.nombres)
          .toLowerCase()
          .compareTo((b.apellidos + " " + b.nombres).toLowerCase()));
    }
    emit(StudentListingLoadedState.withDifferentiator(
        st.students,
        studentSaved,
        st.differentiator + 1,
        st.showFilters,
        st.nameFilter,
        st.activesFilter));
  }

  /// Solicita confirmacion para eliminar estudiante
  Future<void> deleteItemIfConfirmed(int id) async {
    final st = state as StudentListingLoadedState;
    var idx = st.students.indexWhere((element) => element.id == id);
    if (idx < 0) {
      emit(StudentListingLoadedState.differentiated(st));
      return;
    }
    emit(StudentListingLoadedState.withDeleteConfirmation(
        st.students,
        st.students[idx],
        st.differentiator + 1,
        st.showFilters,
        st.nameFilter,
        st.activesFilter));
  }

  /// Elimina estudiante
  Future<void> deleteItem(int id) async {
    final st = state as StudentListingLoadedState;
    var idx = st.students.indexWhere((element) => element.id == id);
    if (idx < 0) {
      emit(StudentListingLoadedState.differentiated(st));
      return;
    }

    Student? selected;
    var result = await studentsRepo.delete(st.students[idx].id);
    if (result) {
      st.students.removeAt(idx);

      if (st.students.length > idx) {
        selected = st.students[idx];
      } else if (idx > 0) {
        selected = st.students[idx - 1];
      }
    }
    emit(StudentListingLoadedState.withDifferentiator(
        st.students,
        selected,
        st.differentiator + 1,
        st.showFilters,
        st.nameFilter,
        st.activesFilter));
  }
}

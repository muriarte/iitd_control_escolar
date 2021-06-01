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

    emit(StudentListingState.loaded(st.students, selectedItem));
  }

  /// Actualiza los datos del estudiante
  Future<void> updateItem(Student student) async {
    final st = state as StudentListingLoadedState;
    var studentSaved = await studentsRepo.save(student);
    var idx =
        st.students.indexWhere((element) => element.id == studentSaved.id);
    if (idx >= 0) {
      st.students[idx] = studentSaved;
    }
    emit(StudentListingLoadedState.withDifferentiator(
        st.students, studentSaved, st.differentiator + 1));
  }

  /// Solicita confirmacion para eliminar estudiante
  Future<void> deleteItemIfConfirmed(int id) async {
    final st = state as StudentListingLoadedState;
    var idx = st.students.indexWhere((element) => element.id == id);
    if (idx < 0) {
      emit(StudentListingLoadedState.differentiated(st));
      return;
    }
    emit(StudentListingLoadedState.withDeleteConfirmation(st.students, st.students[idx], st.differentiator + 1));
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
        st.students, selected, st.differentiator + 1));
  }
}

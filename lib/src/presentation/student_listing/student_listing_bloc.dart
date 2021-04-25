//import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iitd_control_escolar/src/domain/students/student.dart';
import 'package:iitd_control_escolar/src/presentation/student_listing/student_listing_state.dart';
import 'package:iitd_control_escolar/src/domain/students/student_repository.dart';

class StudentListingBloc extends Cubit<StudentListingState> {
  StudentListingBloc(this.studentsRepo) : super(StudentListingInitialState());

  final StudentRepository studentsRepo;

  Future<void> ageIncrement() async {
    if (state is StudentListingLoadedState) {
      final st = state as StudentListingLoadedState;
      if (st.selectedStudent == null)
        emit(StudentListingState.loaded(st.students, null));
      st.selectedStudent!.age += 1;
      if (st.selectedStudent!.age == 20) {
        emit(StudentListingState.error("Llegamos al 20!"));
        return;
      }
      emit(StudentListingState.loaded(st.students, st.selectedStudent));
    } else if (state is StudentListingInitialState) {
      List<Student> items = await studentsRepo.getAll();
      var st = StudentListingState.loaded(items, items[0]);
      emit(st);
    }
  }

  /// Establece el item seleccionado de la lista de estudiantes
  Future<void> setSelectedItem(Student selectedItem) async {
    final st = state as StudentListingLoadedState;
    emit(StudentListingState.loaded(st.students, selectedItem));
  }

  /// Actualiza los datos del estudiante
  Future<void> updateItem(Student student) async {
    final st = state as StudentListingLoadedState;
    var studentSaved = await studentsRepo.save(student);
    emit(StudentListingLoadedState.withDifferentiator(
        st.students, studentSaved, st.differentiator + 1));
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iitd_control_escolar/src/domain/students/student.dart';
import 'package:iitd_control_escolar/src/presentation/student_details/student_details_state.dart';

class StudentDetailsBloc extends Cubit<StudentDetailsState> {
  StudentDetailsBloc() : super(StudentInitialState());

  /// Estblece el estudiante asociado a este estado
  Future<void> setStudent(Student item) async {
    final newState = StudentLoadedState(item, false, false);
    emit(newState);
  }

  /// Establece el modo de edición de la interfaz de usuario ligada a este BLoC
  Future<void> setEditing(bool isEditing) async {
    final st = state as StudentLoadedState;
    final newState = StudentLoadedState(st.student, isEditing, false);
    emit(newState);
  }

  /// Establece el modo de validación de datos de la interfaz de usuario ligada a este BLoC
  Future<void> setValidate(bool validate) async {
    final st = state as StudentLoadedState;
    final newState = StudentLoadedState(st.student, st.isEditing, validate);
    emit(newState);
  }

  /// Actualiza los datos del estudiante
  Future<void> updateItem(String firstName, String lastName, int age) async {
    final st = state as StudentLoadedState;
    final id = st.student?.id ?? 0;
    final student = Student(id, firstName, lastName, age);
    emit(StudentLoadedState(student, st.isEditing, st.validate));
  }

  // Future<void> save() {

  // }
}

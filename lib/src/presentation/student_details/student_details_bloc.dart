import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iitd_control_escolar/src/domain/students/student.dart';
import 'package:iitd_control_escolar/src/presentation/student_details/student_details_state.dart';

class StudentDetailsBloc extends Cubit<StudentDetailsState> {
  StudentDetailsBloc() : super(StudentInitialState());

  /// Establece el estudiante asociado a este estado
  Future<void> setStudent(Student item) async {
    final isEditing = item.id == 0;
    final newState = StudentLoadedState(item, isEditing, false);
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
  Future<void> updateItem(
    String nombres,
    String apellidos,
    DateTime nacimiento,
    String sexo,
    String calle,
    String numeroExt,
    String numeroInt,
    String colonia,
    String municipio,
    String estado,
    String pais,
    String cp,
    String telCelular,
    String telCasa,
    String email,
    DateTime fechaInicio,
    String observaciones,
    String activo,
  ) async {
    final st = state as StudentLoadedState;
    final id = st.student?.id ?? 0;
    final student = Student(
      id,
      nombres,
      apellidos,
      nacimiento,
      sexo,
      calle,
      numeroExt,
      numeroInt,
      colonia,
      municipio,
      estado,
      pais,
      cp,
      telCelular,
      telCasa,
      email,
      fechaInicio,
      observaciones,
      activo,
    );
    emit(StudentLoadedState(student, st.isEditing, st.validate));
  }

  // Future<void> save() {

  // }
}

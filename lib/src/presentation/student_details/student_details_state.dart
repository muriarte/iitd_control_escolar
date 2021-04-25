import 'package:equatable/equatable.dart';
import 'package:iitd_control_escolar/src/domain/students/student.dart';

abstract class StudentDetailsState extends Equatable {}

class StudentInitialState extends StudentDetailsState {
  @override
  List<Object> get props => [];
}

class StudentLoadingState extends StudentDetailsState {
  @override
  List<Object> get props => [];
}

class StudentLoadedState extends StudentDetailsState {
  StudentLoadedState(this.student, this.isEditing, this.validate);

  final Student? student;
  final bool isEditing;
  final bool validate;

  @override
  List<Object> get props => [student!, isEditing, validate];
}

class StudentErrorState extends StudentDetailsState {
  StudentErrorState(this.msg);

  final String msg;
  String get message => msg;

  @override
  List<Object> get props => [];
}

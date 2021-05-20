import "package:get_it/get_it.dart";
import 'package:iitd_control_escolar/src/domain/students/student_repository.dart';
//import 'package:iitd_control_escolar/src/repositories/students_from_memory_repository.dart';
import 'package:iitd_control_escolar/src/repositories/students_from_api_repository.dart';
import 'package:iitd_control_escolar/src/presentation/student_listing/student_listing_bloc.dart';

GetIt getIt = GetIt.instance;

void setupDependencyInjection() {
  final String apiBaseUrl = "http://127.0.0.1:8080/v1/";
  getIt.registerFactory<StudentListingBloc>(
      () => StudentListingBloc(getIt<StudentRepository>()));
  getIt.registerSingleton<StudentRepository>(
      StudentsFromApiRepository(apiBaseUrl));
}

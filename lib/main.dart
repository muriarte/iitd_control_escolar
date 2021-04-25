import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iitd_control_escolar/src/presentation/home_page.dart';
import 'package:iitd_control_escolar/src/presentation/student_listing/student_listing_bloc.dart';
import 'package:iitd_control_escolar/di_container.dart';

void main() {
  setupDependencyInjection();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final StudentListingBloc myCubit = getIt<StudentListingBloc>(); //StudentListingBloc();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<StudentListingBloc>(
      create: (context) => myCubit,
      child: MaterialApp(
        title: 'Sistema de gestión de estudiantes',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Pagina principal'),
      ),
    );
  }
}

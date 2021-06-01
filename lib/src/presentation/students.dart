import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iitd_control_escolar/src/domain/students/student.dart';
import 'package:iitd_control_escolar/src/presentation/student_details/student_details_bloc.dart';
import 'package:iitd_control_escolar/src/presentation/student_listing/student_listing_state.dart';
import 'package:iitd_control_escolar/src/presentation/student_listing/student_listing_bloc.dart';
import 'package:iitd_control_escolar/src/presentation/student_listing/student_listing.dart';
import 'package:iitd_control_escolar/src/presentation/student_details/student_details.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const int kTabletBreakpoint = 600;
  var studentCubit = StudentDetailsBloc();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: BlocConsumer<StudentListingBloc, StudentListingState>(
        bloc: BlocProvider.of<StudentListingBloc>(context),
        listener: (context, state) {
          // Error state
          if (state is StudentListingErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text("Something went wrong:" + state.message),
              ),
            );
          } else if (state is StudentListingLoadedState) {
            if (state.askDeleteConfirmation) {
              var bloc = BlocProvider.of<StudentListingBloc>(context);
              _showConfirmationDialog(state.selectedStudent, bloc);
            }
          }
        },
        builder: (context, state) {
          developer.log("State ${state.runtimeType}", name: "home_page");
          if (state is StudentListingInitialState) {
            return Center(
              child: _buildInitialContent(),
            );
          } else if (state is StudentListingLoadingState) {
            return Center(
              child: Text("Por favor espere..."),
            );
          } else if (state is StudentListingLoadedState) {
            if (shortestSide < kTabletBreakpoint) {
              return _buildMobileLayout();
            } else {
              return _buildTabletLayout();
            }
          } else if (state is StudentListingErrorState) {
            return Center(
              child: Text(state.message),
            );
          } else {
            return Center(
              child: Text("Something went wrong. Please restart this app."),
            );
          }
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('iitd Control escolar'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Row(children: <Widget>[
                Icon(Icons.contacts),
                const Text('Students'),
              ]),
              onTap: () {
                Navigator.of(context).pop();
                BlocProvider.of<StudentListingBloc>(context).getStudentList();
                // Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (BuildContext context) {
                //       var cubit = BlocProvider.of<StudentListingBloc>(context);
                //       return StudentListing(
                //         itemSelectedCallback: (item) {
                //           cubit.setSelectedItem(item);
                //         },
                //       );
                //     },
                //   ),
                //   //(route) => true,
                // );
              },
            ),
            ListTile(
              title: Row(children: <Widget>[
                Icon(Icons.close),
                const Text('Close'),
              ]),
              onTap: () => Navigator.of(context).pop(), //Close drawer
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    // developer.log("Mobile layout builder\r\n");
    developer.log("Building mobile layout", name: "home_page");
    return StudentListing(
      itemSelectedCallback: (item) {
        // developer.log("Mobile ItemSelectedCallback: ${item.firstName}\r\n");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              BlocProvider.of<StudentListingBloc>(context)
                  .setSelectedItem(item);
              studentCubit.setStudent(item);
              return BlocProvider<StudentDetailsBloc>.value(
                value: studentCubit,
                child: StudentDetails(
                  isInTabletLayout: false,
                  item: item,
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTabletLayout() {
    var cubit = BlocProvider.of<StudentListingBloc>(context);
    developer.log("Building tablet layout", name: "home_page");
    if ((cubit.state as StudentListingLoadedState).selectedStudent != null) {
      studentCubit.setStudent(
          (cubit.state as StudentListingLoadedState).selectedStudent!);
    }
    // developer.log("Tablet layout builder\r\n");
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Material(
            elevation: 4.0,
            child: (cubit.state as StudentListingLoadedState).selectedStudent !=
                    null
                ? StudentListing(
                    itemSelectedCallback: (item) {
                      // developer
                      //     .log("Tablet ItemSelectedCallback: ${item.firstName}\r\n");
                      cubit.setSelectedItem(item);
                    },
                    selectedItem: (cubit.state as StudentListingLoadedState)
                        .selectedStudent,
                  )
                : Text("No hay estudiantesa registrados"),
          ),
        ),
        BlocProvider<StudentDetailsBloc>.value(
          value: studentCubit,
          // create: (context) {
          //   // Este evento se ejecuta una sola vez en la vida de esta pagina
          //   var cub = BlocProvider.of<StudentsCubit>(context);
          //   developer.log(
          //       "***Tablet bloc create: ${(cub.state as StudentsLoadedState).selectedStudent!.firstName}");
          //   studentCubit.setStudent(
          //       (cub.state as StudentsLoadedState).selectedStudent!);
          //   return studentCubit;
          // },
          child: Flexible(
            flex: 2,
            child: StudentDetails(
              isInTabletLayout: true,
              item: (cubit.state as StudentListingLoadedState)
                  .selectedStudent, //_selectedItem,
              //cubit: cubit,
            ),
          ),
        ),
      ],
    );
  }

  Column _buildInitialContent() {
    return Column(
      children: [
        Text("(blank)"),
        TextButton(
          onPressed: () {
            // var cubit = BlocProvider.of<StudentListingBloc>(context);
            // cubit.ageIncrement();
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  var cubit = BlocProvider.of<StudentListingBloc>(context);
                  return StudentListing(
                    itemSelectedCallback: (item) {
                      cubit.setSelectedItem(item);
                    },
                  );
                },
              ),
              //(route) => true,
            );
          },
          child: Text("+"),
        ),
      ],
    );
  }

  Future<void> _showConfirmationDialog(Student? student, StudentListingBloc bloc) async {
    if (student == null) return;
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirme eliminación de estudiante'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Por favor confirme si desea eliminar al estudiante'),
                Text('${student.id} - ${student.nombres} ${student.apellidos}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirmar'),
              onPressed: () {
                print('Confirmed');
                bloc.deleteItem(student.id);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

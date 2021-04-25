//import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          if (state is StudentListingErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
              ),
            );
          }
        },
        builder: (context, state) {
          // developer.log("Home page bloc builder 1\r\n");
          if (state is StudentListingInitialState) {
            // developer.log("Home page bloc builder 2\r\n");
            return Center(
              child: _buildInitialContent(),
            );
          } else if (state is StudentListingLoadingState) {
            // developer.log("Home page bloc builder 3\r\n");
            return Center(
              child: Text("Por favor espere..."),
            );
          } else if (state is StudentListingLoadedState) {
            // developer.log(
            //     "Home page bloc builder 4: \r\n"); //${_itemCubit.state is StudentLoadedState ? (_itemCubit.state as StudentLoadedState).student?.firstName : "null"}\r\n");
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text('This is the Drawer'),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(), //Close drawer
                child: const Text('Close Drawer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    // developer.log("Mobile layout builder\r\n");
    return StudentListing(
      itemSelectedCallback: (item) {
        // developer.log("Mobile ItemSelectedCallback: ${item.firstName}\r\n");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              // developer.log("Mobile layout MaterialPageRoute builder\r\n");
              BlocProvider.of<StudentListingBloc>(context).setSelectedItem(item);
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
    studentCubit
        .setStudent((cubit.state as StudentListingLoadedState).selectedStudent!);
    // developer.log("Tablet layout builder\r\n");
    return Row(
      children: <Widget>[
        Flexible(
          flex: 1,
          child: Material(
            elevation: 4.0,
            child: StudentListing(
              itemSelectedCallback: (item) {
                // developer
                //     .log("Tablet ItemSelectedCallback: ${item.firstName}\r\n");
                cubit.setSelectedItem(item);
              },
              selectedItem:
                  (cubit.state as StudentListingLoadedState).selectedStudent,
            ),
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
            flex: 3,
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
            var cubit = BlocProvider.of<StudentListingBloc>(context);
            cubit.ageIncrement();
          },
          child: Text("+"),
        ),
      ],
    );
  }
}

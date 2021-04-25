//import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iitd_control_escolar/src/presentation/student_details/student_details_bloc.dart';
import 'package:iitd_control_escolar/src/presentation/student_listing/student_listing_bloc.dart';
import 'package:iitd_control_escolar/src/presentation/student_details/student_details_state.dart';
import 'package:iitd_control_escolar/src/domain/students/student.dart';

class StudentDetails extends StatefulWidget {
  StudentDetails({
    required this.isInTabletLayout,
    required this.item,
  });

  final bool isInTabletLayout;
  final Student? item;

  @override
  _StudentDetailsState createState() => _StudentDetailsState();
}

class _StudentDetailsState extends State<StudentDetails> {
  //final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController ageController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    ageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //developer.log("StudentDetails.build 1: ${_getCurFirstName()}\r\n");
    final Widget content = _buildContent(context);

    if (widget.isInTabletLayout) {
      return Center(child: content);
    }
    //developer.log("StudentDetails.build 2: ${_getCurFirstName()}\r\n");
    return Scaffold(
      appBar: AppBar(
        title: Text("Detalles de estudiante"),
      ),
      body: Center(child: content),
    );
  }

  Widget _buildContent(BuildContext context) {
    return BlocBuilder<StudentDetailsBloc, StudentDetailsState>(
        //bloc: _cubit,
        builder: (context, studentState) {
      var student = (studentState as StudentLoadedState).student;
      firstNameController.value =
          TextEditingValue(text: student?.firstName ?? "");
      lastNameController.value =
          TextEditingValue(text: student?.lastName ?? "");
      ageController.value =
          TextEditingValue(text: student?.age.toString() ?? "");

      var isEditing = studentState.isEditing;
      var validate = studentState.validate;
      // developer.log("_buildContent: IsEditing:$isEditing\r\n",
      //     name: "StudentDetails");

      return SingleChildScrollView(
        child: Stack(children: [
          Form(
            key: _formKey,
            autovalidateMode: validate
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text("Id: ${student?.id}"),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'First name',
                    filled: true,
                    isDense: true,
                  ),
                  controller: firstNameController,
                  keyboardType: TextInputType.name,
                  enabled: isEditing,
                  autocorrect: false,
                  validator: _notEmptyValidator,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Last name',
                    filled: true,
                    isDense: true,
                  ),
                  controller: lastNameController,
                  keyboardType: TextInputType.name,
                  enabled: isEditing,
                  autocorrect: false,
                  validator: _notEmptyValidator,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Age',
                    filled: true,
                    isDense: true,
                  ),
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  enabled: isEditing,
                  autocorrect: false,
                  validator: (String? value) {
                    if (value == null) return "Cannot be empty";
                    var age = int.tryParse(value);
                    if (age == null || age <= 0) return "Invalid age";
                    return null;
                  },
                ),
              ],
            ),
          ),
          if (!isEditing)
            // Desplegamos el botón de Edit
            Positioned(
              right: 10,
              bottom: 5,
              child: FloatingActionButton(
                child: const Icon(Icons.edit),
                onPressed: () {
                  BlocProvider.of<StudentDetailsBloc>(context).setEditing(true);
                },
              ),
            )
          else
            // Desplegamos el botón de Save
            Positioned(
              right: 10,
              bottom: 5,
              child: FloatingActionButton(
                child: const Icon(Icons.save),
                onPressed: () {
                  _validateFormAndProcess();
                },
              ),
            ),
        ]),
      );
    });
  }

  String? _notEmptyValidator(String? value) {
    if (value == null) return "Cannot be empty";
    if (value.trim().length == 0) return "Cannot be empty";

    return null;
  }

  void _validateFormAndProcess() {
    // Get form state from the global key
    var formState = _formKey.currentState;
    if (formState == null) return;

    var firstName = firstNameController.text;
    var lastName = lastNameController.text;
    var age = int.tryParse(ageController.text);

    var cub = BlocProvider.of<StudentDetailsBloc>(context);
    cub.updateItem(firstName, lastName, age ?? 0);

    // print('First name: $firstName\r\n');
    // print('Last name: $lastName\r\n');
    // print('Age: $age\r\n');

    // check if form is valid
    if (formState.validate()) {
      // Form is valid
      //cub.save();
      cub.setEditing(false);
      BlocProvider.of<StudentListingBloc>(context)
          .updateItem((cub.state as StudentLoadedState).student!);
    } else {
      // Form is invalid
      cub.setValidate(true);
    }
  }
}

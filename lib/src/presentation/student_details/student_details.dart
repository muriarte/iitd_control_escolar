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

  TextEditingController nombresController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();
  TextEditingController nacimientoController = TextEditingController();
  TextEditingController sexoController = TextEditingController();
  TextEditingController calleController = TextEditingController();
  TextEditingController numeroExtController = TextEditingController();
  TextEditingController numeroIntController = TextEditingController();
  TextEditingController coloniaController = TextEditingController();
  TextEditingController municipioController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController paisController = TextEditingController();
  TextEditingController cpController = TextEditingController();
  TextEditingController telCelularController = TextEditingController();
  TextEditingController telcasaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController fechaInicioController = TextEditingController();
  TextEditingController observacionesController = TextEditingController();
  TextEditingController activoController = TextEditingController();

  @override
  void dispose() {
    nombresController.dispose();
    apellidosController.dispose();
    nacimientoController.dispose();
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
      if (studentState is StudentInitialState) {
        return Text("No item selected");
      }

      var student = (studentState as StudentLoadedState).student;
      nombresController.value = TextEditingValue(text: student?.nombres ?? "");
      apellidosController.value =
          TextEditingValue(text: student?.apellidos ?? "");
      nacimientoController.value =
          TextEditingValue(text: student?.nacimiento.toString() ?? "");

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
                    labelText: 'Nombres',
                    filled: true,
                    isDense: true,
                  ),
                  controller: nombresController,
                  keyboardType: TextInputType.name,
                  enabled: isEditing,
                  autocorrect: false,
                  validator: _notEmptyValidator,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Apellidos',
                    filled: true,
                    isDense: true,
                  ),
                  controller: apellidosController,
                  keyboardType: TextInputType.name,
                  enabled: isEditing,
                  autocorrect: false,
                  validator: _notEmptyValidator,
                ),
                SizedBox(height: 10),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Nacimiento',
                    filled: true,
                    isDense: true,
                  ),
                  controller: nacimientoController,
                  keyboardType: TextInputType.datetime,
                  enabled: isEditing,
                  autocorrect: false,
                  validator: (String? value) {
                    if (value == null) return "Cannot be empty";
                    var nacimiento = DateTime.tryParse(value);
                    if (nacimiento == null || nacimiento.year <= 0) return "Invalid birthdate";
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

    var nombres = nombresController.text;
    var apellidos = apellidosController.text;
    var nacimiento =
        DateTime.tryParse(nacimientoController.text) ?? DateTime(2000, 1, 1);
    var sexo = sexoController.text;
    var calle = calleController.text;
    var numeroExt = numeroExtController.text;
    var numeroInt = numeroIntController.text;
    var colonia = coloniaController.text;
    var municipio = municipioController.text;
    var estado = estadoController.text;
    var pais = paisController.text;
    var cp = cpController.text;
    var telCelular = telCelularController.text;
    var telCasa = telcasaController.text;
    var email = emailController.text;
    var fechaInicio = DateTime.tryParse(fechaInicioController.text) ?? DateTime(2000, 1, 1);
    var observaciones = observacionesController.text;
    var activo = activoController.text;

    var cub = BlocProvider.of<StudentDetailsBloc>(context);
    cub.updateItem(
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

//import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iitd_control_escolar/src/presentation/validators.dart';
import 'package:iitd_control_escolar/src/presentation/student_details/student_details_bloc.dart';
import 'package:iitd_control_escolar/src/presentation/student_listing/student_listing_bloc.dart';
import 'package:iitd_control_escolar/src/presentation/student_details/student_details_state.dart';
import 'package:iitd_control_escolar/src/domain/students/student.dart';

//typedef TxtEditVal = TextEditingValue;

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

  var nombresController = TextEditingController();
  var apellidosController = TextEditingController();
  var nacimientoController = TextEditingController();
  var sexoController = TextEditingController();
  var calleController = TextEditingController();
  var numeroExtController = TextEditingController();
  var numeroIntController = TextEditingController();
  var coloniaController = TextEditingController();
  var municipioController = TextEditingController();
  var estadoController = TextEditingController();
  var paisController = TextEditingController();
  var cpController = TextEditingController();
  var telCelularController = TextEditingController();
  var telCasaController = TextEditingController();
  var emailController = TextEditingController();
  var fechaInicioController = TextEditingController();
  var observacionesController = TextEditingController();
  var activoController = TextEditingController();

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
      sexoController.value = TextEditingValue(text: student?.sexo ?? "");
      calleController.value = TextEditingValue(text: student?.calle ?? "");
      numeroExtController.value =
          TextEditingValue(text: student?.numeroExt ?? "");
      numeroIntController.value =
          TextEditingValue(text: student?.numeroInt ?? "");
      coloniaController.value = TextEditingValue(text: student?.colonia ?? "");
      municipioController.value =
          TextEditingValue(text: student?.municipio ?? "");
      estadoController.value = TextEditingValue(text: student?.estado ?? "");
      paisController.value = TextEditingValue(text: student?.pais ?? "");
      cpController.value = TextEditingValue(text: student?.cp ?? "");
      telCelularController.value =
          TextEditingValue(text: student?.telCelular ?? "");
      telCasaController.value = TextEditingValue(text: student?.telCasa ?? "");
      emailController.value = TextEditingValue(text: student?.email ?? "");
      fechaInicioController.value =
          TextEditingValue(text: student?.fechaInicio.toString() ?? "");
      observacionesController.value =
          TextEditingValue(text: student?.observaciones ?? "");
      activoController.value = TextEditingValue(text: student?.activo ?? "N");

      var isEditing = studentState.isEditing;
      var validate = studentState.validate;
      // developer.log("_buildContent: IsEditing:$isEditing\r\n",
      //     name: "StudentDetails");

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
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
                buildTextFormField(
                  label: 'Nombres',
                  isEditing: isEditing,
                  textController: nombresController,
                  inputType: TextInputType.name,
                  validator: Validators.notEmpty,
                  maxLength: 100,
                ),
                SizedBox(height: 10),
                buildTextFormField(
                  label: 'Apellidos',
                  isEditing: isEditing,
                  textController: apellidosController,
                  inputType: TextInputType.name,
                  validator: Validators.notEmpty,
                  maxLength: 100,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: buildTextFormField(
                        label: "Nacimiento",
                        isEditing: isEditing,
                        textController: nacimientoController,
                        inputType: TextInputType.datetime,
                        validator: Validators.date,
                        maxLength: 30,
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 60,
                      child: buildTextFormField(
                        label: "Sexo",
                        isEditing: isEditing,
                        textController: sexoController,
                        validator: Validators.mf,
                        maxLength: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: buildTextFormField(
                        label: "Calle",
                        isEditing: isEditing,
                        textController: calleController,
                        inputType: TextInputType.name,
                        maxLength: 100,
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 120,
                      child: buildTextFormField(
                        label: "Numero Ext.",
                        isEditing: isEditing,
                        textController: numeroExtController,
                        maxLength: 50,
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 120,
                      child: buildTextFormField(
                        label: "Numero Int",
                        isEditing: isEditing,
                        textController: numeroIntController,
                        maxLength: 50,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: buildTextFormField(
                        label: "Colonia",
                        isEditing: isEditing,
                        textController: coloniaController,
                        maxLength: 50,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: buildTextFormField(
                        label: "Municipio",
                        isEditing: isEditing,
                        textController: municipioController,
                        maxLength: 50,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: buildTextFormField(
                        label: "Estado",
                        isEditing: isEditing,
                        textController: estadoController,
                        maxLength: 50,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: buildTextFormField(
                        label: "Pais",
                        isEditing: isEditing,
                        textController: paisController,
                        maxLength: 50,
                      ),
                    ),
                    SizedBox(width: 10),
                    SizedBox(
                      width: 90,
                      child: buildTextFormField(
                        label: "C.P.",
                        isEditing: isEditing,
                        textController: cpController,
                        maxLength: 6,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: buildTextFormField(
                        label: "Tel. Celular",
                        isEditing: isEditing,
                        textController: telCelularController,
                        inputType: TextInputType.phone,
                        maxLength: 50,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: buildTextFormField(
                        label: "Tel. casa",
                        isEditing: isEditing,
                        textController: telCasaController,
                        inputType: TextInputType.phone,
                        maxLength: 50,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: buildTextFormField(
                        label: "EMail",
                        isEditing: isEditing,
                        textController: emailController,
                        inputType: TextInputType.emailAddress,
                        maxLength: 255,
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: buildTextFormField(
                        label: "Fecha inicio",
                        isEditing: isEditing,
                        textController: fechaInicioController,
                        inputType: TextInputType.datetime,
                        validator: Validators.date,
                        maxLength: 30,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                buildTextFormField(
                  label: "Observaciones",
                  isEditing: isEditing,
                  textController: observacionesController,
                  inputType: TextInputType.multiline,
                ),
                SizedBox(height: 10),
                buildTextFormField(
                  label: "Activo",
                  isEditing: isEditing,
                  textController: activoController,
                  validator: Validators.sn,
                        maxLength: 1,
                ),
              ],
            ),
          ),
          if (isEditing)
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
            )
          else
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
            ),
        ]),
      );
    });
  }

  TextFormField buildTextFormField(
      {String label = '',
      required bool isEditing,
      int? maxLength,
      required TextEditingController textController,
      TextInputType inputType = TextInputType.text,
      String? Function(String?)? validator}) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        isDense: true,
      ),
      controller: textController,
      keyboardType: inputType,
      enabled: isEditing,
      autocorrect: false,
      validator: validator,
      maxLines: inputType == TextInputType.multiline ? 5 : 1,
      minLines: inputType == TextInputType.multiline ? 2 : null,
      maxLength: maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
    );
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
    var telCasa = telCasaController.text;
    var email = emailController.text;
    var fechaInicio =
        DateTime.tryParse(fechaInicioController.text) ?? DateTime(2000, 1, 1);
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

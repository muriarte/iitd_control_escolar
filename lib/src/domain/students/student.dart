import "dart:convert";

import 'dart:developer' as developer;

Student studentFromJson(String str) {
  final jsonData = json.decode(str);
  return Student.fromJson(jsonData);
}

String studentToJson(Student data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

List<Student> allStudentsFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<Student>.from(jsonData.map((x) => Student.fromJson(x)));
}

String allStudentsToJson(List<Student> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

/* 
id
nombres
apellidos
nacimiento
sexo
calle
numeroExt
numeroInt
colonia
municipio
estado
pais
cp
telCelular
telCasa
email
fechaInicio
observaciones
activo
 */

class Student {
  late int id;
  late String nombres;
  late String apellidos;
  late DateTime nacimiento;
  late String sexo;
  late String calle;
  late String numeroExt;
  late String numeroInt;
  late String colonia;
  late String municipio;
  late String estado;
  late String pais;
  late String cp;
  late String telCelular;
  late String telCasa;
  late String email;
  late DateTime fechaInicio;
  late String observaciones;
  late String activo;

  /// Crea un nuevo estudiante
  Student(
      this.id,
      this.nombres,
      this.apellidos,
      this.nacimiento,
      this.sexo,
      this.calle,
      this.numeroExt,
      this.numeroInt,
      this.colonia,
      this.municipio,
      this.estado,
      this.pais,
      this.cp,
      this.telCelular,
      this.telCasa,
      this.email,
      this.fechaInicio,
      this.observaciones,
      this.activo);

  /// Crea un nuevo estudiante inicializando sus propiedades con los valores de otro estudiante
  Student.byObject(Student obj) {
    copyProps(obj);
    developer.log("Student.ByObject", name: "domain/students/student.dart");
  }

  /// Copia todas las propiedades del objeto proporcionado en este objeto
  void copyProps(Student obj) {
    id = obj.id;
    nombres = obj.nombres;
    apellidos = obj.apellidos;
    nacimiento = obj.nacimiento;
    sexo = obj.sexo;
    calle = obj.calle;
    numeroExt = obj.numeroExt;
    numeroInt = obj.numeroInt;
    colonia = obj.colonia;
    municipio = obj.municipio;
    estado = obj.estado;
    pais = obj.pais;
    cp = obj.cp;
    telCelular = obj.telCelular;
    telCasa = obj.telCasa;
    email = obj.email;
    fechaInicio = obj.fechaInicio;
    observaciones = obj.observaciones;
    activo = obj.activo;
  }

  Student.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        nombres = json['nombres'],
        apellidos = json['apellidos'],
        nacimiento = DateTime.parse(json['nacimiento']),
        sexo = json['sexo'],
        calle = json['calle'],
        numeroExt = json['numeroExt'],
        numeroInt = json['numeroInt'],
        colonia = json['colonia'],
        municipio = json['municipio'],
        estado = json['estado'],
        pais = json['pais'],
        cp = json['cp'],
        telCelular = json['telCelular'],
        telCasa = json['telCasa'],
        email = json['email'],
        fechaInicio = DateTime.parse(json['fechaInicio']),
        observaciones = json['observaciones'],
        activo = json['activo'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombres': nombres,
        'apellidos': apellidos,
        'nacimiento': nacimiento.toIso8601String().substring(0, 19) + "Z",
        'sexo': sexo,
        'calle': calle,
        'numeroExt': numeroExt,
        'numeroInt': numeroInt,
        'colonia': colonia,
        'municipio': municipio,
        'estado': estado,
        'pais': pais,
        'cp': cp,
        'telCelular': telCelular,
        'telCasa': telCasa,
        'email': email,
        'fechaInicio': fechaInicio.toIso8601String().substring(0, 19) + "Z",
        'observaciones': observaciones,
        'activo': activo,
      };
}

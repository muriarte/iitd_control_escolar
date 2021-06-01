import "dart:convert";

//import 'dart:developer';

Status statusFromJson(String str) {
  final jsonData = json.decode(str);
  return Status.fromJson(jsonData);
}

String statusToJson(Status data) {
  final dyn = data.toJson();
  return json.encode(dyn);
}

List<Status> allStatusFromJson(String str) {
  final jsonData = json.decode(str);
  return new List<Status>.from(jsonData.map((x) => Status.fromJson(x)));
}

String allStatusToJson(List<Status> data) {
  final dyn = new List<dynamic>.from(data.map((x) => x.toJson()));
  return json.encode(dyn);
}

/* 
status
 */

class Status {
  late bool status;

  /// Crea un nuevo status
  Status(
      this.status);

  /// Crea un nuevo status inicializando sus propiedades con los valores de otro status
  Status.byObject(Status obj) {
    copyProps(obj);
  }

  /// Copia todas las propiedades del objeto proporcionado en este objeto
  void copyProps(Status obj) {
    status = obj.status;
  }

  Status.fromJson(Map<String, dynamic> json)
      : status = json['status'];

  Map<String, dynamic> toJson() => {
        'status': status,
      };
}

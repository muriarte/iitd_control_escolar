class Student {
  late int id;
  late String firstName;
  late String lastName;
  late int age;

  /// Crea un nuevo estudiante
  Student(this.id, this.firstName, this.lastName, this.age);

  /// Crea un nuevo estudiante inicializando sus propiedades con los valores de otro estudiante
  Student.byObject(Student obj) {
    copyProps(obj);
  }

  /// Copia todas las propiedades del objeto proporcionado en este objeto
  void copyProps(Student obj) {
    id = obj.id;
    firstName = obj.firstName;
    lastName = obj.lastName;
    age = obj.age;
  }

  Student.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        age = json['age'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'age': age,
      };
}

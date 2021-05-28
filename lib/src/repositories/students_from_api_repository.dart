import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'package:iitd_control_escolar/src/repositories/common.dart';
//import '../services/api_services/school_api_provider.dart';
import '../domain/students/student.dart';
import '../domain/students/student_repository.dart';
import 'network_exception.dart';

class StudentsFromApiRepository extends StudentRepository {
  final List<Student> students = [];
  String url;

  StudentsFromApiRepository(String baseUrl) : url = baseUrl + "students";

  Future<List<Student>> getAll() async {
    try {
      developer.log("Calling endpoint $url",
          name: "students_from_api_repository");

      final response = await http.get(Uri.parse('$url'));
      checkResponseAndThrowExceptionIfSomethingWentWrong(response);

      developer.log("Returning student list",
          name: "students_from_api_repository");

      return allStudentsFromJson(response.body);
    } on IOException {
      developer.log("IOException detected, throwing NetworkException",
          name: "students_from_api_repository");

      throw NetworkException();
    }
  }

  Future<Student> get(int id) async {
    try {
      final response = await http.get(Uri.parse('$url/$id'));
      checkResponseAndThrowExceptionIfSomethingWentWrong(response);
      return studentFromJson(response.body);
    } on IOException {
      throw NetworkException();
    }
  }

  Future<Student> save(Student student) async {
    try {
      //developer.debugger();
      final body = jsonEncode(student.toJson());
      final response = await http.post(Uri.parse('$url'), body: body, headers: {
        HttpHeaders.acceptHeader: 'application/json',
        HttpHeaders.contentTypeHeader: 'application/json'
      });
      //developer.debugger();
      checkResponseAndThrowExceptionIfSomethingWentWrong(response);
      return studentFromJson(response.body);
    } on IOException {
      throw NetworkException();
    }
  }

  Future<bool> delete(int id) async {
    try {
      final response = await http.delete(Uri.parse('$url/$id'), headers: {
        HttpHeaders.acceptHeader: 'application/json',
      });
      checkResponseAndThrowExceptionIfSomethingWentWrong(response);
      return true;
    } on IOException {
      throw NetworkException();
    }
  }
}

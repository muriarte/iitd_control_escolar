import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'item_not_found_exception.dart';
import 'unknown_api_exception.dart';

http.Response checkResponseAndThrowExceptionIfSomethingWentWrong(
    http.Response response) {
  developer.log('Reponse statuscode:${response.statusCode}', name: 'api');
  if (response.statusCode == 404) {
    throw ItemNotFoundException();
  } else if (response.statusCode > 400) {
    throw UnknownApiException(response.statusCode);
  } else {
    return response;
  }
}

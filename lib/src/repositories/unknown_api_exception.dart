// Exception thrown when an error like http status code is returned from an http API call.
class UnknownApiException implements Exception {
  final int statusCode; 
  @pragma("vm:entry-point")
  const UnknownApiException(this.statusCode);
  String toString() => "UnknownApiException. http status code: $statusCode";
}

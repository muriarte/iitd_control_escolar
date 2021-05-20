// Exception thrown when an exception is detected while doing an http API call.
class NetworkException implements Exception {
  @pragma("vm:entry-point")
  const NetworkException();
  String toString() => "NetworkException";
}

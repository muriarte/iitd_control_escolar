// Exception thrown when an Item was not found.
class ItemNotFoundException implements Exception {
  @pragma("vm:entry-point")
  const ItemNotFoundException();
  String toString() => "ItemNotFoundException";
}

class Validators {
  static String? date(String? value) {
    if (value == null) return "Cannot be empty";
    var fecha = DateTime.tryParse(value);
    if (fecha == null || fecha.year <= 0) return "Invalid date";
    return null;
  }

  static String? notEmpty(String? value) {
    if (value == null) return "Cannot be empty";
    if (value.trim().length == 0) return "Cannot be empty";
    return null;
  }

  static String? sn(String? value) {
    if (value == null) return "Cannot be empty";
    if (value.length == 0) return "Cannot be empty";
    if (value.length > 1) return "Too many chars (one char required)";
    if (!"SN".contains(value)) return "Invalid value, must be 'S' or 'N'";
    return null;
  }

  static String? mf(String? value) {
    if (value == null) return "Cannot be empty";
    if (value.length == 0) return "Cannot be empty";
    if (value.length > 1) return "Too many chars (one char required)";
    if (!"MF".contains(value)) return "Invalid value, must be 'S' or 'N'";
    return null;
  }

}

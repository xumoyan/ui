class Utils {
  static dynamic getParams(Map<String, dynamic> map) {
    if (map != null) {
      final Map<String, dynamic> arguments = Map<String, dynamic>.from(map);
      return arguments["params"];
    }
    return null;
  }
}

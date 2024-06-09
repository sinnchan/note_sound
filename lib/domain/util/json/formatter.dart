import 'dart:convert';

extension JsonFormatter on Map<String, dynamic> {
  String jsonFormat() {
    const converter = JsonEncoder.withIndent('  ');
    return converter.convert(this);
  }
}

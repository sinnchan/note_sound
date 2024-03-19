import 'dart:convert';

import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:logger/logger.dart' as log;
import 'package:logger/web.dart';
import 'package:note_sound/domain/models/logger/i_logger.dart';

class CustomLogger implements ILogger {
  CustomLogger(this.name);

  final String? name;
  late final _logger = log.Logger(
    printer: _Printer(name),
  );

  @override
  void v(Object message, {Object? error, StackTrace? stackTrace}) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  @override
  void d(Object message, {Object? error, StackTrace? stackTrace}) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  @override
  void i(Object message, {Object? error, StackTrace? stackTrace}) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  @override
  void w(Object message, {Object? error, StackTrace? stackTrace}) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  @override
  void e(Object message, {Object? error, StackTrace? stackTrace}) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  @override
  void f(Object message, {Object? error, StackTrace? stackTrace}) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}

class _Printer extends LogPrinter {
  _Printer(this._name);
  final String? _name;

  @override
  List<String> log(LogEvent event) {
    final colors = PrettyPrinter.defaultLevelColors[event.level];
    final emojies = {
      ...PrettyPrinter.defaultLevelEmojis,
      Level.trace: '🔉',
    };
    final emoji = emojies[event.level];
    final color = colors ?? const AnsiColor.none();
    final name = _name.letWithElse((name) => '[$name]', orElse: '');
    return stringifyMessage(event.message)
        .split('\n')
        .map((e) => color('[$emoji]$name $e'))
        .toList();
  }

  String stringifyMessage(dynamic message) {
    final finalMessage = message is Function ? message() : message;
    if (finalMessage is Map || finalMessage is Iterable) {
      final encoder = JsonEncoder.withIndent('  ', toEncodableFallback);
      return encoder.convert(finalMessage);
    } else {
      return finalMessage.toString();
    }
  }

  Object toEncodableFallback(dynamic object) {
    return object.toString();
  }
}

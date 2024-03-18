import 'package:logger/logger.dart' as log;
import 'package:note_sound/domain/models/logger/i_logger.dart';

final logger = Logger();

class Logger implements ILogger {
  final _logger = log.Logger(
    printer: log.SimplePrinter(),
  );

  Logger();

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

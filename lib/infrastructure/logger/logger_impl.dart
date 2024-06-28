import 'package:logger/logger.dart' as log;
import 'package:logger/web.dart';
import 'package:note_sound/domain/logger/i_logger.dart';

class CustomLogger implements ILogger {
  CustomLogger(this.name);

  final String name;
  late final _logger = log.Logger(
    printer: CustomPrinter(name: name),
  );

  @override
  void v(Object? message, [Object? error, StackTrace? stackTrace]) {
    _logger.t(message, error: error, stackTrace: stackTrace);
  }

  @override
  void d(Object? message, [Object? error, StackTrace? stackTrace]) {
    _logger.d(message, error: error, stackTrace: stackTrace);
  }

  @override
  void i(Object? message, [Object? error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  @override
  void w(Object? message, [Object? error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  @override
  void e(Object? message, [Object? error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  @override
  void f(Object? message, [Object? error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}

class CustomPrinter extends PrettyPrinter {
  final String name;
  final _emojis = const {
    Level.trace: '🔈',
    Level.debug: '🐛',
    Level.info: '💡',
    Level.warning: '⚠️',
    Level.error: '⛔',
    Level.fatal: '👾',
  };

  CustomPrinter({
    required this.name,
    super.stackTraceBeginIndex = 2,
    super.methodCount = 0,
    super.errorMethodCount = 12,
    super.lineLength = 0,
    super.colors = false,
    super.printEmojis = false,
    super.printTime = false,
    super.excludeBox = const {},
    super.noBoxingByDefault = false,
    super.excludePaths = const [],
    super.levelColors,
    super.levelEmojis,
  });

  @override
  List<String> log(LogEvent event) {
    final message = super.log(event);
    final colors = PrettyPrinter.defaultLevelColors[event.level]!;
    final emoji = _emojis[event.level]!;
    final time = DateTime.now().toUtc().toIso8601String();

    if (message.length == 3) {
      return [colors('[$emoji][$time][$name]${message[1].substring(1)}')];
    } else {
      return [
        '${message[0]}[$time][$name]',
        ...message.skip(1),
      ].map((e) => colors('[$emoji] $e')).toList();
    }
  }
}

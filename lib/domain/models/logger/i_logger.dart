abstract class ILogger {
  void v(Object message, {Object? error, StackTrace? stackTrace});
  void d(Object message, {Object? error, StackTrace? stackTrace});
  void i(Object message, {Object? error, StackTrace? stackTrace});
  void w(Object message, {Object? error, StackTrace? stackTrace});
  void e(Object message, {Object? error, StackTrace? stackTrace});
  void f(Object message, {Object? error, StackTrace? stackTrace});
}

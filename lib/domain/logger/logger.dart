//例外的にinfrastructureを参照する
import 'package:note_sound/domain/logger/i_logger.dart';
import 'package:note_sound/infrastructure/logger/logger_impl.dart';

mixin CLogger {
  late final ILogger logger = CustomLogger('$runtimeType');
}

ILogger buildLogger(String name) {
  return CustomLogger(name);
}

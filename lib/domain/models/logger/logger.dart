//例外的にinfrastructureを参照する
import 'package:note_sound/domain/models/logger/i_logger.dart';
import 'package:note_sound/infrastructure/logger/logger.dart';

mixin ClassLogger {
  late final ILogger logger = CustomLogger('$runtimeType');
}

ILogger buildLogger(String name) {
  return CustomLogger(name);
}

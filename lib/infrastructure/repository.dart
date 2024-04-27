import 'package:isar/isar.dart';
import 'package:note_sound/domain/error/implementation_error.dart';
import 'package:note_sound/infrastructure/quiz/db_quiz_master_satate.dart';
import 'package:path_provider/path_provider.dart';

abstract class Repository {
  Isar? _isar;

  Isar get isar {
    final isar = _isar;
    if (isar == null) {
      throw ImplementationError('initialization is required');
    } else {
      return isar;
    }
  }

  Repository(this._isar);

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = Isar.open(
      schemas: [
        DbQuizMasterStateSchema,
        DbQuizEntrySchema,
      ],
      directory: dir.path,
    );
  }

  Future<void> dispose() async {
    _isar?.close();
    _isar = null;
  }
}

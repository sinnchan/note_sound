import 'package:note_sound/domain/models/logger/logger.dart';
import 'package:note_sound/domain/models/note/note.dart';
import 'package:note_sound/domain/models/pcm/player/pcm_player_options.dart';
import 'package:note_sound/infrastructure/pcm/pcm_player.dart';
import 'package:note_sound/presentation/shared_providers/pcm_synthesizer_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pcm_player_provider.g.dart';

final _logger = buildLogger('PcmPlayerProvider');

@riverpod
Future<PcmPlayer> pcmPlayer(PcmPlayerRef ref) async {
  const option = PcmPlayerOption();
  final player = PcmPlayer(option);

  final (synth, _) = await (
    ref.watch(pcmSynthesizerProvider.future),
    player.init(),
  ).wait;

  void noteCallback(Note? note, bool noteOn) {
    player.feed(synth.render(option.bufferSize.size));
  }

  synth.setNoteOnCallback(noteCallback);

  player.setFeedCallback((cnt) {
    _logger.v('feed callback: $cnt');
    player.feed(synth.render(option.bufferSize.size));
  });

  ref.onDispose(() {
    synth.removeCallback(noteCallback);
    player.dispose();
  });

  return player;
}

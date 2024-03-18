import 'package:note_sound/domain/models/pcm/player/pcm_player_options.dart';
import 'package:note_sound/infrastructure/logger/logger.dart';
import 'package:note_sound/infrastructure/pcm/pcm_player.dart';
import 'package:note_sound/presentation/shared_providers/synthesizer_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pcm_player_provider.g.dart';

@riverpod
Future<PcmPlayer> pcmPlayer(PcmPlayerRef ref) async {
  final player = PcmPlayer(const PcmPlayerOption());

  final (synth, _) = await (
    ref.watch(synthesizerProvider.future),
    player.init(),
  ).wait;

  player.setFeedCallback((count) {
    logger.d('FEED CALLBACK: $count');
    final byteData = synth.render(1000);
    player.feed(byteData);
  });

  ref.onDispose(player.dispose);

  return player;
}

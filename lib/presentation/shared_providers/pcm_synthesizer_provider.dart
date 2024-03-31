import 'package:note_sound/domain/models/pcm/synthesizer/pcm_synthesizer_options.dart';
import 'package:note_sound/domain/models/pcm/value/pcm_sound_fonts.dart';
import 'package:note_sound/infrastructure/pcm/pcm_synthesizer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'pcm_synthesizer_provider.g.dart';

@riverpod
Future<PcmSynthesizer> pcmSynthesizer(PcmSynthesizerRef ref) async {
  final synth = PcmSynthesizer(
    const PcmSynthesizerOption(
      sf: PcmSoundFont.korgIS50Marimboyd1115,
    ),
  );

  await synth.init();
  ref.onDispose(synth.dispose);
  return synth;
}

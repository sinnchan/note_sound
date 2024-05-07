import 'dart:typed_data';

import 'package:flutter_pcm_sound/flutter_pcm_sound.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_sound/domain/logger/logger.dart';
import 'package:note_sound/infrastructure/sound/player/player_options.dart';
import 'package:note_sound/domain/sound/note.dart';
import 'package:note_sound/infrastructure/sound/synthesizer/synthesizer.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player.freezed.dart';
part 'player.g.dart';

final _providerLogger = buildLogger('SoundPlayerProvider');

@freezed
class SoundPlayerState with _$SoundPlayerState {
  const factory SoundPlayerState({
    @Default(false) bool isPlaying,
  }) = _SoundPlayerState;

  factory SoundPlayerState.fromJson(Map<String, Object?> json) =>
      _$SoundPlayerStateFromJson(json);
}

@riverpod
class SoundPlayer extends _$SoundPlayer with CLogger {
  @override
  Future<SoundPlayerState> build({SoundPlayerOption? option}) async {
    logger.d('build()');

    final opt = option ?? const SoundPlayerOption();
    logger.v(opt.toJson());

    FlutterPcmSound.setLogLevel(LogLevel.error);
    await FlutterPcmSound.setup(
      sampleRate: opt.sampleRate.value,
      channelCount: 1,
    );
    await setFeedThreshold(opt.bufferSize.size);

    final synth = await ref.watch(synthesizerProvider.future);

    void noteCallback(Note? note, bool noteOn) {
      feed(synth.render(opt.bufferSize.size));
    }

    synth.setNoteOnCallback(noteCallback);

    setFeedCallback((count) {
      feed(synth.render(opt.bufferSize.size));
    });

    ref.onDispose(() {
      synth.removeCallback(noteCallback);
      dispose();
    });

    await play();

    return const SoundPlayerState(isPlaying: true);
  }

  Future<void> dispose() async {
    logger.d('dispose()');
    await pause();
    await reset();
    await FlutterPcmSound.release();
  }

  Future<void> play() {
    logger.d('play()');
    state = state.whenData(
      (state) => state.copyWith(isPlaying: true),
    );
    return FlutterPcmSound.play();
  }

  Future<void> pause() {
    logger.d('pause()');
    state = state.whenData(
      (state) => state.copyWith(isPlaying: false),
    );
    return FlutterPcmSound.pause();
  }

  Future<void> reset() {
    logger.d('reset()');
    state = state.whenData(
      (state) => state.copyWith(isPlaying: false),
    );
    return FlutterPcmSound.clear();
  }

  Future<void> feed(ByteData data) {
    return FlutterPcmSound.feed(PcmArrayInt16(bytes: data));
  }

  Future<void> setFeedThreshold(int threshold) {
    logger.d('setFeedThreshold(threshold: $threshold)');
    return FlutterPcmSound.setFeedThreshold(threshold);
  }

  void setFeedCallback(void Function(int sampleCount) callback) {
    logger.d('setFeedCallback()');
    FlutterPcmSound.setFeedCallback(callback);
  }
}

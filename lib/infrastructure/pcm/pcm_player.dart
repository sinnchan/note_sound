import 'dart:typed_data';

import 'package:flutter_pcm_sound/flutter_pcm_sound.dart';
import 'package:note_sound/domain/models/logger/logger.dart';
import 'package:note_sound/domain/models/pcm/player/i_pcm_player.dart';

class PcmPlayer extends IPcmPlayer with ClassLogger {
  PcmPlayer(super.option);

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  @override
  Future<void> init() async {
    logger.d('init()');
    logger.v(option.toJson());
    _isPlaying = false;
    await FlutterPcmSound.setup(
      sampleRate: option.sampleRate.value,
      channelCount: 1,
    );
    await setFeedThreshold(option.bufferSize.size);
  }

  @override
  Future<void> dispose() async {
    logger.d('dispose()');
    await pause();
    await reset();
    await FlutterPcmSound.release();
  }

  @override
  Future<void> play() {
    logger.d('play()');
    _isPlaying = true;
    return FlutterPcmSound.play();
  }

  @override
  Future<void> pause() {
    logger.d('pause()');
    _isPlaying = false;
    return FlutterPcmSound.pause();
  }

  @override
  Future<void> reset() {
    logger.d('reset()');
    _isPlaying = false;
    return FlutterPcmSound.clear();
  }

  @override
  Future<void> feed(ByteData data) {
    logger.d('feed(bytes: ${data.lengthInBytes})');
    return FlutterPcmSound.feed(PcmArrayInt16(bytes: data));
  }

  @override
  Future<void> setFeedThreshold(int threshold) {
    logger.d('setFeedThreshold(threshold: $threshold)');
    return FlutterPcmSound.setFeedThreshold(threshold);
  }

  @override
  void setFeedCallback(void Function(int sampleCount) callback) {
    logger.d('setFeedCallback()');
    FlutterPcmSound.setFeedCallback(callback);
  }
}

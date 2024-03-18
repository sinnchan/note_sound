import 'dart:typed_data';

import 'package:flutter_pcm_sound/flutter_pcm_sound.dart';
import 'package:note_sound/domain/models/pcm/player/i_pcm_player.dart';
import 'package:note_sound/infrastructure/logger/logger.dart';

class PcmPlayer extends IPcmPlayer {
  PcmPlayer(super.option);

  @override
  Future<void> init() async {
    logger.d('$runtimeType.init()');
    await FlutterPcmSound.setup(
      sampleRate: option.sampleRate.value,
      channelCount: 1,
    );
    FlutterPcmSound.setFeedThreshold(1000);
  }

  @override
  Future<void> dispose() async {
    logger.d('$runtimeType.dispose()');
    // await pause();
    // await reset();
    await FlutterPcmSound.release();
  }

  @override
  Future<void> play() {
    logger.d('$runtimeType.play()');
    return FlutterPcmSound.play();
  }

  @override
  Future<void> pause() {
    logger.d('$runtimeType.pause()');
    return FlutterPcmSound.pause();
  }

  @override
  Future<void> reset() {
    logger.d('$runtimeType.reset()');
    return FlutterPcmSound.clear();
  }

  @override
  Future<void> feed(ByteData data) {
    logger.d('$runtimeType.feed()');
    return FlutterPcmSound.feed(PcmArrayInt16(bytes: data));
  }

  @override
  void setFeedCallback(void Function(int sampleCount) callback) {
    logger.d('$runtimeType.setFeedCallback()');
    FlutterPcmSound.setFeedCallback(callback);
  }
}

import 'dart:typed_data';

import 'package:note_sound/domain/models/pcm/player/pcm_player_options.dart';

abstract class IPcmPlayer {
  final PcmPlayerOption option;

  IPcmPlayer(this.option);

  Future<void> init();
  Future<void> dispose();

  Future<void> play();
  Future<void> pause();
  Future<void> reset();

  Future<void> feed(ByteData data);
  Future<void> setFeedThreshold(int threshold);
  void setFeedCallback(void Function(int sampleCount) callback);
}

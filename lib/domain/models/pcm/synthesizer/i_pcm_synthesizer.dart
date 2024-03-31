import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:note_sound/domain/models/note/note.dart';
import 'package:note_sound/domain/models/pcm/synthesizer/pcm_synthesizer_options.dart';
import 'package:note_sound/domain/models/pcm/value/pcm_velocity.dart';

/// [Note] == null → note off all
typedef NoteOnCallback = void Function(Note?, bool);

abstract class IPcmSynthesizer {
  final PcmSynthesizerOption option;
  final Set<NoteOnCallback> _callbacks = {};

  IPcmSynthesizer(this.option);

  Future<void> init();
  Future<void> dispose();

  ByteData render(int sampleCount);

  @mustCallSuper
  void noteOn(Note note, PcmVelocity velocity) {
    for (final c in _callbacks) {
      c(note, true);
    }
  }

  @mustCallSuper
  void noteOff(Note note) {
    for (final c in _callbacks) {
      c(note, false);
    }
  }

  @mustCallSuper
  void noteOffAll() {
    for (final c in _callbacks) {
      c(null, false);
    }
  }

  @mustCallSuper
  void setNoteOnCallback(NoteOnCallback callback) {
    _callbacks.add(callback);
  }

  @mustCallSuper
  void removeCallback(NoteOnCallback callback) {
    _callbacks.remove(callback);
  }
}

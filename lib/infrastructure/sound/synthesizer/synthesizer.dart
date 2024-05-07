import 'package:collection/collection.dart';
import 'package:dart_melty_soundfont/dart_melty_soundfont.dart' as lib;
import 'package:dart_scope_functions/dart_scope_functions.dart';
import 'package:flutter/services.dart';
import 'package:note_sound/domain/logger/logger.dart';
import 'package:note_sound/domain/sound/note.dart';
import 'package:note_sound/domain/sound/velocity.dart';
import 'package:note_sound/gen/assets.gen.dart';
import 'package:note_sound/infrastructure/sound/synthesizer/synthesizer_options.dart';
import 'package:note_sound/infrastructure/sound/value/sound_fonts.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'synthesizer.g.dart';

/// [Note] == null → note off all
typedef NoteOnCallback = void Function(Note?, bool);

@riverpod
Future<Synthesizer> synthesizer(SynthesizerRef ref) async {
  final synth = Synthesizer(
    const SynthesizerOption(
      sf: SoundFonts.korgIS50Marimboyd1115,
    ),
  );

  await synth.init();
  ref.onDispose(synth.dispose);
  return synth;
}

class Synthesizer with CLogger {
  lib.Synthesizer? _synthesizer;
  final SynthesizerOption option;
  final Set<NoteOnCallback> _callbacks = {};
  final _bufferPool = <lib.ArrayInt16>{};

  Synthesizer(this.option);

  Future<void> init() async {
    logger.d('init()');
    logger.v(option.toJson());

    if (_synthesizer != null) {
      logger.w('already initialized.');
      return;
    }

    final synthesizer = await getSoundFontData(option.sf).then((sfData) {
      return lib.Synthesizer.loadByteData(
        sfData,
        lib.SynthesizerSettings(
          sampleRate: option.sampleRate.value,
          blockSize: option.blockSize.value,
        ),
      );
    });

    _synthesizer = synthesizer;
  }

  Future<void> dispose() async {
    logger.d('dispose()');
    _synthesizer?.reset();
    _synthesizer = null;
  }

  void noteOn(Note note, Velocity velocity, [int channel = 0]) {
    logger.d('noteOn($note, $velocity, channel: $channel)');
    _synthesizer?.noteOn(
      channel: channel,
      key: note.number,
      velocity: velocity.value,
    );
    _notifyListeners(note: note, on: true);
  }

  void notesOn(Set<Note> notes, Velocity velocity, [int channel = 0]) {
    logger.d('notesOn($notes, $velocity, channel: $channel)');
    for (final note in notes) {
      noteOn(note, velocity);
    }
  }

  void noteOff(Note note, [int channel = 0]) {
    logger.d('noteOff(note: $note, channel: $channel)');
    _synthesizer?.noteOff(
      channel: channel,
      key: note.number,
    );
    _notifyListeners(note: note, on: false);
  }

  void notesOff(Set<Note> notes, [int channel = 0]) {
    logger.d('notesOff(notes: $notes, channel: $channel)');
    for (final note in notes) {
      noteOff(note);
    }
  }

  void noteOffAll([int channel = 0]) {
    logger.d('noteOffAll()');
    _synthesizer?.noteOffAll(channel: channel);
    _notifyListeners(note: null, on: false);
  }

  ByteData render([int? sampleCount]) {
    var buffer = _bufferPool.firstWhereOrNull((e) {
      return e.bytes.lengthInBytes == sampleCount;
    });

    buffer ??= lib.ArrayInt16.zeros(
      numShorts: sampleCount ?? option.bufferSize.size,
    ).also(_bufferPool.add);

    _synthesizer?.renderMonoInt16(buffer);

    return buffer.bytes;
  }

  void setNoteOnCallback(NoteOnCallback callback) {
    _callbacks.add(callback);
  }

  void removeCallback(NoteOnCallback callback) {
    _callbacks.remove(callback);
  }

  Future<ByteData> getSoundFontData(SoundFonts sf) async {
    logger.d('getSoundFontData(sf: ${sf.name})');

    return rootBundle.load(
      switch (sf) {
        SoundFonts.korgIS50Marimboyd1115 =>
          Assets.soundFonts.korgIS50Marimboyd1115,
      },
    );
  }

  void _notifyListeners({required Note? note, required bool on}) {
    for (final cb in _callbacks) {
      cb(note, true);
    }
  }
}

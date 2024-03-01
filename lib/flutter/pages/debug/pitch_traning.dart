import 'package:flutter/material.dart';
import 'package:note_sound/flutter/util/l10n_mixin.dart';

class DebugPitchTraningPage extends StatelessWidget {
  const DebugPitchTraningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.pitch_traning),
      ),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: const [],
      ),
    );
  }
}

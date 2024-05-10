import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_sound/presentation/ui/application.dart';

void main() {
  runApp(ProviderScope(child: Application()));
}

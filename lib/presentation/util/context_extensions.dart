import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  T read<T>(ProviderListenable<T> provider) {
    return ProviderScope.containerOf(this).read(provider);
  }
}

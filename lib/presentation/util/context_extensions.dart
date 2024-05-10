import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  T read<T>(ProviderListenable<T> provider) {
    return ProviderScope.containerOf(this).read(provider);
  }

  /// ConsumerWidgetのcontextのみ
  T watch<T>(ProviderListenable<T> provider) {
    return (this as WidgetRef).watch(provider);
  }

  void listen<T>(
    ProviderListenable<T> provider,
    void Function(T?, T) listener, {
    void Function(Object, StackTrace)? onError,
  }) {
    ProviderScope.containerOf(this).listen(
      provider,
      listener,
      onError: onError,
    );
  }
}

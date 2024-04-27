import 'package:hooks_riverpod/hooks_riverpod.dart';

extension AsyncValueExt<T> on AsyncValue<T> {
  AsyncValue<T> selectMap({
    AsyncValue<T> Function(AsyncData<T>)? data,
    AsyncValue<T> Function(AsyncError<T>)? error,
    AsyncValue<T> Function(AsyncLoading<T>)? loading,
  }) {
    return map(
      data: data ?? (d) => d,
      error: error ?? (e) => e,
      loading: loading ?? (l) => l,
    );
  }

  Map<String, dynamic> toJson(
    Map<String, dynamic> Function(T data) convert,
  ) {
    return map(
      data: (d) => convert(d.value),
      error: (e) => {
        'error': e.error,
        'stack_trace': e.stackTrace.toString().split('\n'),
      },
      loading: (l) => {'loading': l},
    );
  }
}

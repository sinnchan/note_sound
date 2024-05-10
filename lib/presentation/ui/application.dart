import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:note_sound/domain/logger/logger.dart';
import 'package:note_sound/presentation/providers/correct_provider.dart';
import 'package:note_sound/presentation/route/router.dart';

final seedColorProvider = StateProvider((ref) {
  return Colors.green;
});

class Application extends HookConsumerWidget with CLogger {
  Application({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seedColor = ref.watch(seedColorProvider);
    final animCtrl = useAnimationController(
      duration: const Duration(milliseconds: 700),
    );

    _handleAnimController(ref, animCtrl);

    return AnimatedBuilder(
      animation: animCtrl,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Note Sound',
          themeAnimationDuration: Duration.zero,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: _createScheme(
              ref,
              animCtrl,
              ColorScheme.fromSeed(
                seedColor: seedColor,
              ),
            ),
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: _createScheme(
              ref,
              animCtrl,
              ColorScheme.fromSeed(
                seedColor: seedColor,
                brightness: Brightness.dark,
              ),
            ),
          ),
          localizationsDelegates: L10n.localizationsDelegates,
          supportedLocales: L10n.supportedLocales,
          routerConfig: ref.watch(goRouterProvider),
        );
      },
    );
  }

  (Animation, Animation) createAnim(
    WidgetRef ref,
    AnimationController ctrl,
    Color base,
  ) {
    final seed = ref.watch(seedColorProvider);
    final correct = ColorTween(
      begin: seed != Colors.green ? Colors.green : Colors.blue,
      end: base,
    ).chain(CurveTween(curve: Curves.easeInSine)).animate(ctrl);
    final wrong = ColorTween(
      begin: seed != Colors.red ? Colors.red : Colors.pink,
      end: base,
    ).chain(CurveTween(curve: Curves.easeOutSine)).animate(ctrl);
    return (correct, wrong);
  }

  ColorScheme _createScheme(
    WidgetRef ref,
    AnimationController ctrl,
    ColorScheme base,
  ) {
    final correct = ref.watch(correctProvider)?.correct;
    final (correctAnim, wrongAnim) = createAnim(ref, ctrl, base.primary);

    return base.copyWith(
      primary: correct == null
          ? null
          : correct
              ? correctAnim.value
              : wrongAnim.value,
    );
  }

  void _handleAnimController(
    WidgetRef ref,
    AnimationController animCtrl,
  ) {
    ref.listen(
      correctProvider,
      (prev, next) {
        if (next == null) return;
        animCtrl.reset();
        animCtrl.forward();
      },
    );
    useEffect(
      () {
        listener(AnimationStatus status) {
          if (status == AnimationStatus.completed) {
            ref.read(correctProvider.notifier).state = null;
          }
        }

        animCtrl.addStatusListener(listener);
        return () => animCtrl.removeStatusListener(listener);
      },
      [animCtrl],
    );
  }
}

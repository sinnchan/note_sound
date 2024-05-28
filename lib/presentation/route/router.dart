import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:note_sound/domain/logger/logger.dart';
import 'package:note_sound/domain/quiz/entities/quiz_master.dart';
import 'package:note_sound/domain/quiz/value/quiz_master_values.dart';
import 'package:note_sound/presentation/ui/pages/debug/debug_pitch_traning_page.dart';
import 'package:note_sound/presentation/ui/pages/debug/debug_select_notes_page.dart';
import 'package:note_sound/presentation/ui/pages/debug/debug_sound_page.dart';
import 'package:note_sound/presentation/ui/pages/debug/debug_top_page.dart';
import 'package:note_sound/presentation/ui/pages/quiz/page.dart';
import 'package:note_sound/presentation/ui/pages/top_page.dart';
import 'package:note_sound/presentation/util/context_extensions.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'router.g.dart';

@Riverpod(keepAlive: true)
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    routes: $appRoutes,
    initialLocation: '/',
    debugLogDiagnostics: true,
  );
}

@TypedGoRoute<TopRoute>(
  path: '/',
  routes: [
    TypedGoRoute<NoteRoute>(
      path: 'notes',
      routes: [
        TypedGoRoute<NoteLessonRoute>(
          path: 'lesson/:number',
        ),
      ],
    ),
    TypedGoRoute<DebugTopRoute>(
      path: 'debug',
      routes: [
        TypedGoRoute<DebugSoundPlayerRoute>(
          path: 'sound_player',
        ),
        TypedGoRoute<DebugPitchTraningRoute>(
          path: 'pitch_traning',
          routes: [
            TypedGoRoute<DebugSelectNotesRoute>(
              path: 'select_notes',
            ),
          ],
        ),
      ],
    ),
  ],
)
class TopRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TopPage();
  }
}

class NoteRoute extends GoRouteData with CLogger {
  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) async {
    final masterState = await context.read(quizMasterProvider.future);

    if (masterState.entries.isEmpty) {
      // TODO: 正しいpathに修正
      final location = DebugPitchTraningRoute().location;
      logger.i('redirect to $location');
      return location;
    }

    return null;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return QuizPage(type: QuizType.notes);
  }
}

class NoteLessonRoute extends GoRouteData with CLogger {
  final int number;

  NoteLessonRoute(this.number);

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) async {
    final masterState = await context.read(quizMasterProvider.future);

    if (masterState.entries.isEmpty) {
      // TODO: 正しいpathに修正
      final location = DebugPitchTraningRoute().location;
      logger.i('redirect to $location');
      return location;
    }

    return null;
  }

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return QuizPage(type: QuizType.notes);
  }
}

class DebugTopRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DebugTopPage();
  }
}

class DebugSoundPlayerRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DebugSoundPlayerPage();
  }
}

class DebugPitchTraningRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DebugPitchTraningPage();
  }
}

class DebugSelectNotesRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return DebugSelectNotesPage();
  }
}

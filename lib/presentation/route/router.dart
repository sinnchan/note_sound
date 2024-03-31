import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:note_sound/presentation/ui/pages/debug/debug_pitch_traning_page.dart';
import 'package:note_sound/presentation/ui/pages/debug/debug_select_notes_page.dart';
import 'package:note_sound/presentation/ui/pages/debug/debug_sound_page.dart';
import 'package:note_sound/presentation/ui/pages/debug/debug_top_page.dart';
import 'package:note_sound/presentation/ui/pages/top_page.dart';

part 'router.g.dart';

@TypedGoRoute<TopRoute>(
  path: '/',
  routes: [
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
    )
  ],
)
class TopRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TopPage();
  }
}

class DebugTopRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DebugTopPage();
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
    return const DebugSelectNotesPage();
  }
}

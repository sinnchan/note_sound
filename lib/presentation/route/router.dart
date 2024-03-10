import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:note_sound/presentation/ui/pages/debug/pitch_traning.dart';
import 'package:note_sound/presentation/ui/pages/debug/top.dart';
import 'package:note_sound/presentation/ui/pages/top_page.dart';

part 'router.g.dart';

@TypedGoRoute<TopRoute>(
  path: '/',
  routes: [
    TypedGoRoute<DebugTopRoute>(
      path: 'debug',
      routes: [
        TypedGoRoute<DebugPitchTraningRoute>(
          path: 'pitch_traning',
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

class DebugPitchTraningRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DebugPitchTraningPage();
  }
}

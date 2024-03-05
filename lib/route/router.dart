import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:note_sound/flutter/pages/top_page.dart';

part 'router.g.dart';

@TypedGoRoute<TopRoute>(path: '/')
@immutable
class TopRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const TopPage();
  }
}

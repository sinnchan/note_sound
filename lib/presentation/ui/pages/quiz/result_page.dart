// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class NoteQuizResultPage extends HookConsumerWidget {
  const NoteQuizResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              '結果',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 24),
            Text(
              '10/10',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

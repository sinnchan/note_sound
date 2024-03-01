import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/l10n_ja.dart';

extension L10nMixin on BuildContext {
  L10n get l10n => L10n.of(this) ?? L10nJa();
}

import 'dart:async';

import 'package:args/command_runner.dart';

/// A command that generates a LCOV coverage report.
final class CoverageCommand extends Command<void> {
  @override
  String get name => 'coverage';

  @override
  String get description => 'Generate a LCOV coverage report.';

  @override
  FutureOr<void> run() async {}
}

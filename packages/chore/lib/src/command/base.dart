import 'dart:async';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:chore/src/context.dart';
import 'package:chore/src/environment.dart';
import 'package:chore/src/runner.dart';
import 'package:meta/meta.dart';

/// A base command.
abstract base class BaseCommand extends Command<void> {
  /// @nodoc
  BaseCommand(this.context, this.environment);

  /// The context for the command.
  @protected
  final Context context;

  /// The environment for the command.
  @protected
  final Environment environment;

  /// The top-level results from the command-line arguments.
  @protected
  ArgResults get topLevelResults {
    if (runner case final Runner runner) {
      return runner.topLevelResults;
    }
    throw StateError('The parent command runner must be a `Runner`.');
  }

  @override
  Future<void> run();
}

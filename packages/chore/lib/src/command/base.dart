import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:chore/src/context.dart';
import 'package:chore/src/environment.dart';
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

  @override
  Future<void> run();
}

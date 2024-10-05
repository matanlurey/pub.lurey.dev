import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';

/// Entry point for the command-line interface.
final class Runner extends CommandRunner<void> {
  /// Creates a command runner with the default commands.
  factory Runner() => Runner._([]);

  /// Creates a command runner with the given [commands].
  ///
  /// This constructor is intended for testing only.
  @visibleForTesting
  factory Runner.withCommands(Iterable<Command<void>> commands) = Runner._;

  Runner._(
    Iterable<Command<void>> commands,
  ) : super('dev', 'A tool working in the pub.lurey.dev monorepo.') {
    commands.forEach(addCommand);
  }
}

import 'package:args/command_runner.dart';
import 'package:chore/chore.dart';
import 'package:dev/src/commands/generate.dart';
import 'package:meta/meta.dart';

/// Entry point for the command-line interface.
final class Runner extends CommandRunner<void> {
  /// Creates a command runner with the default commands.
  factory Runner(
    Context context,
    Environment environment, {
    required Iterable<String> availablePackages,
  }) {
    return Runner._(
      [
        Check(context, environment),
        Test(context, environment),
        Generate(context, environment),
      ],
      availablePackages: availablePackages,
    );
  }

  /// Creates a command runner with the given [commands].
  ///
  /// This constructor is intended for testing only.
  @visibleForTesting
  factory Runner.withCommands(
    Iterable<Command<void>> commands, {
    required Iterable<String> availablePackages,
  }) = Runner._;

  Runner._(
    Iterable<Command<void>> commands, {
    required Iterable<String> availablePackages,
  }) : super('dev', 'A tool working in the pub.lurey.dev monorepo.') {
    commands.forEach(addCommand);
    Context.registerArgs(argParser, packages: availablePackages);
  }
}

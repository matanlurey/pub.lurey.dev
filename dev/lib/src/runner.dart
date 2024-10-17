import 'package:args/command_runner.dart';
import 'package:dev/src/commands/check.dart';
import 'package:dev/src/commands/coverage.dart';
import 'package:dev/src/commands/generate.dart';
import 'package:meta/meta.dart';

/// Entry point for the command-line interface.
final class Runner extends CommandRunner<void> {
  /// Creates a command runner with the default commands.
  factory Runner({required Iterable<String> packages}) {
    return Runner._(
      [
        CheckCommand(),
        CoverageCommand(),
        GenerateCommand(),
      ],
      packages: packages,
    );
  }

  /// Creates a command runner with the given [commands].
  ///
  /// This constructor is intended for testing only.
  @visibleForTesting
  factory Runner.withCommands(
    Iterable<Command<void>> commands, {
    required Iterable<String> packages,
  }) = Runner._;

  Runner._(
    Iterable<Command<void>> commands, {
    required Iterable<String> packages,
  }) : super('dev', 'A tool working in the pub.lurey.dev monorepo.') {
    commands.forEach(addCommand);
    argParser.addMultiOption(
      'packages',
      abbr: 'p',
      help: ''
          'Configuration to use for the command.\n\n'
          'If omitted, each configuration is used.\n\nOptions:',
      allowed: packages,
    );
  }
}

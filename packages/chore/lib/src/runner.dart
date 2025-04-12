import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:chore/chore.dart';
import 'package:chore/src/command/dartdoc.dart';
import 'package:chore/src/command/publish.dart';
import 'package:chore/src/command/setup.dart';
import 'package:lore/lore.dart';
import 'package:meta/meta.dart';

/// Entry point for the command-line interface.
final class Runner extends CommandRunner<void> {
  /// Creates a command runner with the default commands.
  factory Runner(
    Context context,
    Environment environment, {
    String name = 'chore',
    String description = 'A repository maintenance tool.',
    Iterable<Command<void>> Function(Context, Environment)? commands,
  }) {
    return Runner._(
      [
        Check(context, environment),
        Coverage(context, environment),
        Dartdoc(context, environment),
        Publish(context, environment),
        Setup(context, environment),
        Test(context, environment),
        ...?commands?.call(context, environment),
      ]..sort((a, b) => a.name.compareTo(b.name)),
      availablePackages: context.allPossiblePackages,
      context: context,
      name: name,
      description: description,
    );
  }

  /// Creates a command runner with the given [commands].
  ///
  /// This constructor is intended for testing only.
  @visibleForTesting
  factory Runner.withCommands(
    Iterable<Command<void>> commands, {
    required Iterable<String> availablePackages,
    required Context context,
    required String name,
    required String description,
  }) = Runner._;

  Runner._(
    Iterable<Command<void>> commands, {
    required Iterable<String> availablePackages,
    required Context context,
    required String name,
    required String description,
  }) : super(name, description) {
    commands.forEach(addCommand);

    argParser.addFlag(
      'verbose',
      abbr: 'v',
      help: 'Whether to output verbose logging.',
      negatable: false,
    );
    Context.registerArgs(
      argParser,
      packages: availablePackages,
      verbose: context.logLevel == Level.debug,
    );
  }

  @override
  final argParser = ArgParser(allowTrailingOptions: false);
}

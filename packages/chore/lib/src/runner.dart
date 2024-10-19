import 'package:args/command_runner.dart';
import 'package:args/src/arg_results.dart';
import 'package:chore/chore.dart';
import 'package:meta/meta.dart';

/// Entry point for the command-line interface.
final class Runner extends CommandRunner<void> {
  /// Creates a command runner with the default commands.
  factory Runner(
    Context context,
    Environment environment, {
    required Iterable<String> availablePackages,
    String name = 'chore',
    String description = 'A repository maintenance tool.',
    Iterable<Command<void>> Function(Context, Environment)? commands,
  }) {
    return Runner._(
      [
        Check(context, environment),
        Coverage(context, environment),
        Test(context, environment),
        ...?commands?.call(context, environment),
      ],
      availablePackages: availablePackages,
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
    required String name,
    required String description,
  }) = Runner._;

  Runner._(
    Iterable<Command<void>> commands, {
    required Iterable<String> availablePackages,
    required String name,
    required String description,
  }) : super(name, description) {
    commands.forEach(addCommand);
    Context.registerArgs(argParser, packages: availablePackages);
  }

  /// The top-level results from the command-line arguments.
  late final ArgResults topLevelResults;

  @override
  Future<void> runCommand(ArgResults topLevelResults) {
    this.topLevelResults = topLevelResults;
    return super.runCommand(topLevelResults);
  }
}

import 'dart:io' as io;

import 'package:args/command_runner.dart';
import 'package:dev/src/commands/check.dart';
import 'package:dev/src/commands/coverage.dart';
import 'package:dev/src/commands/generate.dart';
import 'package:dev/src/parsers/pubspec_yaml.dart';
import 'package:dev/src/utils/find_root_dir.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// Entry point for the command-line interface.
final class Runner extends CommandRunner<void> {
  /// Creates a command runner with the default commands.
  factory Runner() {
    return Runner._([
      CheckCommand(),
      CoverageCommand(),
      GenerateCommand(),
    ]);
  }

  /// Creates a command runner with the given [commands].
  ///
  /// This constructor is intended for testing only.
  @visibleForTesting
  factory Runner.withCommands(Iterable<Command<void>> commands) = Runner._;

  Runner._(
    Iterable<Command<void>> commands,
  ) : super('dev', 'A tool working in the pub.lurey.dev monorepo.') {
    commands.forEach(addCommand);

    final workspaceYamlFile = io.File(p.join(findRootDir(), 'pubspec.yaml'));
    final workspacePubspec = PubspecYaml.from(
      loadYamlDocument(workspaceYamlFile.readAsStringSync()),
    );
    argParser.addMultiOption(
      'config',
      abbr: 'c',
      help: ''
          'Configuration to use for the command.\n\n'
          'If omitted, each configuration is used.\n\nOptions:',
      allowed: workspacePubspec.workspace,
    );
  }
}

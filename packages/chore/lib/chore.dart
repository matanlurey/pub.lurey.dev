import 'dart:io' as io;

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:async/async.dart';
import 'package:chore/src/coverage.dart';
import 'package:chore/src/dartdoc.dart';
import 'package:path/path.dart' as p;

export 'package:chore/src/coverage.dart';
export 'package:chore/src/dartdoc.dart';

/// A simple task runner.
final class Chore extends CommandRunner<void> {
  /// Creates a new instance of [Chore].
  factory Chore({
    StringSink? stdout,
    StringSink? stderr,
    bool? isCI,
    Stream<void>? onTerminate,
  }) {
    onTerminate ??= StreamGroup.merge([
      io.ProcessSignal.sigint.watch(),
      io.ProcessSignal.sigterm.watch(),
    ]);
    final chore = Chore.withCommands(
      stdout: stdout,
      stderr: stderr,
      isCI: isCI ?? io.Platform.environment['CI'] == 'true',
      onTerminate: onTerminate,
      commands: [Dartdoc.new, Coverage.new],
    );
    return chore;
  }

  /// Creates a new instance of [Chore] without any commands.
  Chore.withCommands({
    bool isCI = false,
    StringSink? stdout,
    StringSink? stderr,
    this.onTerminate = const Stream.empty(),
    List<Command<void> Function(Chore)> commands = const [],
  })  : _commands = commands,
        stdout = stdout ?? io.stdout,
        stderr = stderr ?? io.stderr,
        super('chore', 'A simple task runner') {
    argParser
      ..addOption(
        'working-directory',
        abbr: 'w',
        help: ''
            'The working directory for the command. Defaults to the first '
            'directory containing a pubspec.yaml file, traversing up from the '
            'current directory.',
      )
      ..addFlag(
        'ci',
        help: 'Whether the command is running in a CI environment',
        defaultsTo: isCI,
      );
  }

  /// The standard output sink.
  final StringSink stdout;

  /// The standard error sink.
  final StringSink stderr;

  /// The working directory for the command runner.
  String get workingDirectory => _workingDirectory;
  late final String _workingDirectory;

  /// Whether the command runner is running in a CI environment.
  bool get isCI => _isCI;
  late final bool _isCI;

  /// A stream that emits when the command runner should be terminated.
  final Stream<void> onTerminate;

  /// Commands to register with the command runner.
  final List<Command<void> Function(Chore)> _commands;

  @override
  ArgResults parse(Iterable<String> args) {
    // Do an initial parse to get required options.
    final results = super.parse(args);
    final workingDir = results.option('working-directory');
    _workingDirectory = p.normalize(workingDir ?? _findWorkingDir());
    _isCI = results.flag('ci');

    // Now add the commands.
    for (final command in _commands) {
      addCommand(command(this));
    }
    return super.parse(args);
  }

  static String _findWorkingDir() {
    var dir = io.Directory.current;
    while (!io.File(p.join(dir.path, 'pubspec.yaml')).existsSync()) {
      if (dir.path == dir.parent.path) {
        return io.Directory.current.path;
      }
      dir = dir.parent;
    }
    return dir.path;
  }
}

import 'dart:io' as io;

import 'package:chore/chore.dart';
import 'package:chore/src/command/check/dart_analyze.dart';
import 'package:chore/src/command/check/dart_format.dart';
import 'package:chore/src/command/check/pubspec_version_sync.dart';
import 'package:meta/meta.dart';

/// A command that checks the repository for issues.
final class Check extends BaseCommand {
  /// Creates a new check command.
  Check(
    super.context,
    super.environment, {
    Iterable<Checker> checkers = const [
      DartAnalyze(),
      DartFormat(),
      PubspecVersionSync(),
    ],
  }) : _checkers = checkers.toList() {
    argParser.addFlag('fix', help: 'Automatically fix issues when possible.');
  }

  final List<Checker> _checkers;

  @override
  String get name => 'check';

  @override
  String get description => 'Check the repository for issues.';

  @override
  Future<void> run() async {
    for (final package in await context.resolve(globalResults!)) {
      await _runForPackage(package);
    }
  }

  Future<void> _runForPackage(Package package) async {
    // Run each checker.
    for (final checker in _checkers) {
      io.stderr.writeln('Running ${checker.name} on ${package.name}...');
      final foundIssues = await checker.run(
        package,
        environment,
        fix: argResults!.flag('fix'),
      );
      if (foundIssues) {
        io.exitCode = 1;
        io.stderr.writeln('❌ ${checker.name}: found issues.');
      } else {
        io.stderr.writeln('✅ ${checker.name}: no issues found.');
      }
      io.stderr.writeln();
    }
  }
}

/// A check implementation.
@immutable
abstract base class Checker {
  // Not part of public API.
  // ignore: public_member_api_docs
  const Checker();

  /// Name of the checker.
  String get name;

  /// Executes the checker.
  ///
  /// If [fix] is `true`, the checker should attempt to fix issues.
  ///
  /// Returns `true` if the checker found issues, `false` otherwise.
  @useResult
  Future<bool> run(
    Package package,
    Environment environment, {
    bool fix = false,
  });
}

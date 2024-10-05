import 'package:args/command_runner.dart';

/// A command that checks a package for compliance.
final class CheckCommand extends Command<void> {
  @override
  String get name => 'check';

  @override
  String get description => 'Check a package for compliance.';
}

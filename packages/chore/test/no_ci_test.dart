import 'package:args/command_runner.dart';
import 'package:checks/checks.dart';
import 'package:chore/chore.dart';
import 'package:test/test.dart';

void main() {
  test('--ci enables CI', () async {
    final chore = Chore.withCommands();
    check(chore).has((a) => a.isCI, 'isCI').isFalse();

    await chore.run(['--ci']);
    check(chore).has((a) => a.isCI, 'isCI').isTrue();
  });

  test('--no-ci disables CI', () async {
    final chore = Chore.withCommands(isCI: true);
    check(chore).has((a) => a.isCI, 'isCI').isTrue();

    await chore.run(['--no-ci']);
    check(chore).has((a) => a.isCI, 'isCI').isFalse();
  });

  test('downstream command can read isCI', () async {
    final stdout = StringBuffer();
    final chore = Chore.withCommands(
      isCI: true,
      commands: [DummyCommand.new],
      stdout: stdout,
    );

    await chore.run(['dummy']);

    check(stdout.toString()).contains('isCI: true');
  });

  test('downstream command can have a disabled isCI', () async {
    final stdout = StringBuffer();
    final chore = Chore.withCommands(
      isCI: true,
      commands: [DummyCommand.new],
      stdout: stdout,
    );

    await chore.run(['--no-ci', 'dummy']);

    check(stdout.toString()).contains('isCI: false');
  });
}

final class DummyCommand extends Command<void> {
  DummyCommand(this._chore);
  final Chore _chore;

  @override
  String get name => 'dummy';

  @override
  String get description => 'A dummy command';

  @override
  Future<void> run() async {
    _chore.stdout.writeln('isCI: ${_chore.isCI}');
  }
}

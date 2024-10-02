import 'dart:convert';

import 'package:proc/proc.dart';
import 'package:test/test.dart';

import '_prelude.dart';

void main() {
  test('processId', () {
    final controller = ProcessController(processId: 1234);
    check(controller.processId).equals(1234);
    check(controller.process.processId).equals(1234);
  });

  test('default onKill', () async {
    final controller = ProcessController(processId: 1234);
    final process = controller.process;

    check(process.kill()).isTrue();
    check(controller.isClosed).isTrue();
    await check(process.exitCode).completes((s) => s.equals(ExitCode.failure));

    check(process.kill()).isFalse();
  });

  test('custom onKill', () async {
    late final ProcessController controller;
    controller = ProcessController(
      processId: 1234,
      onKill: expectAsync1((signal) {
        check(signal).equals(ProcessSignal.sigkill);
        controller.complete(ExitCode.failure);
        return true;
      }),
    );
    final process = controller.process;

    check(process.kill(ProcessSignal.sigkill)).isTrue();
    check(controller.isClosed).isTrue();
    await check(process.exitCode).completes((s) => s.equals(ExitCode.failure));

    check(process.kill()).isFalse();
  });

  test('default onInput', () {
    final controller = ProcessController(processId: 1234);
    final process = controller.process;

    check(() => process.stdin.add([1])).returnsNormally();
  });

  test('custom onInput', () {
    late final ProcessController controller;
    controller = ProcessController(
      processId: 1234,
      onInput: expectAsync1((event) {
        check(event).deepEquals([1]);
        controller.complete();
      }),
    );
    final process = controller.process;

    check(() => process.stdin.add([1])).returnsNormally();
  });

  test('throws if already closed', () {
    final controller = ProcessController(processId: 1234);

    check(controller.complete).returnsNormally();
    check(controller.isClosed).isTrue();

    check(controller.complete).throws<StateError>();
  });

  test('stdin default lineTerminator', () {
    final controller = ProcessController(
      processId: 1234,
      onInput: expectAsync1((event) {
        check(utf8.decode(event)).equals('test\n');
      }),
    );
    final process = controller.process;

    check(() => process.stdin.writeln('test')).returnsNormally();
  });

  test('stdin custom lineTerminator', () {
    final controller = ProcessController(
      processId: 1234,
      onInput: expectAsync1((event) {
        check(utf8.decode(event)).equals('test\r\n');
      }),
      lineTerminator: '\r\n',
    );
    final process = controller.process;

    check(() => process.stdin.writeln('test')).returnsNormally();
  });

  test('stdin writeCharCode', () {
    final controller = ProcessController(
      processId: 1234,
      onInput: expectAsync1((event) {
        check(utf8.decode(event)).equals('a');
      }),
    );
    final process = controller.process;

    check(() => process.stdin.writeCharCode(97)).returnsNormally();
  });

  test('stdin writeAll with separator', () async {
    final input = StringBuffer();
    final controller = ProcessController(
      processId: 1234,
      onInput: (event) {
        input.write(utf8.decode(event));
      },
    );
    final process = controller.process;

    check(() => process.stdin.writeAll(['a', 'b', 'c'], ',')).returnsNormally();

    await pumpEventQueue();
    check(input.toString()).equals('a,b,c');
  });

  test('stdin addStream', () async {
    final input = StringBuffer();
    final controller = ProcessController(
      processId: 1234,
      onInput: (event) {
        input.write(utf8.decode(event));
      },
    );
    final process = controller.process;

    check(
      () => process.stdin.addStream(
        Stream.fromIterable(
          [
            utf8.encode('a'),
            utf8.encode('b'),
            utf8.encode('c'),
          ],
        ),
      ),
    ).returnsNormally();

    await pumpEventQueue();
    check(input.toString()).equals('abc');
  });

  test('addStdout', () async {
    final controller = ProcessController(processId: 1234);
    final process = controller.process;

    controller.addStdout('Hello');
    await check(process.stdoutText).withQueue.emits((s) => s.equals('Hello'));
  });

  test('addStdoutLine', () async {
    final controller = ProcessController(processId: 1234);
    final process = controller.process;

    controller.addStdoutLine('Hello');
    await check(process.stdoutText).withQueue.emits((s) => s.equals('Hello\n'));
  });

  test('addStdoutLine with custom lineTerminator', () async {
    final controller = ProcessController(
      processId: 1234,
      lineTerminator: '\r\n',
    );
    final process = controller.process;

    controller.addStdoutLine('Hello');
    await check(process.stdoutText)
        .withQueue
        .emits((s) => s.equals('Hello\r\n'));
  });

  test('addStdoutBytes', () async {
    final controller = ProcessController(processId: 1234);
    final process = controller.process;

    controller.addStdoutBytes([1, 2, 3]);
    await check(process.stdout).withQueue.emits((s) => s.deepEquals([1, 2, 3]));
  });

  test('addStderr', () async {
    final controller = ProcessController(processId: 1234);
    final process = controller.process;

    controller.addStderr('Hello');
    await check(process.stderrText).withQueue.emits((s) => s.equals('Hello'));
  });

  test('addStderrBytes', () async {
    final controller = ProcessController(processId: 1234);
    final process = controller.process;

    controller.addStderrBytes([1, 2, 3]);
    await check(process.stderr).withQueue.emits((s) => s.deepEquals([1, 2, 3]));
  });

  test('addStderrLine', () async {
    final controller = ProcessController(processId: 1234);
    final process = controller.process;

    controller.addStderrLine('Hello');
    await check(process.stderrText).withQueue.emits((s) => s.equals('Hello\n'));
  });

  test('addStderrLine with custom lineTerminator', () async {
    final controller = ProcessController(
      processId: 1234,
      lineTerminator: '\r\n',
    );
    final process = controller.process;

    controller.addStderrLine('Hello');
    await check(process.stderrText)
        .withQueue
        .emits((s) => s.equals('Hello\r\n'));
  });

  test('cannot close stdin twice', () async {
    final controller = ProcessController(processId: 1234);
    final process = controller.process;

    check(() => process.stdin.close()).returnsNormally();
    check(() => process.stdin.close()).throws<StateError>();

    await check(process.stdin.done).completes();
  });
}

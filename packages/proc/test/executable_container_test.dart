import 'dart:async';
import 'dart:convert';

import 'package:proc/proc.dart';
import 'package:test/test.dart';

import '_prelude.dart';

void main() {
  test('default watch is an empty stream', () async {
    final container = ExecutableContainer();
    final host = container.createProcessHost();

    final stream = host.watch(ProcessSignal.sigint);
    await check(stream).withQueue.isDone();
  });

  test('watch can be overridden', () async {
    final controller = StreamController<void>();
    final container = ExecutableContainer(
      onWatch: (signal) => controller.stream,
    );
    final host = container.createProcessHost();

    final stream = host.watch(ProcessSignal.sigint);

    controller.add(null);
    await check(stream).withQueue.emits();
  });

  test('throws process not found exception', () async {
    final container = ExecutableContainer();
    final host = container.createProcessHost();

    await check(host.start('missing', [])).throws<ProcessException>();
  });

  test('stores and runs an executable', () async {
    final container = ExecutableContainer();
    container.setExecutable('echo', (start) {
      late final ProcessController controller;
      controller = ProcessController(
        processId: 1234,
        onInput: (data) {
          controller.addStdoutBytes(data);
        },
      );
      return controller.process;
    });

    final host = container.createProcessHost();
    final process = await host.start('echo', ['hello']);

    process.stdin.add(utf8.encode('Hello'));
    await pumpEventQueue();
    process.kill();

    await check(process.stdoutText).withQueue.emits((e) => e.equals('Hello'));
  });
}

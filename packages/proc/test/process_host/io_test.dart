@TestOn('vm')
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:path/path.dart' as p;
import 'package:proc/proc.dart';
import 'package:proc/src/impl/_io.dart' as impl;
import 'package:test/test.dart';

import '../_prelude.dart';

void main() {
  tearDown(impl.resetProcessHostWatch);

  test('isSupported', () {
    check(ProcessHost.isSupported).isTrue();
  });

  test('defaults', () {
    final host = ProcessHost();
    check(host)
      ..has((a) => a.stdoutEncoding, 'stdoutEncoding').equals(io.systemEncoding)
      ..has((a) => a.stderrEncoding, 'stderrEncoding').equals(io.systemEncoding)
      ..has(
        (a) => a.workingDirectory,
        'workingDirectory',
      ).equals(io.Directory.current.path)
      ..has((a) => a.runMode, 'runMode').equals(ProcessRunMode.normal)
      ..has((a) => a.environment, 'environment').deepEquals({})
      ..has(
        (a) => a.includeParentEnvironment,
        'includeParentEnvironment',
      ).isTrue()
      ..has((a) => a.runInShell, 'runInShell').isFalse();
  });

  test('copyWith (no path)', () {
    final host = ProcessHost().copyWith();
    check(host)
      ..has((a) => a.stdoutEncoding, 'stdoutEncoding').equals(io.systemEncoding)
      ..has((a) => a.stderrEncoding, 'stderrEncoding').equals(io.systemEncoding)
      ..has(
        (a) => a.workingDirectory,
        'workingDirectory',
      ).equals(io.Directory.current.path)
      ..has((a) => a.runMode, 'runMode').equals(ProcessRunMode.normal)
      ..has((a) => a.environment, 'environment').deepEquals({})
      ..has(
        (a) => a.includeParentEnvironment,
        'includeParentEnvironment',
      ).isTrue()
      ..has((a) => a.runInShell, 'runInShell').isFalse();
  });

  test('copyWith (every path)', () {
    final host = ProcessHost().copyWith(
      workingDirectory: 'foo',
      environment: {'foo': 'bar'},
      runMode: ProcessRunMode.detached,
      includeParentEnvironment: false,
      runInShell: true,
      stdoutEncoding: latin1,
      stderrEncoding: utf8,
    );
    check(host)
      ..has((a) => a.stdoutEncoding, 'stdoutEncoding').equals(latin1)
      ..has((a) => a.stderrEncoding, 'stderrEncoding').equals(utf8)
      ..has((a) => a.workingDirectory, 'workingDirectory').equals('foo')
      ..has((a) => a.runMode, 'runMode').equals(ProcessRunMode.detached)
      ..has((a) => a.environment, 'environment').deepEquals({'foo': 'bar'})
      ..has(
        (a) => a.includeParentEnvironment,
        'includeParentEnvironment',
      ).isFalse()
      ..has((a) => a.runInShell, 'runInShell').isTrue();
  });

  group('watch', () {
    test('sigint', () {
      impl.overrideProcessHostWatch(
        expectAsync1((signal) {
          check(signal).equals(io.ProcessSignal.sigint);
          return Stream.empty();
        }),
      );

      final host = ProcessHost();
      host.watch(ProcessSignal.sigint);
    });

    test('sigterm', () {
      impl.overrideProcessHostWatch(
        expectAsync1((signal) {
          check(signal).equals(io.ProcessSignal.sigterm);
          return Stream.empty();
        }),
      );

      final host = ProcessHost();
      host.watch(ProcessSignal.sigterm);
    });

    test('sigkill', () {
      impl.overrideProcessHostWatch(
        expectAsync1((signal) {
          check(signal).equals(io.ProcessSignal.sigkill);
          return Stream.empty();
        }),
      );

      final host = ProcessHost();
      host.watch(ProcessSignal.sigkill);
    });
  });

  test('echo (stdout) integration test', () async {
    final tool = p.join('tool', 'echo.dart');
    final host = ProcessHost();
    final proc = await host.start(tool, ['stdout']);

    proc.stdin.writeln('1');
    proc.stdin.writeln('2');
    proc.stdin.writeln('3');

    await check(
      proc.stdoutText.transform(const LineSplitter()),
    ).withQueue.inOrder([
      (s) => s.emits((e) => e.equals('1')),
      (s) => s.emits((e) => e.equals('2')),
      (s) => s.emits((e) => e.equals('3')),
    ]);

    proc.kill();
  });

  test('echo (stderr) integration test', () async {
    final tool = p.join('tool', 'echo.dart');
    final host = ProcessHost();
    final proc = await host.start(tool, ['stderr']);

    proc.stdin.writeln('1');
    proc.stdin.writeln('2');
    proc.stdin.writeln('3');

    await check(
      proc.stderrText.transform(const LineSplitter()),
    ).withQueue.inOrder([
      (s) => s.emits((e) => e.equals('1')),
      (s) => s.emits((e) => e.equals('2')),
      (s) => s.emits((e) => e.equals('3')),
    ]);

    proc.kill();
  });

  test('echo (stderr) addError', () async {
    final tool = p.join('tool', 'echo.dart');
    final host = ProcessHost();
    final proc = await host.start(tool, ['stderr']);

    check(() => proc.stdin.addError('1')).throws<UnsupportedError>();
  });

  test('echo (stderr) addStream', () async {
    final tool = p.join('tool', 'echo.dart');
    final host = ProcessHost();
    final proc = await host.start(tool, ['stderr']);

    unawaited(
      proc.stdin.addStream(
        Stream.fromIterable([
          io.systemEncoding.encode('1\n'),
          io.systemEncoding.encode('2\n'),
          io.systemEncoding.encode('3\n'),
        ]),
      ),
    );

    await check(
      proc.stderrText.transform(const LineSplitter()),
    ).withQueue.inOrder([
      (s) => s.emits((e) => e.equals('1')),
      (s) => s.emits((e) => e.equals('2')),
      (s) => s.emits((e) => e.equals('3')),
    ]);
  });

  test('echo (stderr) close and done', () async {
    final tool = p.join('tool', 'echo.dart');
    final host = ProcessHost();
    final proc = await host.start(tool, ['stderr']);

    await check(proc.stdin.close()).completes();
    await check(proc.stdin.done).completes();
  });

  test('metronome integration test', () async {
    final tool = p.join('tool', 'metronome.dart');
    final host = ProcessHost();
    final proc = await host.start(tool, []);

    check(proc.processId).isGreaterThan(0);

    await check(
      proc.stdoutText.transform(const LineSplitter()),
    ).withQueue.inOrder([
      (s) => s.emits((e) => e.equals('1')),
      (s) => s.emits((e) => e.equals('2')),
      (s) => s.emits((e) => e.equals('3')),
    ]);

    proc.kill();
  });

  test('metronome (sigkill)', () async {
    final tool = p.join('tool', 'metronome.dart');
    final host = ProcessHost();
    final proc = await host.start(tool, []);

    check(proc.kill(ProcessSignal.sigkill)).isTrue();
  });

  test('exit integration test', () async {
    final tool = p.join('tool', 'exit.dart');
    final host = ProcessHost();
    final proc = await host.start(tool, ['1']);

    await check(proc.exitCode).completes((e) => e.equals(ExitCode.failure));
  });
}

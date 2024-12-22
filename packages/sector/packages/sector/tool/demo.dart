#!/usr/bin/env dart

import 'dart:io' as io;

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

void main(List<String> args) async {
  final results = _parser.parse(args);
  if (results.flag('help')) {
    io.stderr.writeln(_parser.usage);
    return;
  }

  final release = results.flag('release');
  if (release) {
    final flutter = await io.Process.start(
      'flutter',
      [
        'build',
        'web',
        '--release',
        '--output',
        p.absolute(results.option('out-dir')!),
        ...results.rest,
      ],
      workingDirectory: p.join('../', 'sector_demo'),
      mode: io.ProcessStartMode.inheritStdio,
    );
    await flutter.exitCode;
  } else {
    final flutter = await io.Process.start(
      'flutter',
      [
        'run',
        if (results.option('device') case final String device) ...[
          '-d',
          device,
        ],
        ...results.rest,
      ],
      workingDirectory: p.join('../', 'sector_demo'),
      mode: io.ProcessStartMode.inheritStdio,
    );
    await flutter.exitCode;
  }
}

final _parser = ArgParser()
  ..addFlag(
    'help',
    abbr: 'h',
    help: 'Prints this help message.',
    negatable: false,
  )
  ..addFlag(
    'release',
    abbr: 'r',
    help: 'Builds in (web) release mode.',
  )
  ..addOption(
    'device',
    abbr: 'd',
    help: 'The device to run the app on.',
    defaultsTo: io.Platform.isMacOS ? 'macos' : 'chrome',
  )
  ..addOption(
    'out-dir',
    abbr: 'o',
    help: 'Output directory for the release mode.',
    defaultsTo: p.join('build'),
  );

#!/usr/bin/env dart

import 'dart:convert';
import 'dart:io' as io;

import 'package:args/args.dart';
import 'package:path/path.dart' as p;

/// Runs benchmarks for the project.
void main(List<String> args) async {
  // Lookup all possible benchmarks.
  final allBenchmarks = io.Directory('benchmark')
      .listSync()
      .whereType<io.Directory>()
      .map((dir) => p.basename(dir.path))
      .where((name) => name != 'src')
      .toList();

  final parser = ArgParser(allowTrailingOptions: false)
    ..addFlag(
      'help',
      abbr: 'h',
      help: 'Prints this help message.',
      negatable: false,
    )
    ..addMultiOption(
      'benchmark',
      abbr: 'b',
      help: 'Which benchmark to run.',
      allowed: allBenchmarks,
    );

  final results = parser.parse(args);
  if (results.flag('help')) {
    io.stderr.writeln(parser.usage);
    return;
  }

  for (final suiteName in results.multiOption('benchmark')..sort()) {
    // Load the benchmark suite.
    final suiteDir = io.Directory(p.join('benchmark', suiteName));

    // Each Dart file in the directory is a benchmark.
    final benchmarks = suiteDir.listSync().whereType<io.File>().toList();
    final runs = <_BenchmarkRun>[];
    for (final benchmarkFile in benchmarks) {
      if (!benchmarkFile.path.endsWith('.dart')) {
        continue;
      }
      final benchmarkName = p.basenameWithoutExtension(benchmarkFile.path);

      // Run with 'dart run', and capture stdout.
      io.stderr.writeln('Running benchmark: $benchmarkName');
      final process = await io.Process.start('dart', [
        'run',
        benchmarkFile.path,
      ]);

      if (await process.exitCode != 0) {
        io.stderr.writeln('Failed to run benchmark: $benchmarkName');
        io.exitCode = 1;
        return;
      }

      // Parse the output as lines.
      final lines = await process.stdout
          .transform(const Utf8Decoder())
          .transform(const LineSplitter())
          .toList();

      // Parse the output as results.
      final results = <_BenchmarkResult>[];
      for (final line in lines) {
        final parts = line.split(':');
        if (parts.length != 3) {
          io.stderr.writeln('Invalid benchmark output: $line');
          io.exitCode = 1;
          return;
        }

        final name = parts[0];
        final benchmarkName = parts[1];
        final milliseconds = double.tryParse(parts[2].split(' ')[1].trim());
        if (milliseconds == null) {
          io.exitCode = 1;
          return;
        }

        results.add(_BenchmarkResult(name, benchmarkName, milliseconds));
      }

      runs.add(_BenchmarkRun(benchmarkName, benchmarkFile.uri, results));
    }

    // Create a markdown table of the results, and emit to suite/README.md
    //
    // Assume that all the runs have identical benchmarks, and can be
    // compared directly. Create a table with the benchmark names as the
    // rows, and the suite names as the columns. Highlight the fastest and
    // slowest times with bold and italics.
    final buffer = StringBuffer();

    // Header.
    buffer.writeln('# $suiteName');
    buffer.writeln();

    // Each benchmark as a ## header, or something like.
    //
    // ## Name
    //
    // | {{%%SUITE}} | Results | Delta   |
    // | ----------- | ------- | ------- |
    // | HashMap     | 0.11ms  | +xx% |
    // | HashSet     | 0.10ms  | -yy% |

    for (var i = 0; i < runs.first.results.length; i++) {
      final benchmark = runs.first.results[i].benchmark;
      buffer.writeln('## $benchmark');
      buffer.writeln();
      buffer.writeln('| Benchmark | Results | Delta |');
      buffer.writeln('| --------- | ------- | ----- |');

      final results = <String, double>{};
      for (final run in runs) {
        final result = run.results[i];
        results[result.name] = result.milliseconds;
      }

      final fastest = results.entries.reduce(
        (a, b) => a.value < b.value ? a : b,
      );
      final slowest = results.entries.reduce(
        (a, b) => a.value > b.value ? a : b,
      );

      for (final entry in results.entries) {
        final isFastest = entry.key == fastest.key;
        final isSlowest = entry.key == slowest.key;

        buffer.write('| `');
        buffer.write(entry.key);
        buffer.write('` | ');

        if (isFastest) {
          buffer.write('**');
        } else if (isSlowest) {
          buffer.write('*');
        }

        buffer.write(entry.value.toStringAsFixed(2));
        buffer.write('ms');

        if (isFastest) {
          buffer.write('**');
        } else if (isSlowest) {
          buffer.write('*');
        }

        buffer.write(' | ');

        if (isFastest) {
          buffer.write('+');
        } else if (isSlowest) {
          buffer.write('-');
        }

        final delta = ((entry.value - fastest.value) / fastest.value) * 100;
        buffer.write(delta.toStringAsFixed(2));
        buffer.write('%');

        buffer.writeln(' |');
      }
    }

    final readme = io.File(p.join(suiteDir.path, 'README.md'));
    await readme.writeAsString(buffer.toString());
  }
}

final class _BenchmarkRun {
  const _BenchmarkRun(this.name, this.runUrl, this.results);

  /// The name of the benchmark.
  final String name;

  /// The URL to the benchmark details.
  final Uri runUrl;

  /// The results.
  final List<_BenchmarkResult> results;
}

final class _BenchmarkResult {
  const _BenchmarkResult(this.name, this.benchmark, this.milliseconds);

  /// The name of the benchmark.
  final String name;

  /// The benchmark this result belongs to.
  final String benchmark;

  /// The time it took to run the benchmark in milliseconds.
  final double milliseconds;
}

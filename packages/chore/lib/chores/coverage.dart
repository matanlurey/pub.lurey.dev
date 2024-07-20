import 'dart:io' as io;

import 'package:chore/chore.dart';
import 'package:path/path.dart' as p;

/// Generates and returns a path to an `lcov.info` for code coverage reports.
Future<String> generateLcov({
  List<String> command = const ['dart', 'run', 'coverage:test_with_coverage'],
  String? outDir,
  Context? context,
}) async {
  return run(
    (context) async {
      outDir ??= (await context.use(getTempDir())).path;
      final [name, ...args] = command;
      final process = await startProcess(
        name,
        [
          ...args,
          '--out=$outDir',
        ],
      )(context);
      final exitCode = await process.exitCode;
      if (exitCode != 0) {
        throw io.ProcessException(
          name,
          args,
          'Failed to generate lcov.info file',
        );
      }
      return p.join(outDir!, 'lcov.info');
    },
    context: context,
  );
}

/// Generates and returns a path to an HTML coverage report.
Future<String> generateHtml({
  List<String> command = const ['genhtml'],
  String? lcovPath,
  String? outDir,
}) async {
  return run((context) async {
    lcovPath ??= p.join('coverage', 'lcov.info');
    outDir ??= p.join('coverage', 'html');
    final [name, ...args] = command;
    final process = await context.use(
      startProcess(
        name,
        [
          ...args,
          lcovPath!,
          '-o',
          outDir!,
        ],
      ),
    );
    final exitCode = await process.exitCode;
    if (exitCode != 0) {
      throw io.ProcessException(
        name,
        args,
        'Failed to generate HTML coverage report',
      );
    }
    return outDir!;
  });
}

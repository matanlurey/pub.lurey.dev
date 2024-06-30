import 'dart:convert';
import 'dart:io' as io;

import 'package:oath/src/tool.dart';
import 'package:path/path.dart' as p;
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

/// The mode to run `coverage` in.
enum CoverageMode {
  /// Generates the coverage report in `coverage`.
  generate,

  /// Generates the coverage report in a temporary directory and serves it.
  preview;
}

/// Runs the `coverage` tool with the given options.
///
/// - [command]: The command to run.
///   Defaults to `['dart', 'run', 'coverage:test_with_coverage']`.
///
/// - [mode]: The mode to run `coverage` in.
///   Defaults to [CoverageMode.generate].
Future<void> runCoverage({
  List<String> command = const ['dart', 'run', 'coverage:test_with_coverage'],
  List<String> generator = const ['genhtml'],
  CoverageMode mode = CoverageMode.generate,
  Toolbox? tools,
}) async {
  final isPreview = mode == CoverageMode.preview;
  return runTool(
    (tools) async {
      io.Directory? outputDir;
      if (isPreview) {
        outputDir = await tools.getTempDir('coverage');
      }
      final [name, ...args] = command;
      final coverage = await io.Process.start(
        name,
        [
          ...args,
          if (outputDir != null) '--out=${outputDir.path}',
        ],
      );
      tools.addCleanupTask(coverage.kill);

      coverage.stdout.transform(const Utf8Decoder()).listen(tools.stdout.write);
      coverage.stderr.transform(const Utf8Decoder()).listen(tools.stderr.write);

      final exitCode = await coverage.exitCode;
      if (exitCode != 0) {
        throw io.ProcessException(
          name,
          args,
          'Failed with exit code $exitCode.',
        );
      }
      if (mode == CoverageMode.preview) {
        outputDir!;

        // Generate the HTML report.
        final [genName, ...genArgs] = generator;
        final genhtml = await io.Process.start(
          genName,
          [
            ...genArgs,
            p.join(outputDir.path, 'lcov.info'),
            '-o',
            p.join(outputDir.path, 'html'),
          ],
        );
        tools.addCleanupTask(genhtml.kill);

        genhtml.stdout
            .transform(const Utf8Decoder())
            .listen(tools.stdout.write);
        genhtml.stderr
            .transform(const Utf8Decoder())
            .listen(tools.stderr.write);

        final genExitCode = await genhtml.exitCode;
        if (genExitCode != 0) {
          throw io.ProcessException(
            genName,
            genArgs,
            'Failed with exit code $genExitCode.',
          );
        }

        final handler = createStaticHandler(
          p.join(outputDir.path, 'html'),
          defaultDocument: 'index.html',
        );
        final server = await shelf_io.serve(handler, 'localhost', 0);
        tools.addCleanupTask(server.close);

        final url = 'http://localhost:${server.port}';
        tools.stdout.writeln('Serving coverage report at $url');

        await tools.forever();
      }
    },
  );
}

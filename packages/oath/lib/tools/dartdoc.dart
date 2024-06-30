import 'dart:convert';
import 'dart:io' as io;

import 'package:oath/src/tool.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

/// The mode to run `dartdoc` in.
enum DartdocMode {
  /// Generates the documentation in `doc/api`.
  generate,

  /// Generates the documentation in a temporary directory and serves it.
  preview;
}

/// Runs the `dartdoc` tool with the given options.
///
/// - [command]: The command to run. Defaults to `['dart', 'doc']`.
Future<void> runDartdoc({
  List<String> command = const ['dart', 'doc'],
  DartdocMode mode = DartdocMode.generate,
  Toolbox? tools,
}) async {
  final isPreview = mode == DartdocMode.preview;
  return runTool((tools) async {
    io.Directory? outputDir;
    if (isPreview) {
      outputDir = await tools.getTempDir('dartdoc');
    }
    final [name, ...args] = command;
    final dartdoc = await io.Process.start(
      name,
      [
        ...args,
        if (outputDir != null) '--output=${outputDir.path}',
      ],
    );
    tools.addCleanupTask(dartdoc.kill);

    dartdoc.stdout.transform(const Utf8Decoder()).listen(tools.stdout.write);
    dartdoc.stderr.transform(const Utf8Decoder()).listen(tools.stderr.write);

    final exitCode = await dartdoc.exitCode;
    if (exitCode != 0) {
      throw io.ProcessException(
        name,
        args,
        'Failed with exit code $exitCode.',
      );
    }
    if (mode == DartdocMode.preview) {
      outputDir!;
      final handler = createStaticHandler(
        outputDir.path,
        defaultDocument: 'index.html',
      );
      final server = await shelf_io.serve(handler, 'localhost', 0);
      tools.addCleanupTask(server.close);

      final url = 'http://localhost:${server.port}';
      tools.stdout.writeln('Serving documentation at $url');

      await tools.forever();
    }
  });
}

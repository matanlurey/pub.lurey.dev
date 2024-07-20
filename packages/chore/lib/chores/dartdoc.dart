import 'dart:io' as io;

import 'package:chore/chore.dart';

/// Generates and returns a path to a dartdoc output directory.
Future<String> generateDartdoc({
  List<String> command = const ['dart', 'doc'],
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
          '--output',
          outDir!,
        ],
      )(context);
      final exitCode = await process.exitCode;
      if (exitCode != 0) {
        throw io.ProcessException(
          name,
          args,
          'Failed to generate dartdoc output',
        );
      }
      return outDir!;
    },
    context: context,
  );
}

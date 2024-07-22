import 'dart:async';

import 'package:chore/chore.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';

/// Serves the given [path] on a local HTTP server.
Future<(Uri, Future<void>)> serve({
  required String path,
  bool open = false,
  int port = 8080,
  Context? context,
}) async {
  return run((context) async {
    final handler = createStaticHandler(path, defaultDocument: 'index.html');
    final server = await shelf_io.serve(handler, 'localhost', port);
    late final StreamSubscription<void> sub;
    sub = context.onDone.listen((_) async {
      await server.close(force: true);
      await sub.cancel();
    });

    final url = Uri.http('localhost:$port');
    if (open) {
      await context.use(openBrowser(url));
    }
    return (url, context.use(waitUntilTerminated()));
  });
}

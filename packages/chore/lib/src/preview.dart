import 'package:shelf/shelf_io.dart';
import 'package:shelf_static/shelf_static.dart';

/// Starts a simple web server that serves a directory.
Future<(Future<void> Function(), Uri)> preview({
  required String directory,
  required int port,
}) async {
  final handler = createStaticHandler(directory, defaultDocument: 'index.html');
  final server = await serve(handler, 'localhost', port);
  return (server.close, Uri.http('${server.address.host}:${server.port}'));
}

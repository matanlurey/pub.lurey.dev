import 'dart:convert';

import 'package:chore/src/internal/pub_service.dart';

import '_prelude.dart';

void main() {
  late PubService pubService;

  setUp(() {
    pubService = PubService(
      httpGet: (uri) async {
        // Pretend that:
        // package:exists exists
        // package:errorr causes an unexpected error
        // any other package does not exist
        //
        // The request is made to GET https://pub.dev/packages/{name}.json
        check(uri.scheme).equals('https');
        check(uri.host).equals('pub.dev');
        check(uri.pathSegments.first).equals('packages');

        final [name, extension] = uri.pathSegments[1].split('.');
        check(extension).equals('json');
        return switch (name) {
          'exists' => HttpResponse(
            statusCode: 200,
            body: utf8.encode('{"versions": ["1.0.0"]}'),
          ),
          'error' => HttpResponse(
            statusCode: 500,
            body: utf8.encode('Internal Server Error'),
          ),
          _ => HttpResponse(statusCode: 404, body: utf8.encode('Not Found')),
        };
      },
    );
  });

  test('could not find published package', () async {
    check(await pubService.fetchLatestVersion('not_found')).isNull();
  });

  test('error occurred finding package', () async {
    await check(pubService.fetchLatestVersion('error')).throws<StateError>(
      (e) => e.has((e) => e.toString(), 'toString()').containsInOrder([
        'Error fetching',
        'error',
        '500',
      ]),
    );
  });

  test('found published package', () async {
    check(await pubService.fetchLatestVersion('exists')).equals('1.0.0');
  });
}

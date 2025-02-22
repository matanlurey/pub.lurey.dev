// Adapted from <https://github.com/flutter/packages/blob/3515abab07d0bb2441277f43c2411c9b5e4ecf94/script/tool/lib/src/common/pub_version_finder.dart>.

import 'dart:io' as io;
import 'dart:typed_data';

import 'package:jsonut/jsonut.dart';

/// Interfaces with a pub host, such as `pub.dev`.
final class PubService {
  /// Creates a new pub service.
  ///
  /// The [pubHost] defaults to `https://pub.dev` if not provided.
  ///
  /// The [httpGet] function defaults to using `dart:io` if not provided.
  PubService({Uri? pubHost, Future<HttpResponse> Function(Uri)? httpGet})
    : _pubHost = pubHost ?? _defaultHost,
      _httpGet = httpGet ?? _defaultHttpGet;
  final Uri _pubHost;
  static final _defaultHost = Uri(scheme: 'https', host: 'pub.dev');

  final Future<HttpResponse> Function(Uri) _httpGet;
  static Future<HttpResponse> _defaultHttpGet(Uri uri) async {
    final client = io.HttpClient();
    try {
      final request = await client.getUrl(uri);
      final response = await request.close();
      final builder = BytesBuilder(copy: false);
      await response.forEach(builder.add);
      return HttpResponse(
        statusCode: response.statusCode,
        body: builder.takeBytes(),
      );
    } finally {
      client.close();
    }
  }

  /// Fetches the latest version of a package from the pub host.
  ///
  /// If the package is not found, returns `null`.
  Future<String?> fetchLatestVersion(String package) async {
    final uri = _pubHost.replace(path: '/packages/$package.json');
    final response = await _httpGet(uri);
    return switch (response.statusCode) {
      404 => null,
      200 => response.decodeAsJson()['versions'].array().first.string(),
      _ => throw StateError('Error fetching $package: ${response.statusCode}'),
    };
  }
}

/// A minimal HTTP response.
final class HttpResponse {
  /// Creates a new HTTP response.
  const HttpResponse({required this.statusCode, required this.body});

  /// The status code of the response.
  final int statusCode;

  /// The response body.
  final Uint8List body;

  /// Decodes the body as a JSON object.
  JsonObject decodeAsJson() => JsonObject.parseUtf8(body);
}

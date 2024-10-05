import 'package:sdk/src/architecture.dart';
import 'package:sdk/src/channel.dart';
import 'package:sdk/src/operating_system.dart';
import 'package:sdk/src/semantic_version.dart';

/// Resolves a URL to fetch a release of the Dart SDK.
abstract interface class RemoteSdkUrls {
  /// Creates a default instance of [RemoteSdkUrls].
  factory RemoteSdkUrls({Uri baseUrl}) = _RemoteSdkUrls;

  /// Returns a URL to download an archive of the Dart SDK.
  ///
  /// - [channel]: The channel of the SDK release.
  /// - [operatingSystem]: The operating system the SDK is available for.
  /// - [architecture]: The architecture the SDK is available for.
  ///
  /// If [version] is provided, the URL will point to the specific version of
  /// the SDK. Otherwise, the URL will point to the latest release of the SDK
  /// for the given [channel], [operatingSystem], and [architecture].
  Uri getArchive({
    required Channel channel,
    required OperatingSystem operatingSystem,
    required Architecture architecture,
    SemanticVersion version = SemanticVersion.latest,
  });

  /// Returns a URL of the SHA256 checksum for the SDK archive.
  ///
  /// - [channel]: The channel of the SDK release.
  /// - [operatingSystem]: The operating system the SDK is available for.
  /// - [architecture]: The architecture the SDK is available for.
  ///
  /// If [version] is provided, the URL will point to the specific version of
  /// the SDK. Otherwise, the URL will point to the latest release of the SDK
  /// for the given [channel], [operatingSystem], and [architecture].
  Uri getChecksum({
    required Channel channel,
    required OperatingSystem operatingSystem,
    required Architecture architecture,
    SemanticVersion version = SemanticVersion.latest,
  });
}

final class _RemoteSdkUrls implements RemoteSdkUrls {
  static final _defaultBaseUrl = Uri.https(
    'storage.googleapis.com',
    'dart-archive',
  );

  _RemoteSdkUrls({
    Uri? baseUrl,
  }) : _baseUrl = baseUrl ?? _defaultBaseUrl;

  final Uri _baseUrl;

  @override
  Uri getArchive({
    required Channel channel,
    required OperatingSystem operatingSystem,
    required Architecture architecture,
    SemanticVersion version = SemanticVersion.latest,
  }) {
    return _baseUrl.resolve(
      '/channels/${channel.name}'
      '/release'
      '/${version.name}'
      '/sdk'
      '/dartsdk-${operatingSystem.name}-${architecture.name}-release.zip',
    );
  }

  @override
  Uri getChecksum({
    required Channel channel,
    required OperatingSystem operatingSystem,
    required Architecture architecture,
    SemanticVersion version = SemanticVersion.latest,
  }) {
    final archive = getArchive(
      channel: channel,
      operatingSystem: operatingSystem,
      architecture: architecture,
      version: version,
    );
    return archive.replace(path: '${archive.path}.sha256sum');
  }
}

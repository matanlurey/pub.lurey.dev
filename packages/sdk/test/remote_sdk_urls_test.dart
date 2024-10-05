import 'package:sdk/sdk.dart';

import '_prelude.dart';

void main() {
  test('getArchive', () {
    final urls = RemoteSdkUrls();

    check(
      urls.getArchive(
        channel: Channel.stable,
        version: SemanticVersion.from(2, 12, 0),
        operatingSystem: OperatingSystem.linux,
        architecture: Architecture.x64,
      ),
    ).equals(
      Uri.https(
        'storage.googleapis.com',
        'channels/stable/release/2.12.0/sdk/dartsdk-linux-x64-release.zip',
      ),
    );
  });

  test('getChecksum', () {
    final urls = RemoteSdkUrls();

    check(
      urls.getChecksum(
        channel: Channel.stable,
        version: SemanticVersion.from(2, 12, 0),
        operatingSystem: OperatingSystem.linux,
        architecture: Architecture.x64,
      ),
    ).equals(
      Uri.https(
        'storage.googleapis.com',
        'channels/stable/release/2.12.0/sdk/dartsdk-linux-x64-release.zip.sha256sum',
      ),
    );
  });
}

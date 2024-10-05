import 'package:sdk/sdk.dart';

import '_prelude.dart';

void main() {
  test('SdkVersion', () {
    final version = SdkVersion(
      channel: Channel.stable,
      releasedOn: DateTime(2021, 1, 2),
      operatingSystem: OperatingSystem.linux,
      architecture: Architecture.x64,
      version: SemanticVersion.from(2, 12, 0),
    );

    check(version)
      ..has((v) => v.channel, 'channel').equals(Channel.stable)
      ..has((v) => v.releasedOn, 'releasedOn').equals(DateTime(2021, 1, 2))
      ..has(
        (v) => v.operatingSystem,
        'operatingSystem',
      ).equals(OperatingSystem.linux)
      ..has((v) => v.architecture, 'architecture').equals(Architecture.x64)
      ..has((v) => v.version, 'version').equals(SemanticVersion.from(2, 12, 0));
  });

  test('== and hashCode', () {
    final version = SdkVersion(
      channel: Channel.stable,
      releasedOn: DateTime(2021, 1, 2),
      operatingSystem: OperatingSystem.linux,
      architecture: Architecture.x64,
      version: SemanticVersion.from(2, 12, 0),
    );

    check(version)
      ..has(
        (v) =>
            v ==
            SdkVersion(
              channel: Channel.stable,
              releasedOn: DateTime(2021, 1, 2),
              operatingSystem: OperatingSystem.linux,
              architecture: Architecture.x64,
              version: SemanticVersion.from(2, 12, 0),
            ),
        '==',
      ).isTrue()
      ..has((v) => v.hashCode, 'hashCode').equals(
        SdkVersion(
          channel: Channel.stable,
          releasedOn: DateTime(2021, 1, 2),
          operatingSystem: OperatingSystem.linux,
          architecture: Architecture.x64,
          version: SemanticVersion.from(2, 12, 0),
        ).hashCode,
      );
  });

  test('SdkVersion.latest', () {
    final version = SdkVersion.latest(
      channel: Channel.stable,
      releasedOn: DateTime(2021, 1, 2),
      operatingSystem: OperatingSystem.linux,
      architecture: Architecture.x64,
    );

    check(version)
      ..has((v) => v.channel, 'channel').equals(Channel.stable)
      ..has((v) => v.releasedOn, 'releasedOn').equals(DateTime(2021, 1, 2))
      ..has(
        (v) => v.operatingSystem,
        'operatingSystem',
      ).equals(OperatingSystem.linux)
      ..has((v) => v.architecture, 'architecture').equals(Architecture.x64)
      ..has((v) => v.version, 'version').equals(SemanticVersion.latest);
  });

  test('toString()', () {
    final version = SdkVersion(
      channel: Channel.stable,
      releasedOn: DateTime(2021, 1, 2),
      operatingSystem: OperatingSystem.linux,
      architecture: Architecture.x64,
      version: SemanticVersion.from(2, 12, 0),
    );

    check(version).has((v) => v.toString(), 'toString')
      ..contains('channel: Channel.stable,')
      ..contains('releasedOn: 2021-01-02 00:00:00.000,')
      ..contains('operatingSystem: OperatingSystem.linux,')
      ..contains('architecture: Architecture.x64,')
      ..contains('version: SpecificVersion(2, 12, 0)');
  });
}

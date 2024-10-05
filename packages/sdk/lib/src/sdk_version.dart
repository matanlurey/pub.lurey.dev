import 'package:meta/meta.dart';

import 'package:sdk/src/architecture.dart';
import 'package:sdk/src/channel.dart';
import 'package:sdk/src/operating_system.dart';
import 'package:sdk/src/semantic_version.dart';

/// Represents a version of the Dart SDK.
@immutable
final class SdkVersion {
  /// Creates a new [SdkVersion] instance with the given properties.
  const SdkVersion({
    required this.channel,
    required this.releasedOn,
    required this.operatingSystem,
    required this.architecture,
    required this.version,
  });

  /// Creates a new [SdkVersion] instance with the latest [version].
  const SdkVersion.latest({
    required this.channel,
    required this.releasedOn,
    required this.operatingSystem,
    required this.architecture,
  }) : version = SemanticVersion.latest;

  /// Version of the Dart SDK.
  final SemanticVersion version;

  /// Channel of the Dart SDK.
  final Channel channel;

  /// Date when the SDK was released.
  final DateTime releasedOn;

  /// Operating system the SDK is available for.
  final OperatingSystem operatingSystem;

  /// Architecture the SDK is available for.
  final Architecture architecture;

  @override
  bool operator ==(Object other) {
    if (other is! SdkVersion) {
      return false;
    }
    if (other.version != version) {
      return false;
    }
    if (other.channel != channel) {
      return false;
    }
    if (other.releasedOn != releasedOn) {
      return false;
    }
    if (other.operatingSystem != operatingSystem) {
      return false;
    }
    if (other.architecture != architecture) {
      return false;
    }
    return true;
  }

  @override
  int get hashCode {
    return Object.hash(
      version,
      channel,
      releasedOn,
      operatingSystem,
      architecture,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer('SdkVersion(\n');
    buffer.writeln('  version: $version,');
    buffer.writeln('  channel: $channel,');
    buffer.writeln('  releasedOn: $releasedOn,');
    buffer.writeln('  operatingSystem: $operatingSystem,');
    buffer.writeln('  architecture: $architecture,');
    buffer.writeln(')');
    return buffer.toString();
  }
}

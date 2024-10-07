import 'package:meta/meta.dart';

/// Represents a version of the Dart SDK.
@immutable
sealed class SemanticVersion {
  /// The latest available version of the Dart SDK.
  static const latest = _LatestVersion();

  /// Creates a new [SemanticVersion] instance with the given properties.
  ///
  /// Each version number must be non-negative.
  factory SemanticVersion.from(
    int major,
    int minor,
    int patch, [
    String? preReleaseSuffix,
  ]) = SpecificVersion;

  /// Parses a version from [version].
  ///
  /// If [version] is `'latest'`, returns [latest].
  ///
  /// Otherwise, [version] must be in the format `major.minor.patch` or
  /// `major.minor.patch-suffix`.
  static SemanticVersion? tryParse(String version) {
    if (version == 'latest') {
      return latest;
    }
    return SpecificVersion.tryParse(version);
  }

  /// Parses a version from [version].
  ///
  /// If [version] is `'latest'`, returns [latest].
  ///
  /// [version] must be in the format `major.minor.patch` or
  /// `major.minor.patch-suffix`.
  factory SemanticVersion.parse(String version) {
    final parsed = tryParse(version);
    if (parsed == null) {
      throw ArgumentError.value(version, 'version', 'Invalid version');
    }
    return parsed;
  }

  /// Whether this version is the [latest] available.
  bool get isLatest;

  /// Human readable name of the version.
  String get name;
}

final class _LatestVersion implements SemanticVersion {
  @literal
  const _LatestVersion();

  @override
  bool get isLatest => true;

  @override
  String get name => 'latest';

  @override
  String toString() => 'SemanticVersion.latest';
}

/// Represents a specific version of the Dart SDK, not [SemanticVersion.latest].
final class SpecificVersion
    implements SemanticVersion, Comparable<SpecificVersion> {
  /// Creates a new [SpecificVersion] instance with the given properties.
  ///
  /// Each version number must be non-negative.
  factory SpecificVersion(
    int major,
    int minor,
    int patch, [
    String? preReleaseSuffix,
  ]) {
    RangeError.checkNotNegative(major, 'major');
    RangeError.checkNotNegative(minor, 'minor');
    RangeError.checkNotNegative(patch, 'patch');
    return SpecificVersion._(major, minor, patch, preReleaseSuffix);
  }

  /// Parses a version from [version].
  ///
  /// If [version] is not in the format `major.minor.patch` or
  /// `major.minor.patch-suffix`, returns `null`.
  static SpecificVersion? tryParse(String version) {
    final match = _pattern.firstMatch(version);
    if (match == null) {
      return null;
    }
    final major = int.parse(match[1]!);
    final minor = int.parse(match[2]!);
    final patch = int.parse(match[3]!);
    final preReleaseSuffix = match[4];
    return SpecificVersion(major, minor, patch, preReleaseSuffix);
  }

  /// Parses a version from [version].
  ///
  /// [version] must be in the format `major.minor.patch` or
  /// `major.minor.patch-suffix`.
  factory SpecificVersion.parse(String version) {
    final parsed = tryParse(version);
    if (parsed == null) {
      throw ArgumentError.value(version, 'version', 'Invalid version');
    }
    return parsed;
  }

  static final _pattern = RegExp(r'^(\d+)\.(\d+)\.(\d+)(?:-(\w+))?$');

  const SpecificVersion._(
    this.major,
    this.minor,
    this.patch,
    this.preReleaseSuffix,
  );

  /// Major version number.
  final int major;

  /// Minor version number.
  final int minor;

  /// Patch version number.
  final int patch;

  /// Additional pre-release version information.
  final String? preReleaseSuffix;

  @override
  bool get isLatest => false;

  @override
  String get name {
    final buffer = StringBuffer();
    buffer.write('$major.$minor.$patch');
    if (preReleaseSuffix != null) {
      buffer.write('-$preReleaseSuffix');
    }
    return buffer.toString();
  }

  @override
  bool operator ==(Object other) {
    if (other is! SpecificVersion) {
      return false;
    }
    return other.major == major &&
        other.minor == minor &&
        other.patch == patch &&
        other.preReleaseSuffix == preReleaseSuffix;
  }

  @override
  int get hashCode {
    return Object.hash(major, minor, patch, preReleaseSuffix);
  }

  @override
  int compareTo(SpecificVersion other) {
    var result = major.compareTo(other.major);
    if (result != 0) {
      return result;
    }
    result = minor.compareTo(other.minor);
    if (result != 0) {
      return result;
    }
    result = patch.compareTo(other.patch);
    if (result != 0) {
      return result;
    }
    if (preReleaseSuffix == null) {
      return other.preReleaseSuffix == null ? 0 : 1;
    }
    if (other.preReleaseSuffix == null) {
      return -1;
    }
    return preReleaseSuffix!.compareTo(other.preReleaseSuffix!);
  }

  @override
  String toString() {
    final buffer = StringBuffer('SpecificVersion(');
    buffer.write('$major, ');
    buffer.write('$minor, ');
    buffer.write('$patch');
    if (preReleaseSuffix != null) {
      buffer.write(', $preReleaseSuffix');
    }
    buffer.write(')');
    return buffer.toString();
  }
}

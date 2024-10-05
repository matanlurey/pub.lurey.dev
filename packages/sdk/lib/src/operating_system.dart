import 'package:meta/meta.dart';

/// Operating system that a Dart SDK release is available for.
@immutable
final class OperatingSystem {
  /// macOS operating system.
  static const macos = OperatingSystem._('macos');

  /// Linux operating system.
  static const linux = OperatingSystem._('linux');

  /// Windows operating system.
  static const windows = OperatingSystem._('windows');

  /// All officially supported operating systems.
  static const supported = [macos, linux, windows];

  /// Returns an operating system with the given [name].
  ///
  /// [name] is not required to be a supported operating system name.
  factory OperatingSystem.unsupported(String name) {
    return OperatingSystem.tryFrom(name) ?? OperatingSystem._(name);
  }

  const OperatingSystem._(this.name);

  /// Name of the operating system.
  final String name;

  /// Parses an operating system from [name].
  ///
  /// If [name] is not a valid operating system name, returns `null`.
  static OperatingSystem? tryFrom(String name) {
    for (final os in OperatingSystem.supported) {
      if (os.name == name) {
        return os;
      }
    }
    return null;
  }

  /// Parses an operating system from [name].
  ///
  /// The [name] must be a valid operating system name.
  factory OperatingSystem.from(String name) {
    final os = tryFrom(name);
    if (os == null) {
      throw ArgumentError.value(name, 'name', 'Invalid operating system name');
    }
    return os;
  }

  /// Whether this channel is official (supported).
  bool get isSupported => supported.contains(this);

  @override
  bool operator ==(Object other) {
    return other is OperatingSystem && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return isSupported
        ? 'OperatingSystem.$name'
        : 'OperatingSystem.unsupported($name)';
  }
}

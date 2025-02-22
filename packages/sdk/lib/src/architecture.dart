import 'package:meta/meta.dart';

/// Architectures that a Dart SDK release is available for.
@immutable
final class Architecture {
  /// x64 architecture.
  static const x64 = Architecture._('x64');

  /// ARM64 architecture.
  static const arm64 = Architecture._('arm64');

  /// ARMv8 architecture.
  static const armv8 = Architecture._('armv8');

  /// ARMv7 architecture.
  static const armv7 = Architecture._('armv7');

  /// IA32 architecture.
  static const ia32 = Architecture._('ia32');

  /// RISC-V architecture.
  static const riscv = Architecture._('riscv');

  /// All officially supported architectures.
  static const supported = [x64, arm64, armv8, armv7, ia32, riscv];

  /// Returns an architecture with the given [name].
  ///
  /// [name] is not required to be a supported architecture name.
  factory Architecture.unsupported(String name) {
    return Architecture.tryFrom(name) ?? Architecture._(name);
  }

  const Architecture._(this.name);

  /// Name of the architecture.
  final String name;

  /// Parses an architecture from [name].
  ///
  /// If [name] is not a valid architecture name, returns `null`.
  static Architecture? tryFrom(String name) {
    for (final arch in Architecture.supported) {
      if (arch.name == name) {
        return arch;
      }
    }
    return null;
  }

  /// Parses an architecture from [name].
  ///
  /// The [name] must be a valid architecture name.
  factory Architecture.from(String name) {
    final arch = tryFrom(name);
    if (arch == null) {
      throw ArgumentError.value(name, 'name', 'Invalid architecture name');
    }
    return arch;
  }

  /// Whether this architecture is official (supported).
  bool get isSupported => supported.contains(this);

  @override
  bool operator ==(Object other) {
    return other is Architecture && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return isSupported
        ? 'Architecture.$name'
        : 'Architecture.unsupported($name)';
  }
}

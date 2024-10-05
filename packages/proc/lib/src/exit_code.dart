import 'package:meta/meta.dart';

/// Represents an exit code.
///
/// Exit codes are used to indicate the success or failure of a process.
///
/// The default exit code for success is [ExitCode.success] and for failure is
/// [ExitCode.failure]. However, other exit codes can be used to represent
/// differnent failure modes by providing a custom integer value to
/// [ExitCode.from].
@immutable
final class ExitCode {
  /// Represents a successful exit code.
  static const success = ExitCode._(0);

  /// Represents a failure exit code.
  ///
  /// Note that this is not the only possible failure code, but a default one.
  static const failure = ExitCode._(1);

  /// Creates an exit code from an integer exit [code] value.
  factory ExitCode.from(int code) = ExitCode._;

  const ExitCode._(this.code);

  /// Raw exit code.
  final int code;

  /// Whether this exit code represents a successful execution.
  bool get isSuccess => code == 0;

  /// Whether this exit code represents a failed execution.
  bool get isFailure => !isSuccess;

  @override
  bool operator ==(Object other) => other is ExitCode && other.code == code;

  @override
  int get hashCode => code.hashCode;

  @override
  String toString() => 'ExitCode <$code>';
}

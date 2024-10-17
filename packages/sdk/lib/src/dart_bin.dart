import 'package:async/async.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:jsonut/jsonut.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:proc/proc.dart';
import 'package:sdk/sdk.dart';

/// Represents the `dart` binary.
///
/// This class is used to interact with the `dart` binary, such as running Dart
/// scripts, compiling Dart code, and running Dart tests; as well as to access
/// information about the Dart SDK.
interface class Dart {
  /// Creates a reference to the `dart` binary at the given path.
  factory Dart.fromPath(String binPath) = Dart._;
  Dart._(this.binPath);

  /// Path to the `dart` binary.
  final String binPath;

  /// SDK that the `dart` binary is part of.
  late final sdk = DartSdk.fromPath(p.dirname(p.dirname(binPath)));

  /// Analyze Dart code using `dart analyze`.
  Stream<Diagnostic> analyze(
    String directory, {
    ProcessHost? host,
  }) {
    host ??= ProcessHost();

    // Using StreamCompleter.
    // ignore: discarded_futures
    return StreamCompleter.fromFuture(_analyze(directory, host: host));
  }

  Future<Stream<Diagnostic>> _analyze(
    String directory, {
    required ProcessHost host,
  }) async {
    final process = await host.start(
      binPath,
      [
        'analyze',
        '--format=machine',
        directory,
      ],
    );
    return process.stdoutText.map((t) {
      final diagnostic = Diagnostic.tryParsePipe(t);
      if (diagnostic == null) {
        throw FormatException('Invalid diagnostic', t);
      }
      return diagnostic;
    });
  }

  /// Format files using `dart format`.
  ///
  /// If any changes where made, the return value will be `true`.
  ///
  /// May optionally specify a process [host] to use for running; otherwise, a
  /// default will be used.
  Future<bool> format(Iterable<String> paths, {ProcessHost? host}) async {
    host ??= ProcessHost();
    final process = await host.start(
      binPath,
      [
        'format',
        '--set-exit-if-changed',
        ...paths,
      ],
    );
    return await process.exitCode != ExitCode.success;
  }

  /// Return which files would be changed by `dart format`.
  ///
  /// If no files would be changed, the stream will be empty.
  ///
  /// May optionally specify a process [host] to use for running; otherwise, a
  /// default will be used.
  Stream<String> formatCheck(
    Iterable<String> paths, {
    ProcessHost? host,
  }) {
    host ??= ProcessHost();
    // Using StreamCompleter.
    // ignore: discarded_futures
    final future = _formatCheck(paths, host: host);
    return StreamCompleter.fromFuture(future).where((line) {
      return line.startsWith('{');
    }).map((line) {
      final object = JsonObject.parse(line);
      return object['path'].string();
    });
  }

  Future<Stream<String>> _formatCheck(
    Iterable<String> paths, {
    required ProcessHost host,
  }) async {
    final process = await host.start(
      binPath,
      [
        'format',
        '--output=json',
        '--show=changed',
        '--set-exit-if-changed',
        ...paths,
      ],
    );
    return process.stdoutText;
  }

  /// Result of `dart --version`.
  Future<SdkVersion> version({
    ProcessHost? host,
  }) async {
    host ??= ProcessHost();
    final process = await host.start(binPath, ['--version']);
    final version = (await process.stdoutText.join()).trim();
    final match = _versionPattern.firstMatch(version);
    if (match == null) {
      throw FormatException('Invalid version output', version);
    }
    final DateTime releasedOn;
    try {
      releasedOn = DateFormat(
        'E MMM d HH:mm:ss yyyy Z',
      ).parse(match[3]!);
    } on FormatException {
      throw FormatException('Invalid release date', match[3]);
    }
    return SdkVersion(
      channel: Channel.from(match[2]!),
      version: SpecificVersion.parse(match[1]!),
      releasedOn: releasedOn,
      operatingSystem: OperatingSystem.from(match[4]!),
      architecture: Architecture.from(match[5]!),
    );
  }

  /// Parses `Dart SDK version: 3.5.1 (stable) (Tue Aug 13 21:02:17 2024 +0000) on "macos_arm64"`.
  ///                           ^^^^^  ^^^^^^   ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^      ^^^^^ ^^^^^
  ///                          version channel  date                                os    arch
  static final _versionPattern = RegExp(
    r'^Dart SDK version: (\d+\.\d+\.\d+) \((\w+)\) \((.+)\) on \"(.+)_(.+)\"$',
  );
}

/// Diagnostic information from the analyzer.
@immutable
final class Diagnostic {
  /// Creates a new diagnostic.
  const Diagnostic({
    required this.severity,
    required this.type,
    required this.code,
    required this.path,
    required this.line,
    required this.column,
    required this.length,
    required this.message,
  });

  /// Parses a diagnostic from a pipe-separated message.
  ///
  /// If the message is not in the expected format, returns `null`.
  ///
  /// ## Format
  ///
  /// ```txt
  /// SEVERITY|TYPE|ERROR_CODE|FILE_PATH|LINE|COLUMN|LENGTH|ERROR_MESSAGE
  /// ```
  static Diagnostic? tryParsePipe(String pipeSeparatedMessage) {
    final parts = pipeSeparatedMessage.split('|');
    if (parts.length != 8) {
      return null;
    }
    return Diagnostic(
      severity: Severity.from(parts[0].toLowerCase()),
      type: parts[1],
      code: parts[2],
      path: parts[3],
      line: int.parse(parts[4]),
      column: int.parse(parts[5]),
      length: int.parse(parts[6]),
      message: parts[7],
    );
  }

  /// Parses a diagnostic from a JSON object.
  ///
  /// If the object is not in the expected format, returns `null`.
  static Diagnostic? tryParseJson(JsonObject object) {
    return object.convert((o) {
      return Diagnostic(
        severity: Severity.from(o['severity'].string()),
        type: o['type'].string(),
        code: o['code'].string(),
        path: o['path'].string(),
        line: o['line'].number().toInt(),
        column: o['column'].number().toInt(),
        length: o['length'].number().toInt(),
        message: o['message'].string(),
      );
    });
  }

  /// Severity of the diagnostic.
  final Severity severity;

  /// Type of the diagnostic.
  final String type;

  /// Code of the diagnostic.
  final String code;

  /// Path to the file that the diagnostic is in.
  final String path;

  /// Line number of the diagnostic.
  final int line;

  /// Column number of the diagnostic.
  final int column;

  /// Length of the diagnostic.
  final int length;

  /// Message of the diagnostic.
  final String message;

  @override
  bool operator ==(Object other) {
    return other is Diagnostic &&
        other.severity == severity &&
        other.type == type &&
        other.code == code &&
        other.path == path &&
        other.line == line &&
        other.column == column &&
        other.length == length &&
        other.message == message;
  }

  @override
  int get hashCode {
    return Object.hash(
      severity,
      type,
      code,
      path,
      line,
      column,
      length,
      message,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln('Diagnostic(');
    buffer.writeln('  severity: $severity,');
    buffer.writeln('  type: $type,');
    buffer.writeln('  code: $code,');
    buffer.writeln('  path: $path,');
    buffer.writeln('  line: $line,');
    buffer.writeln('  column: $column,');
    buffer.writeln('  length: $length,');
    buffer.writeln('  message: $message,');
    buffer.write(')');
    return buffer.toString();
  }
}

/// Severity of an analyzer diagnostic.
@immutable
final class Severity {
  /// Error severity.
  static const error = Severity._('error');

  /// Warning severity.
  static const warning = Severity._('warning');

  /// Info severity.
  static const info = Severity._('info');

  /// Returns a severity with the given [name], or `null` if not found.
  static Severity? tryFrom(String name) {
    return switch (name) {
      'error' => error,
      'warning' => warning,
      'info' => info,
      _ => null,
    };
  }

  /// Returns a severity with the given [name].
  ///
  /// The name must be a valid severity name.
  factory Severity.from(String name) {
    final severity = tryFrom(name);
    if (severity == null) {
      throw ArgumentError.value(name, 'name', 'Invalid severity name');
    }
    return severity;
  }

  const Severity._(this.name);

  /// Name of the severity.
  final String name;

  @override
  String toString() => 'Severity.$name';
}

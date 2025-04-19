import 'dart:io' as io;

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:proc/proc.dart';
import 'package:sdk/sdk.dart';

/// Default host system [Environment] implementation.
const Environment systemEnvironment = _SystemEnvironment();

/// Interface for accessing the external environment, such as files or I/O.
///
/// In the standard runtime, [systemEnvironment] provides a default
/// implementation of this interface that interacts with the real file system
/// and I/O. In tests, a fake implementation can be used to simulate different
/// scenarios with some or all functionality emulated.
abstract base class Environment {
  /// @nodoc
  const Environment();

  /// Hosts the current process and provides access to start processes.
  ProcessHost get processHost;

  /// The current process's standard input stream.
  io.Stdin get stdin;

  /// Returns the current Dart SDK.
  ///
  /// If the Dart SDK cannot be determined, returns `null`.
  ///
  /// The default implementation of this method returns the Dart SDK based on
  /// the `DART_HOME` environment variable, however, this can be overridden by
  /// subclasses to provide a different implementation.
  @mustCallSuper
  DartSdk? getDartSdk() {
    // Check DART_HOME.
    if (getEnv('DART_HOME') case final sdkPath?) {
      return DartSdk.fromPath(sdkPath);
    }
    return null;
  }

  /// Returns the contents of the given environment variable.
  ///
  /// If the environment variable is not set, returns `null`.
  String? getEnv(String name);

  /// Whether the current process is running in a continuous integration
  /// environment.
  bool get isCI => getEnv('CI') != null;
}

final class _SystemEnvironment extends Environment {
  const _SystemEnvironment();

  @override
  ProcessHost get processHost => _defaultHost;
  static final _defaultHost = ProcessHost();

  @override
  io.Stdin get stdin => io.stdin;

  @override
  DartSdk? getDartSdk() {
    if (super.getDartSdk() case final sdk?) {
      return sdk;
    }

    // Check the resolved executable.
    if (p.basenameWithoutExtension(io.Platform.resolvedExecutable) == 'dart') {
      return Dart.fromPath(io.Platform.resolvedExecutable).sdk;
    }

    return null;
  }

  @override
  String? getEnv(String name) {
    return io.Platform.environment[name];
  }
}

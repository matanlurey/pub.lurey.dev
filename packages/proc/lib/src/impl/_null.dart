// Intentionally not implemented.
// ignore_for_file: avoid_unused_constructor_parameters

import 'dart:convert';

import 'package:meta/meta.dart';
import 'package:proc/src/process_host.dart' as base;
import 'package:proc/src/process_run_mode.dart';

@internal
abstract final class ProcessHost extends base.ProcessHost {
  static const isSupported = false;

  factory ProcessHost({
    Encoding stdoutEncoding = utf8,
    Encoding stderrEncoding = utf8,
    String? workingDirectory,
    ProcessRunMode runMode = ProcessRunMode.normal,
    Map<String, String> environment = const {},
    bool includeParentEnvironment = true,
    bool runInShell = false,
  }) {
    throw UnsupportedError('No platform support for running processes.');
  }
}

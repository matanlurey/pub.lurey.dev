#!/usr/bin/env dart

import 'dart:io' as io;

/// Exits with the exit code provided as the first argument.
///
/// ## Usage
///
/// ```sh
/// ./tool/exit [code]
/// ```
void main(List<String> args) {
  final int code;
  switch (args) {
    case [final s]:
      code = int.tryParse(s) ?? 1;
    default:
      code = 0;
  }
  io.exitCode = code;
}

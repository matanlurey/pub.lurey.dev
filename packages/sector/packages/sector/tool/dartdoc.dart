#!/usr/bin/env dart

import 'dart:io' as io;

import 'package:chore/chore.dart';

/// Generates a coverage report for the project.
void main(List<String> args) async {
  final chore = Chore.withCommands(
    isCI: io.Platform.environment['CI'] == 'true',
    commands: [Dartdoc.new],
  );
  await chore.run(['dartdoc', ...args]);
}

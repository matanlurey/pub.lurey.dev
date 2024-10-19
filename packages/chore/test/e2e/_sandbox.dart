import 'dart:io' as io;

import 'package:meta/meta.dart';
import 'package:path/path.dart' as p;
import 'package:sdk/sdk.dart';
import 'package:strink/strink.dart';

import '../_prelude.dart' show fail;

/// Creates a new package in the sandbox.
Future<io.Directory> createPackage(
  String name, {
  required String libContents,
  required String testContents,
  @doNotSubmit bool debugRetainArtifacts = false,
  SemanticVersion? version,
}) async {
  // Resolve the version.
  final dartBin = Dart.fromPath(io.Platform.resolvedExecutable);
  version ??= await dartBin.sdk.version;

  // Create a parent directory for the package.
  final parent = await io.Directory.systemTemp.createTemp('sandbox');

  // Create the package directory.
  final package = io.Directory(p.join(parent.path, name));
  await package.create(recursive: true);

  // Add a pubspec.yaml file.
  {
    final pubspec = io.File(p.join(package.path, 'pubspec.yaml'));
    final writer = pubspec.openWrite();
    YamlSink(writer)
      ..writeKeyValue('name', name)
      ..writeNewline()
      ..startObjectOrList('environment')
      ..writeKeyValue('sdk', '^${version.name}')
      ..endObjectOrList()
      ..writeNewline()
      ..startObjectOrList('dev_dependencies')
      ..startObjectOrList('chore')
      ..writeKeyValue('path', p.absolute(p.current))
      ..endObjectOrList()
      ..endObjectOrList()
      ..writeNewline();

    await writer.close();
  }

  // Run dart pub add --dev test.
  {
    final result = await io.Process.run(
      dartBin.binPath,
      ['pub', 'add', '--dev', 'test'],
      workingDirectory: package.path,
    );
    if (result.exitCode != 0) {
      fail('Failed to add test package: ${result.stderr}');
    }
  }

  // Add a lib/{name}.dart file.
  {
    await io.Directory(p.join(package.path, 'lib')).create();
    final lib = io.File(p.join(package.path, 'lib', '$name.dart'));
    await lib.writeAsString(libContents);
  }

  // Add a test/add_test.dart file.
  {
    await io.Directory(p.join(package.path, 'test')).create();
    final test = io.File(p.join(package.path, 'test', 'example_test.dart'));
    await test.writeAsString(testContents);
  }

  return package;
}

/// Runs a command in the sandbox.
Future<void> runCommand(
  String executable,
  List<String> args, {
  required String workingDirectory,
}) async {
  final result = await io.Process.run(
    executable,
    args,
    workingDirectory: workingDirectory,
  );
  final exitCode = result.exitCode;
  if (exitCode != 0) {
    fail(
      'Command failed with exit code $exitCode: $executable ${args.join(' ')}'
      '\n'
      'Working directory: $workingDirectory'
      '\n'
      '\n'
      'STDERR:\n'
      '${result.stderr}',
    );
  }
}

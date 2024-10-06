import 'dart:async';
import 'dart:io' as io;

import 'package:args/command_runner.dart';
import 'package:dev/src/generators/github_package_workflow.dart';
import 'package:dev/src/parsers/dart_test_yaml.dart';
import 'package:dev/src/utils/find_root_dir.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// A command that generates output files.
final class GenerateCommand extends Command<void> {
  @override
  String get name => 'generate';

  @override
  String get description => 'Generate output files.';

  @override
  Future<void> run() async {
    // Check for arguments, each positional argument is a package name.
    final root = findRootDir();

    final List<String> packages;
    if (argResults!.rest.isEmpty) {
      final packagesDir = io.Directory(p.join(root, 'packages'));
      packages = packagesDir.listSync().whereType<io.Directory>().map((e) {
        return p.basename(e.path);
      }).toList();
    } else {
      packages = argResults!.rest;
    }

    for (final package in packages) {
      await _runForPackage(root, package);
    }
  }

  Future<void> _runForPackage(String root, String package) async {
    io.stderr.writeln('Generating files for package: $package');

    final packageDir = io.Directory(p.join(root, 'packages', package));
    if (!packageDir.existsSync()) {
      throw ArgumentError('Package not found: $package');
    }

    // Load the dart_test.yaml file.
    final testFile = io.File(p.join(packageDir.path, 'dart_test.yaml'));
    if (!testFile.existsSync()) {
      throw ArgumentError('Missing dart_test.yaml file in package: $package');
    }

    // Parse the dart_test.yaml file as YAML.
    final doc = loadYamlDocument(await testFile.readAsString());
    final yaml = DartTestYaml.from(doc);

    // Check what platforms are needed to test.
    final platforms = yaml.platforms.toSet();
    final hasChrome = platforms.contains('chrome');

    // Generate the workflow file.
    final workflowFile = io.File(
      p.join(
        root,
        '.github',
        'workflows',
        'package_$package.yaml',
      ),
    );
    await workflowFile.writeAsString(
      generateGithubPackageWorkflow(
        package: package,
        usesChrome: hasChrome,
      ),
    );
  }
}

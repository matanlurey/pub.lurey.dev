import 'dart:async';
import 'dart:io' as io;

import 'package:args/command_runner.dart';
import 'package:dev/src/generators/changelog_header.dart';
import 'package:dev/src/generators/github_package_workflow.dart';
import 'package:dev/src/generators/package_readme.dart';
import 'package:dev/src/generators/root_readme.dart';
import 'package:dev/src/parsers/dart_test_yaml.dart';
import 'package:dev/src/parsers/pubspec_yaml.dart';
import 'package:dev/src/sinks/file_sink.dart';
import 'package:dev/src/utils/find_root_dir.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

/// A command that generates output files.
final class GenerateCommand extends Command<void> {
  /// Creates a new generate command.
  GenerateCommand() {
    argParser.addFlag(
      'root',
      help: 'Whether to also generate repository-level files.',
    );
  }

  @override
  String get name => 'generate';

  @override
  String get description => 'Generate output files.';

  @override
  Future<void> run() async {
    // Check for arguments, each positional argument is a package name.
    final root = findRootDir();

    final bool genRoot;
    if (!argResults!.wasParsed('root')) {
      genRoot = argResults!.rest.isEmpty;
    } else {
      genRoot = argResults!.flag('root');
    }
    final List<String> packages;
    if (argResults!.rest.isEmpty) {
      final packagesDir = io.Directory(p.join(root, 'packages'));
      packages = packagesDir.listSync().whereType<io.Directory>().map((e) {
        return p.basename(e.path);
      }).toList();
      packages.sort();
    } else {
      packages = argResults!.rest;
    }

    for (final package in packages) {
      await _runForPackage(root, package);
    }

    if (genRoot) {
      await _writeRepoFiles();
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

    // Load the pubspec.yaml file.
    final pubspecFile = io.File(p.join(packageDir.path, 'pubspec.yaml'));
    if (!pubspecFile.existsSync()) {
      throw ArgumentError('Missing pubspec.yaml file in package: $package');
    }
    final pubspec = PubspecYaml.from(
      loadYamlDocument(await pubspecFile.readAsString()),
    );
    final pkg = Package(
      name: package,
      isPublishable: pubspec.isPublishable,
      description: pubspec.description,
    );

    // Generate the README file.
    final sink = FileSink.fromBaseDir(packageDir.path);
    await sink.writeRegions('README.md', {
      'BADGES': generatePackageReadmeRegion(pkg),
    });

    // Generate the CHANGELOG.md file.
    await sink.writeRegions('CHANGELOG.md', {
      'HEADER': generateChangelogHeader(),
    });
  }

  Future<void> _writeRepoFiles() async {
    // Find all the packages in the repository.
    final root = findRootDir();
    final packagesDir = io.Directory(p.join(root, 'packages'));
    final packages = <Package>[];
    for (final packageDir in packagesDir.listSync()) {
      if (packageDir is! io.Directory) {
        continue;
      }
      final package = p.basename(packageDir.path);
      final pubspec = io.File(p.join(packageDir.path, 'pubspec.yaml'));
      final doc = loadYamlDocument(await pubspec.readAsString());
      final yaml = PubspecYaml.from(doc);

      packages.add(
        Package(
          name: package,
          isPublishable: yaml.isPublishable,
          description: yaml.description,
        ),
      );
    }

    packages.sort((a, b) => a.name.compareTo(b.name));

    // Generate parts of the root README file.
    final sink = FileSink.fromBaseDir(root);
    await sink.writeRegions('README.md', {
      'PACKAGE_TABLE': generateRootReadmeRegion(packages),
    });
  }
}

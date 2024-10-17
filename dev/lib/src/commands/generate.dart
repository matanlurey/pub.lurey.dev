import 'dart:async';
import 'dart:io' as io;

import 'package:args/command_runner.dart';
import 'package:chore/chore.dart';
import 'package:dev/src/generators/changelog_header.dart';
import 'package:dev/src/generators/github_package_workflow.dart';
import 'package:dev/src/generators/package_readme.dart';
import 'package:dev/src/generators/root_readme.dart';
import 'package:dev/src/sinks/file_sink.dart';
import 'package:path/path.dart' as p;

/// A command that generates output files.
final class GenerateCommand extends Command<void> {
  /// Creates a new generate command.
  GenerateCommand(this._context) {
    argParser.addFlag(
      'root',
      help: 'Whether to also generate repository-level files.',
    );
  }

  final Context _context;

  @override
  String get name => 'generate';

  @override
  String get description => 'Generate output files.';

  @override
  Future<void> run() async {
    // Check for arguments, each positional argument is a package name.
    final bool genRoot;
    if (!argResults!.wasParsed('root')) {
      genRoot = argResults!.rest.isEmpty;
    } else {
      genRoot = argResults!.flag('root');
    }

    for (final package in await _context.resolvedPackages) {
      await _runForPackage(_context.rootDir, package);
    }

    if (genRoot) {
      await _writeRepoFiles();
    }
  }

  Future<void> _runForPackage(String root, Package package) async {
    // Generate the workflow file.
    final workflowFile = io.File(
      p.join(
        root,
        '.github',
        'workflows',
        'package_${package.name}.yaml',
      ),
    );
    await workflowFile.writeAsString(
      generateGithubPackageWorkflow(
        package: package.name,
        usesChrome: package.testDependencies.contains(TestDependency.chrome),
      ),
    );

    // Generate the README file.
    final sink = FileSink.fromBaseDir(package.path);
    await sink.writeRegions('README.md', {
      'PACKAGE_README_HEADER': generatePackageReadmeRegion(package),
    });

    // Generate the CHANGELOG.md file.
    await sink.writeRegions('CHANGELOG.md', {
      'HEADER': generateChangelogHeader(),
    });
  }

  Future<void> _writeRepoFiles() async {
    // Find all the packages in the repository.
    final packagesDir = io.Directory(p.join(_context.rootDir, 'packages'));
    final packages = <Package>[];
    for (final packageDir in packagesDir.listSync()) {
      if (packageDir is! io.Directory) {
        continue;
      }
      packages.add(await Package.resolve(packageDir.path));
    }

    packages.sort((a, b) => a.name.compareTo(b.name));

    // Generate parts of the root README file.
    final sink = FileSink.fromBaseDir(_context.rootDir);
    await sink.writeRegions('README.md', {
      'PACKAGE_TABLE': generateRootReadmeRegion(packages),
    });
  }
}

import 'dart:async';
import 'dart:io' as io;

import 'package:chore/chore.dart';
import 'package:chore/src/command/generators/changelog_header.dart';
import 'package:chore/src/command/generators/github_package_workflow.dart';
import 'package:chore/src/command/generators/package_readme.dart';
import 'package:chore/src/command/generators/root_readme.dart';
import 'package:chore/src/command/generators/sinks/file_sink.dart';
import 'package:path/path.dart' as p;

/// A command that generates output files.
final class Generate extends BaseCommand {
  /// Creates a new generate command.
  Generate(super.context, super.environment) {
    argParser
      ..addFlag(
        'root',
        help: 'Whether to also generate repository-level files.',
        defaultsTo: true,
      )
      ..addFlag('fail-if-changed', help: 'Fail if any files were changed.');
  }

  @override
  String get name => 'generate';

  @override
  List<String> get aliases => const ['gen'];

  @override
  String get description => 'Generate output files.';

  @override
  Future<void> run() async {
    // Check for arguments, each positional argument is a package name.
    final genRoot = argResults!.flag('root');

    // If --fail-if-changed is set, check if any files were changed.
    if (argResults!.flag('fail-if-changed')) {
      // If we start with a dirty state, this command will always fail.
      final result = await io.Process.run('git', [
        'status',
        '--porcelain',
      ], workingDirectory: context.rootDir);
      if (result.stdout.toString().isNotEmpty) {
        io.stderr.writeln(
          '❌ Cannot use --fail-if-changed with a dirty state. Please commit '
          'or stash your changes.',
        );
        io.exitCode = 1;
        return;
      }
    }

    for (final package in await context.resolve(globalResults!)) {
      await _runForPackage(context.rootDir, package);
    }

    if (genRoot) {
      await _writeRepoFiles();
    }

    // If --fail-if-changed is set, check if any files were changed.
    if (argResults!.flag('fail-if-changed')) {
      // Use git to check for changes.
      final result = await io.Process.run('git', [
        'status',
        '--porcelain',
      ], workingDirectory: context.rootDir);
      if (result.stdout.toString().isNotEmpty) {
        io.stderr.writeln(
          '❌ Generators are out of date. Run ./dev.sh generate',
        );

        // Print out which files were changed.
        final diffResult = await io.Process.run('git', [
          'diff',
          '--name-only',
          'HEAD',
        ], workingDirectory: context.rootDir);
        io.stderr.writeln('Uncomitted files:');
        for (final line in diffResult.stdout.toString().split('\n')) {
          if (line.isNotEmpty) {
            io.stderr.writeln('  - $line');
          }
        }

        io.exitCode = 1;
      } else {
        io.stderr.writeln('✅ Generators are up to date');
      }
    }
  }

  Future<void> _runForPackage(String root, Package package) async {
    // Generate the workflow file.
    final workflowFile = io.File(
      p.join(root, '.github', 'workflows', 'package_${package.name}.yaml'),
    );
    await workflowFile.writeAsString(
      generateGithubPackageWorkflow(
        package: package.name,
        publishable: package.isPublishable,
        usesChrome: package.testDependencies.contains(TestDependency.chrome),
        usesFlutter:
            package.isFlutterPackage ||
            package.nestedPackages.any((p) => p.isFlutterPackage),
        uploadCoverage: package.supportsCoverage,
      ),
    );

    // Generate the README file.
    final sink = FileSink.fromBaseDir(package.path);
    await sink.writeRegions('README.md', {
      'HEADER': generatePackageReadmeRegion(package),
      'CONTRIBUTING': generatePackageContributingSection(package),
    });

    // Generate the CHANGELOG.md file.
    await sink.writeRegions('CHANGELOG.md', {
      'HEADER': generateChangelogHeader(),
    });
  }

  Future<void> _writeRepoFiles() async {
    // Find all the packages in the repository.
    final packages = await Future.wait(
      context.allPossiblePackages.map(Package.resolve),
    );
    packages.sort((a, b) => a.name.compareTo(b.name));

    // Generate parts of the root README file.
    final sink = FileSink.fromBaseDir(context.rootDir);
    await sink.writeRegions('README.md', {
      'PACKAGE_TABLE': generateRootReadmeRegion(packages),
    });
  }
}

import 'dart:io' as io;

import 'package:chore/chore.dart';
import 'package:chore/src/internal/pub_service.dart';
import 'package:proc/proc.dart';

/// A command that publishes a package.
final class Publish extends BaseCommand {
  /// Creates a new publish command.
  Publish(
    super.context,
    super.environment, {
    PubService? pubService,
  }) : _pubService = pubService ?? PubService() {
    argParser.addFlag(
      'skip-if-already-published',
      defaultsTo: environment.isCI,
      help: 'Skip publishing if the current version is already published.',
    );
    argParser.addFlag(
      'confirm',
      defaultsTo: !environment.isCI,
      help: 'Confirm before publishing, even if there are no issues.',
    );
  }

  @override
  String get name => 'publish';

  @override
  String get description => 'Publishes packages.\n'
      '\n'
      'If no --packages are provided, all publishable packages are attempted.\n'
      '\n'
      'Locally, this uses stored pub credentials, and on CI, it uses the '
      'PUB_CREDENTIALS environment variable to authenticate.';

  /// Service to check the status of the package.
  final PubService _pubService;

  /// Whether to confirm before publishing.
  bool get _confirm => argResults!.flag('confirm');

  /// Whether to skip publishing if the current version is already published.
  bool get _skipIfAlreadyPublished {
    return argResults!.flag('skip-if-already-published');
  }

  @override
  Future<void> run() async {
    Iterable<Package> packages = await context.resolve(globalResults!);
    if (!globalResults!.wasParsed('packages')) {
      // Skip packages that are not publishable.
      packages = packages.where((package) => package.isPublishable);
    }
    for (final package in packages) {
      await _runForPackage(package);
    }
  }

  Future<void> _runForPackage(Package package) async {
    final dartBin = environment.getDartSdk()?.dart;
    if (dartBin == null) {
      throw StateError('Unable to find dart executable.');
    }

    // The package must be publishable and have a version.
    if (!package.isPublishable) {
      io.exitCode = 1;
      io.stderr.writeln('❌ ${package.name} is not publishable.');
      return;
    }
    if (package.version == null) {
      io.exitCode = 1;
      io.stderr.writeln('❌ ${package.name} has no version.');
      return;
    }

    // Check if the package is already published as the current version.
    if (_skipIfAlreadyPublished) {
      final publishedVersion = await _pubService.fetchLatestVersion(
        package.name,
      );
      if (publishedVersion == package.version) {
        io.stderr.writeln(
          '❕ ${package.name} is already published as ${package.version}.',
        );
        return;
      }
    }

    // Run dart publish.
    io.stderr.writeln('Publishing ${package.name}...');
    {
      final process = await environment.processHost.start(
        dartBin.binPath,
        [
          'pub',
          'lish',
          if (!_confirm) '--force',
        ],
        runMode: ProcessRunMode.inheritStdio,
        workingDirectory: package.path,
      );
      if ((await process.exitCode).isFailure) {
        io.exitCode = 1;
        io.stderr.writeln('❌ Publishing failed.');
      } else {
        io.stderr.writeln('✅ Publishing succeeded.');
      }
      io.stderr.writeln();
    }
  }
}

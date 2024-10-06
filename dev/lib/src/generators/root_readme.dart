import 'package:meta/meta.dart';

/// Describes the package.
@immutable
final class Package {
  /// Creates a new package description.
  const Package({
    required this.name,
    required this.isPublishable,
    required this.description,
  });

  /// Name of the package.
  final String name;

  /// Whether the package is publishable.
  final bool isPublishable;

  /// Description of the package.
  final String description;
}

/// Generates a region of the root README file.
String generateRootReadmeRegion(Iterable<Package> packages) {
  final buffer = StringBuffer();
  buffer.writeln();

  buffer.writeln('Project | Build | Version | Changelog | Description');
  buffer.writeln('------- | ----- | ------- | --------- | -----------');

  for (final package in packages) {
    buffer.write(_generateRelativePath(package.name));
    buffer.write(' | ');
    buffer.write(_generateBuildStatus(package.name));
    buffer.write(' | ');
    buffer.write(_generatePubStatus(package.name));
    buffer.write(' | ');
    buffer.write(_generateChangelog(package.name));
    buffer.write(' | ');
    buffer.write(package.description);
    buffer.writeln();
  }

  buffer.writeln();
  return buffer.toString();
}

String _generateRelativePath(String package) {
  return '[`$package`](./packages/$package)';
}

String _generateBuildStatus(String package) {
  return ''
      '[![Build status for package/$package]'
      '(https://github.com/matanlurey/pub.lurey.dev/actions/workflows/package_$package.yaml/badge.svg)]'
      '(https://github.com/matanlurey/pub.lurey.dev/actions/workflows/package_$package.yaml)';
}

String _generatePubStatus(String package) {
  return ''
      '[![Pub version for package/$package]'
      '(https://img.shields.io/pub/v/$package)]'
      '(https://pub.dev/packages/$package)';
}

String _generateChangelog(String package) {
  return '[CHANGELOG](./packages/$package/CHANGELOG.md)';
}

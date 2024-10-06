import 'package:dev/src/generators/root_readme.dart';

/// Generates a region of a package's README file.
String generatePackageReadmeRegion(Package package) {
  final buffer = StringBuffer();
  buffer.writeln('# `${package.name}`\n');
  buffer.writeln('${package.description}\n');

  // Table header.
  buffer.writeln('| ✅ Health | 🚀 Release | 📝 Docs | ♻️ Maintenance |');
  buffer.writeln('|:----------|:-----------|:--------|:--------------|');

  // Build status.
  buffer.write('| ');
  buffer.write(_generateBuildStatus(package.name));

  // Release status.
  buffer.write(' | ');
  if (package.isPublishable) {
    buffer.write(_generatePubStatus(package.name));
  } else {
    buffer.write('Unreleased');
  }

  // Documentation status.
  buffer.write(' | ');
  if (package.isPublishable) {
    buffer.write(_generateDartDocs(package.name));
  } else {
    buffer.write('Unreleased');
  }

  // Maintenance status.
  buffer.write(' | ');
  buffer.write(_githubIssues(package.name));
  buffer.write(' |');

  return buffer.toString();
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

String _generateDartDocs(String package) {
  return ''
      '[![Dart documentation for package/$package]'
      '(https://img.shields.io/badge/dartdoc-reference-blue.svg)]'
      '(https://pub.dev/documentation/$package)';
}

String _githubIssues(String package) {
  return ''
      '[![GitHub Issues for package/$package](https://img.shields.io/github/issues/matanlurey/pub.lurey.dev/pkg-$package?label=issues)]'
      '(https://github.com/matanlurey/pub.lurey.dev/issues?q=is%3Aopen+is%3Aissue+label%3Apkg-$package)';
}
